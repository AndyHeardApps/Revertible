import Foundation

/// Provides a simplified interface for registering changes managing reversions of a variable.
///
/// - Note  This class can only be used to manage reversions for instances of value types. The value type may be contained in a reference type, to be used as the `Root`, but the value to be tracked must be a value type.
///
/// This class is used to register modifications to a single value, and perform undo and redo actions on that value. Changes are stored in a stack on a last in - first out bases, and any undo actions are automatically converted into redo actions when applied.
///
/// There a several functions that allow for pushing and popping of additional scopes, which provides a way to group together sets of changes. This can be used in cases such as when a new screen is pushed, and content is modified, but not saved. A new scope can be pushed for the new screen, and when the changes are abandonded the scope can be undone and popped. A new scope is created using the ``pushNewScope()`` function and the ``undoAndPopCurrentScope()-8nyo4`` function and it's variants can be used to pop the scope.
///
/// There are a couple of different ways to use this class, each having it's own initializer.
///
/// 1. Direct
///
/// This involves a single value being provided to the ``init(_:debounceInterval:)`` initializer and tracked in place. Changes can be tracked by calling the ``append(_:)`` function, which will register those changes, and store them. The ``undo()-2yfov`` and ``redo()-3hmai`` functions can then be used to navigate through those changes.
///
/// ```
/// var value = MyStruct()
/// let controller = VersioningController(value)
/// value.id = UUID()
/// controller.append(value)
/// value = try controller.undo() // the same as controller.undo(&value)
/// ```
///
/// 2. Key path
///
/// This involves a parent object and a key path to the ``Versionable`` value to be tracked. This allows you to push updated values using either the ``append(_:)`` or ``append(root:)`` functions, and navigate the changes using the ``undo()-2yfov``, ``undo(root:)``, ``redo()-3hmai`` and ``redo(root:)`` functions.
///
/// If the parent object is a reference type, then the changes can be applied using the ``undo()-62e7m`` and ``redo()-1gfib`` functions, which applies the changes to the parent object directly without having to manually assign it.
///
/// ```
/// let model = MyReferenceModel()
/// let controller = VersioningController(on: model, at: \.myStruct)
/// model.myStruct.id = UUID()
/// controller.append(value) // or controller.append(root: model)
/// try controller.undo() // applied to the model directly.
/// ```
///
/// References to model in this case are stored weakly to avoid retain cycles.
///
/// Each initilizer has an optional debounce interval parameter, limiting the rate at which changes can be appended, so as to avoid each typed character being registered as a new change, making undo / redo very cumbersome.
///
/// There are also two initializers specifically for `@Observable` and `ObservableObject` instances that allow you to track a single property automatically, and post updates when the controller changes (``hasUndo``, ``scopeLevel`` etc.).
///
/// For observable types, declare a lazy instance of a controller in the `Observable` object:
///
/// ```swift
/// @ObservationIgnored
/// private(set) lazy var controller = VersioningController(
///     on: self,
///     at: \.state,
///     using: _$observationRegistrar
/// )
/// ```
///
/// For `ObservableObject` types, there is an overload of the standard root - key path initializer that uses the `objectWillChange` publisher to listen for and publish updates. This should also be declared lazily:
///
/// ```swift
/// private(set) lazy var controller = VersioningController(
///     on: self,
///     at: \.state
/// )
/// ```
public final class VersioningController<Root, Value, Failure>: @unchecked Sendable
where Root: Sendable,
      Value: Versionable & Sendable,
      Failure: Error
{

    // MARK: - Properties
    @Atomic private var stacks: [VersioningStack<Value>]
    @Atomic private var referenceValue: Value
    private let keyPath: WritableKeyPath<Root, Value> & Sendable
    private let updateRoot: (@Sendable (Value) -> Void)?
    private let didUpdate: (@Sendable () -> Void)?
    @Atomic private var debounce: Debounce<DebouncedValue>?

#if canImport(Combine)
    private var cancellables: Set<AnyCancellable> = []
#endif

    // MARK: - Initialiser
    fileprivate init(
        on root: Root,
        at keyPath: WritableKeyPath<Root, Value> & Sendable,
        debounceInterval: ContinuousClock.Duration?,
        updateRoot: (@Sendable (Value) -> Void)?,
        didUpdate: (@Sendable () -> Void)?
    ) {

        if Value.self is AnyClass.Type {
            assertionFailure("VersioningController can only be used on value types.")
        }

        self.stacks = [.init(tag: nil)]
        self.referenceValue = root[keyPath: keyPath]
        self.keyPath = keyPath
        self.updateRoot = updateRoot
        self.didUpdate = didUpdate
        self.debounce = debounceInterval.map {
            .init(duration: $0) { [weak self] in
                self?._append($0.value, tag: $0.tag)
            }
        }
    }

    private struct DebouncedValue: Sendable {
        let value: Value
        let tag: AnyHashableSendable?

        init(_ value: Value, tag: some Hashable & Sendable) {
            self.value = value
            self.tag = AnyHashableSendable(wrapped: tag)
        }

        init(_ value: Value) {
            self.value = value
            self.tag = nil
        }
    }

    deinit {
        #if canImport(Combine)
        cancellables.forEach { $0.cancel() }
        #endif
    }
}

// MARK: - Standard scope / status interface
extension VersioningController {

    private var currentStack: VersioningStack<Value> {
        get {
            $stacks {
                if let stack = $0.last {
                    return stack
                } else {
                    let stack = VersioningStack<Value>(tag: nil)
                    $0.append(stack)
                    return stack
                }
            }
        }
        set {
            $stacks {
                $0[$0.indices.upperBound-1] = newValue
            }
        }
    }

    /// Creates and pushes a new scope that all new actions are added to.
    public func pushNewScope() {
        stacks.append(.init(tag: currentStack.undoStack.last?.tag ?? currentStack.tag))
        didUpdate?()
    }

    private func discardCurrentScope() {
        $stacks {
            if $0.count > 1 {
                _ = $0.popLast()
            }
        }
        didUpdate?()
    }

    /// The current scope level, with the root being `0`.
    public var scopeLevel: Int {
        stacks.count-1
    }

    /// Whether the current scope has an undo action available to perform.
    public var hasUndo: Bool {
        currentStack.hasUndo
    }

    /// Whether the current scope has a redo action available to perform.
    public var hasRedo: Bool {
        currentStack.hasRedo
    }

    func reset() {
        stacks = [.init(tag: nil)]
    }
}

// MARK: - Appending
extension VersioningController {

    /// Attempts to append the changes from the provided value to the current scope. If no changes have been made then nothing is appended to the scope.
    /// - Parameters:
    ///   - newValue: The updated value to register changes on.
    public func append(_ newValue: Value) {

        $debounce {
            if $0 != nil {
                $0?.emit(value: .init(newValue))
            } else {
                _append(newValue, tag: nil)
            }
        }
    }

    /// Attempts to append the changes from the provided value to the current scope. If no changes have been made then nothing is appended to the scope.
    /// - Parameters:
    ///   - newValue: The updated value to register changes on.
    ///   - tag: Some tag to reference this version. This can be used later to apply reversions up to this tag.
    public func append(
        _ newValue: Value,
        tag: some Hashable & Sendable
    ) {

        $debounce {
            if $0 != nil {
                $0?.emit(value: .init(newValue, tag: tag))
            } else {
                _append(newValue, tag: .init(wrapped: tag))
            }
        }
    }

    /// Attempts to append the changes from the provided value to the current scope. If no changes have been made then nothing is appended to the scope.
    /// - Parameters:
    ///    - updatedRoot: The object owning the value to register changes for.
    public func append(root updatedRoot: Root) {
        append(updatedRoot[keyPath: keyPath])
    }

    /// Attempts to append the changes from the provided value to the current scope. If no changes have been made then nothing is appended to the scope.
    /// - Parameters:
    ///    - updatedRoot: The object owning the value to register changes for.
    ///    - tag: An optional tag to reference this version. This can be used later to apply reversions up to this tag.
    public func append(
        root updatedRoot: Root,
        tag: some Hashable & Sendable
    ) {
        append(
            updatedRoot[keyPath: keyPath],
            tag: tag
        )
    }

    private func _append(
        _ newValue: Value,
        tag: AnyHashableSendable?
    ) {

        if let tag {
            for index in stacks.indices {
                stacks[index].clear(tag: tag)
            }
        }

        $referenceValue {
            currentStack.append(
                currentValue: newValue,
                previousValue: $0,
                tag: tag

            )
            $0 = newValue
        }
        didUpdate?()
    }
}

extension VersioningController where Root: AnyObject {

    /// Applies all of the changes made in the transaction as a single modification and stores it in the history.
    /// - Parameter closure: The closure in which to make the modifications to the value, stored as a single modification.
    public func setWithTransaction<E: Error>(_ closure: (inout Value) throws(E) -> Void) throws(E) {
        try closure(&referenceValue)
        updateRoot?(referenceValue)
        append(referenceValue)
        didUpdate?()
    }

    /// Applies all of the changes made in the transaction as a single modification and stores it in the history.
    /// - Parameter closure: The closure in which to make the modifications to the value, stored as a single modification.
    public func setWithTransaction<E: Error>(_ closure: (inout Value) async throws(E) -> Void) async throws(E) {
        try await closure(&referenceValue)
        updateRoot?(referenceValue)
        append(referenceValue)
        didUpdate?()
    }
}

// MARK: - Tags
extension VersioningController {

    /// Updates the tag of the current version.
    /// - Parameter tag: Some tag to reference this version. This can be used later to apply reversions up to this tag.
    public func tagCurrentVersion(_ tag: some Hashable & Sendable) {
        for index in stacks.indices {
            stacks[index].clear(tag: .init(wrapped: tag))
        }
        currentStack.tagCurrentVersion(.init(wrapped: tag))
        didUpdate?()
    }

    /// Returns a the lists of tags in the current scope, one for the undo stack and one for the redo stack, including `nil` entries for untagged actions. If the scope level is not available, then `nil` is returned.
    /// - Parameter scopeLevel: The scope level to return tags for.
    /// - Returns: A tuple containing two arrays on `AnyHashable?`. One for the undo stack, one for the redo stack.
    public func tags(inScopeLevel scopeLevel: Int) -> (undo: [AnyHashable?], redo: [AnyHashable?])? {
        guard scopeLevel < stacks.count else {
            return nil
        }
        let undoTags = CollectionOfOne(stacks[scopeLevel].tag?.wrapped) + stacks[scopeLevel].undoStack.map(\.tag?.wrapped)
        let redoTags = stacks[scopeLevel].redoStack.map(\.tag?.wrapped)

        return (undoTags, redoTags)
    }
}

// MARK: - Internal interface

// MARK: Value type reversion
extension VersioningController {

    private func _undo() throws(ReversionError) -> Value {

        try currentStack.undo(&referenceValue)
        defer { didUpdate?() }
        return referenceValue
    }

    private func _undo(_ value: inout Value) throws(ReversionError) {
        try currentStack.undo(&referenceValue)
        value = referenceValue
        didUpdate?()
    }

    private func _undo(root: inout Root) throws(ReversionError) {
        try currentStack.undo(&referenceValue)
        root[keyPath: keyPath] = referenceValue
        didUpdate?()
    }

    private func _undo(to tag: some Hashable & Sendable) throws(ReversionError) -> Value {
        try currentStack.undo(&referenceValue, to: .init(wrapped: tag))
        defer { didUpdate?() }
        return referenceValue
    }

    private func _undo(
        _ value: inout Value,
        to tag: some Hashable & Sendable
    ) throws(ReversionError) {
        try currentStack.undo(&referenceValue, to: .init(wrapped: tag))
        value = referenceValue
        didUpdate?()
    }

    private func _undo(
        root: inout Root,
        to tag: some Hashable & Sendable
    ) throws(ReversionError) {
        try currentStack.undo(&referenceValue, to: .init(wrapped: tag))
        root[keyPath: keyPath] = referenceValue
        didUpdate?()
    }

    private func _popCurrentScope() throws(ReversionError) {
        guard stacks.count > 1 else {
            return
        }

        let firstItemTag = currentStack.undoStack.first?.tag
        var previousValue = referenceValue
        try currentStack.undoAll(&previousValue)

        _ = stacks.popLast()
        currentStack.append(
            currentValue: referenceValue,
            previousValue: previousValue,
            tag: firstItemTag
        )
        didUpdate?()
    }

    private func _undoCurrentScope() throws(ReversionError) -> Value {
        try currentStack.undoAll(&referenceValue)
        defer { didUpdate?() }
        return referenceValue
    }

    private func _undoCurrentScope(_ value: inout Value) throws(ReversionError) {
        try currentStack.undoAll(&referenceValue)
        value = referenceValue
        didUpdate?()
    }

    private func _undoCurrentScope(root: inout Root) throws(ReversionError) {
        try currentStack.undoAll(&referenceValue)
        root[keyPath: keyPath] = referenceValue
        didUpdate?()
    }

    private func _undoAndPopCurrentScope() throws(ReversionError) -> Value {
        let value = try _undoCurrentScope()
        discardCurrentScope()
        defer { didUpdate?() }
        return value
    }

    private func _undoAndPopCurrentScope(_ value: inout Value) throws(ReversionError) {
        try _undoCurrentScope(&value)
        discardCurrentScope()
        didUpdate?()
    }

    private func _undoAndPopCurrentScope(root: inout Root) throws(ReversionError) {
        try _undoCurrentScope(root: &root)
        discardCurrentScope()
        didUpdate?()
    }

    private func _redo() throws(ReversionError) -> Value {
        try currentStack.redo(&referenceValue)
        defer { didUpdate?() }
        return referenceValue
    }

    private func _redo(_ value: inout Value) throws(ReversionError) {
        try currentStack.redo(&referenceValue)
        value = referenceValue
        didUpdate?()
    }

    private func _redo(root: inout Root) throws(ReversionError) {
        try currentStack.redo(&referenceValue)
        root[keyPath: keyPath] = referenceValue
        didUpdate?()
    }

    private func _redo(to tag: some Hashable & Sendable) throws(ReversionError) -> Value {
        try currentStack.redo(&referenceValue, to: .init(wrapped: tag))
        defer { didUpdate?() }
        return referenceValue
    }

    private func _redo(
        _ value: inout Value,
        to tag: some Hashable & Sendable
    ) throws(ReversionError) {
        try currentStack.redo(&referenceValue, to: .init(wrapped: tag))
        value = referenceValue
        didUpdate?()
    }

    private func _redo(
        root: inout Root,
        to tag: some Hashable & Sendable
    ) throws(ReversionError) {
        try currentStack.redo(&referenceValue, to: .init(wrapped: tag))
        root[keyPath: keyPath] = referenceValue
        didUpdate?()
    }

    private func _redoCurrentScope() throws(ReversionError) -> Value {
        try currentStack.redoAll(&referenceValue)
        defer { didUpdate?() }
        return referenceValue
    }

    private func _redoCurrentScope(_ value: inout Value) throws(ReversionError) {
        try currentStack.redoAll(&referenceValue)
        value = referenceValue
        didUpdate?()
    }

    private func _redoCurrentScope(root: inout Root) throws(ReversionError) {
        try currentStack.redoAll(&referenceValue)
        root[keyPath: keyPath] = referenceValue
        didUpdate?()
    }
}

// MARK: Reference type reversion
extension VersioningController where Root: AnyObject {

    private func _undo() throws(ReversionError) {
        try currentStack.undo(&referenceValue)
        updateRoot?(referenceValue)
        didUpdate?()
    }

    private func _undo(to tag: some Hashable & Sendable) throws(ReversionError) {
        try currentStack.undo(&referenceValue, to: .init(wrapped: tag))
        updateRoot?(referenceValue)
        didUpdate?()
    }

    private func _undoCurrentScope() throws(ReversionError){
        try currentStack.undoAll(&referenceValue)
        updateRoot?(referenceValue)
        didUpdate?()
    }

    private func _undoAndPopCurrentScope() throws(ReversionError) {
        try currentStack.undoAll(&referenceValue)
        discardCurrentScope()
        updateRoot?(referenceValue)
        didUpdate?()
    }

    private func _redo() throws(ReversionError) {
        try currentStack.redo(&referenceValue)
        updateRoot?(referenceValue)
        didUpdate?()
    }

    private func _redo(to tag: some Hashable & Sendable) throws(ReversionError) {
        try currentStack.redo(&referenceValue, to: .init(wrapped: tag))
        updateRoot?(referenceValue)
        didUpdate?()
    }

    private func _redoCurrentScope() throws(ReversionError) {
        try currentStack.redoAll(&referenceValue)
        updateRoot?(referenceValue)
    }
}

// MARK: - Throwing

// MARK: Initializers
extension VersioningController where Failure == ReversionError {

    /// Creates a controller for direct registration of changes and application of reversions.
    /// - Parameters:
    ///   - value: The initial value to be tracked.
    ///   - debounceInterval: The debounce interval, indicating how much time must elapse between changes before they are stored. If `nil` then all changes are stored.
    public convenience init(
        _ value: Value,
        debounceInterval: ContinuousClock.Duration? = nil
    ) where Root == Value {
        self.init(
            on: value,
            at: \.self,
            debounceInterval: debounceInterval,
            updateRoot: nil,
            didUpdate: nil
        )
    }

    /// Creates  a controller that registers changes at a specific key path on a value type.
    /// - Parameters:
    ///   - root: The owning instance of the value to be tracked, such as some parent model.
    ///   - keyPath: The key path to the value to be tracked.
    ///   - debounceInterval: The debounce interval, indicating how much time must elapse between changes before they are stored. If `nil` then all changes are stored.
    public convenience init(
        on root: Root,
        at keyPath: WritableKeyPath<Root, Value> & Sendable,
        debounceInterval: ContinuousClock.Duration? = nil
    ) {

        self.init(
            on: root,
            at: keyPath,
            debounceInterval: debounceInterval,
            updateRoot: nil,
            didUpdate: nil
        )
    }

    /// Creates  a controller that registers changes at a specific key path on a reference type.
    /// - Parameters:
    ///   - root: The owning instance of the value to be tracked, such as some view model.
    ///   - keyPath: The key path to the value to be tracked.
    ///   - debounceInterval: The debounce interval, indicating how much time must elapse between changes before they are stored. If `nil` then all changes are stored.
    public convenience init(
        on root: Root,
        at keyPath: WritableKeyPath<Root, Value> & Sendable,
        debounceInterval: ContinuousClock.Duration? = nil
    ) where Root: AnyObject {

        self.init(
            on: root,
            at: keyPath,
            debounceInterval: debounceInterval,
            updateRoot: { [weak root] newValue in
                root?[keyPath: keyPath] = newValue
            },
            didUpdate: nil
        )

    }
}

// MARK: Value type reversion
extension VersioningController where Failure == ReversionError {

    /// Undo the last change, if possible.
    /// - Returns: The previously registered value.
    /// - Throws: Any `ReversionError` that occurs when applying the reversion.
    public func undo() throws(Failure) -> Value {
        try _undo()
    }
    
    /// Undo the last change, if possible.
    /// - Parameter value: The value to apply the undo to.
    /// - Throws: Any `ReversionError` that occurs when applying the reversion.
    public func undo(_ value: inout Value) throws(Failure) {
        try _undo(&value)
    }
    
    /// Undo the last change, if possible.
    /// - Parameter root: The parent object owning the value to apply the undo to.
    /// - Throws: Any `ReversionError` that occurs when applying the reversion.
    public func undo(root: inout Root) throws(Failure) {
        try _undo(root: &root)
    }

    /// Undo all the changes in the current scope up to the provided tag. If the tag cannot be found, nothing happens.
    ///
    /// Tags are applied to versions, so calling this function performs all of the undo action up to, but not including the tagged version, so that the version provided alongside the tag is returned.
    /// - Parameter tag: The tag to revert to.
    /// - Returns: The value once reversions have been applied. If the tag is not found, the unmodified value is returned.
    /// - Throws: Any `ReversionError` that occurs when applying the reversion.
    public func undo(to tag: some Hashable & Sendable) throws(Failure) -> Value {
        try _undo(to: tag)
    }

    /// Undo all the changes in the current scope up to the provided tag. If the tag cannot be found, nothing happens.
    ///
    /// Tags are applied to versions, so calling this function performs all of the undo action up to, but not including the tagged version, so that the version provided alongside the tag is set.
    /// - Parameters:
    ///   - value: The value to apply the undos to.
    ///   - tag: The tag to revert to.
    /// - Throws: Any `ReversionError` that occurs when applying the reversion.
    public func undo(
        _ value: inout Value,
        to tag: some Hashable & Sendable
    ) throws(Failure) {
        try _undo(&value, to: tag)
    }
    
    /// Undo all the changes in the current scope up to the provided tag. If the tag cannot be found, nothing happens.
    ///
    /// Tags are applied to versions, so calling this function performs all of the undo action up to, but not including the tagged version, so that the version provided alongside the tag is set.
    /// - Parameters:
    ///   - root: The parent object owning the value to apply the undos to.
    ///   - tag: The tag to revert to.
    /// - Throws: Any `ReversionError` that occurs when applying the reversion.
    public func undo(
        root: inout Root,
        to tag: some Hashable & Sendable
    ) throws(Failure) {
        try _undo(root: &root, to: tag)
    }

    /// Pops the current scope, squashing all changes in the scope into a single change and appending it to the previous scope. If this is called from the root scope, nothing happens.
    ///
    /// - Throws: Any `ReversionError` that occurs when applying the reversion.
    public func popCurrentScope() throws(Failure) {
        try _popCurrentScope()
    }

    /// Undo all changes in the current scope.
    /// - Returns: The initial value once all undos have been applied.
    /// - Throws: Any `ReversionError` that occurs when applying the reversion.
    public func undoCurrentScope() throws(Failure) -> Value {
        try _undoCurrentScope()
    }
    
    /// Undo all changes in the current scope.
    /// - Parameter value: The value to apply the undos to.
    /// - Throws: Any `ReversionError` that occurs when applying the reversion.
    public func undoCurrentScope(_ value: inout Value) throws(Failure) {
        try _undoCurrentScope(&value)
    }
    
    /// Undo all changes in the current scope.
    /// - Parameter root: The parent object owning the value to apply the undos to.
    /// - Throws: Any `ReversionError` that occurs when applying the reversion.
    public func undoCurrentScope(root: inout Root) throws(Failure) {
        try _undoCurrentScope(root: &root)
    }

    /// Undo all changes in the current scope and then discard it.
    /// - Returns: The initial value once all undos have been applied.
    /// - Throws: Any `ReversionError` that occurs when applying the reversion.
    public func undoAndPopCurrentScope() throws(Failure) -> Value {
        try _undoAndPopCurrentScope()
    }

    /// Undo all changes in the current scope and then discard it.
    /// - Parameter value: The value to apply the undos to.
    /// - Throws: Any `ReversionError` that occurs when applying the reversion.
    public func undoAndPopCurrentScope(_ value: inout Value) throws(Failure) {
        try _undoAndPopCurrentScope(&value)
    }

    /// Undo all changes in the current scope and then discard it.
    /// - Parameter root: The parent object owning the value to apply the undos to.
    /// - Throws: Any `ReversionError` that occurs when applying the reversion.
    public func undoAndPopCurrentScope(root: inout Root) throws(Failure) {
        try _undoAndPopCurrentScope(root: &root)
    }


    // MARK: Redo

    /// Redo the last undone change, if possible.
    /// - Returns: The value before the previous undo was applied.
    /// - Throws: Any `ReversionError` that occurs when applying the reversion.
    public func redo() throws(Failure) -> Value {
        try _redo()
    }

    /// Redo the last undone change, if possible.
    /// - Parameter value: The value to apply the redo to.
    /// - Throws: Any `ReversionError` that occurs when applying the reversion.
    public func redo(_ value: inout Value) throws(Failure) {
        try _redo(&value)
    }

    /// Redo the last change, if possible.
    /// - Parameter root: The parent object owning the value to apply the redo to.
    /// - Throws: Any `ReversionError` that occurs when applying the reversion.
    public func redo(root: inout Root) throws(Failure) {
        try _redo(root: &root)
    }

    /// Redo all the changes in the current scope up to and including the provided tag. If the tag cannot be found, nothing happens.
    ///
    /// Tags are applied to versions, so calling this function performs all of the redo action up to and including the tagged version, so that the version provided alongside the tag is returned.
    /// - Parameter tag: The tag to revert to.
    /// - Returns: The value once reversions have been applied. If the tag is not found, the unmodified value is returned.
    /// - Throws: Any `ReversionError` that occurs when applying the reversion.
    public func redo(to tag: some Hashable & Sendable) throws(Failure) -> Value {
        try _redo(to: tag)
    }

    /// Redo all the changes in the current scope up to and including the provided tag. If the tag cannot be found, nothing happens.
    ///
    /// Tags are applied to versions, so calling this function performs all of the redo action up to and including the tagged version, so that the version provided alongside the tag is set.
    /// - Parameters:
    ///   - value: The value to apply the redos to.
    ///   - tag: The tag to revert to.
    /// - Throws: Any `ReversionError` that occurs when applying the reversion.
    public func redo(
        _ value: inout Value,
        to tag: some Hashable & Sendable
    ) throws(Failure) {
        try _redo(&value, to: tag)
    }

    /// Redo all the changes in the current scope up to and including the provided tag. If the tag cannot be found, nothing happens.
    ///
    /// Tags are applied to versions, so calling this function performs all of the redo action up to and including the tagged version, so that the version provided alongside the tag is set.
    /// - Parameters:
    ///   - root: The parent object owning the value to apply the redos to.
    ///   - tag: The tag to revert to.
    /// - Throws: Any `ReversionError` that occurs when applying the reversion.
    public func redo(
        root: inout Root,
        to tag: some Hashable & Sendable
    ) throws(Failure) {
        try _redo(root: &root, to: tag)
    }

    /// Redo all changes in the current scope.
    /// - Returns: The latest value once all redos have been applied.
    /// - Throws: Any `ReversionError` that occurs when applying the reversion.
    public func redoCurrentScope() throws(Failure) -> Value {
        try _redoCurrentScope()
    }

    /// Redo all changes in the current scope.
    /// - Parameter value: The value to apply the redos to.
    /// - Throws: Any `ReversionError` that occurs when applying the reversion.
    public func redoCurrentScope(_ value: inout Value) throws(Failure) {
        try _redoCurrentScope(&value)
    }

    /// Redo all changes in the current scope.
    /// - Parameter root: The parent object owning the value to apply the redos to.
    /// - Throws: Any `ReversionError` that occurs when applying the reversion.
    public func redoCurrentScope(root: inout Root) throws(Failure) {
        try _redoCurrentScope(root: &root)
    }
}

// MARK: Reference type reversion
extension VersioningController where Root: AnyObject, Failure == ReversionError {

    /// Undo the last change on the root object.
    ///
    /// - Throws: Any `ReversionError` that occurs when applying the reversion.
    public func undo() throws(Failure) {
        try _undo()
    }

    /// Undo all the changes in the current scope up to the provided tag on the root object. If the tag cannot be found, nothing happens.
    ///
    /// Tags are applied to versions, so calling this function performs all of the undo action up to, but not including the tagged version, so that the version provided alongside the tag is set.
    /// - Parameter tag: The tag to revert to.
    /// - Throws: Any `ReversionError` that occurs when applying the reversion.
    public func undo(to tag: some Hashable & Sendable) throws(Failure) {
        try _undo(to: tag)
    }

    /// Undo all changes in the current scope on the root object.
    ///
    /// - Throws: Any `ReversionError` that occurs when applying the reversion.
    public func undoCurrentScope() throws(Failure) {
        try _undoCurrentScope()
    }

    /// Undo all changes in the current scope on the root object and then discard the current scope.
    ///
    /// - Throws: Any `ReversionError` that occurs when applying the reversion.
    public func undoAndPopCurrentScope() throws(Failure) {
        try _undoAndPopCurrentScope()
    }

    /// Redo the last undone change on the root object.
    ///
    /// - Throws: Any `ReversionError` that occurs when applying the reversion.
    public func redo() throws(Failure) {
        try _redo()
    }

    /// Redo all the changes in the current scope up and including to the provided tag on the root object. If the tag cannot be found, nothing happens.
    ///
    /// Tags are applied to versions, so calling this function performs all of the redo action up to and including the tagged version, so that the version provided alongside the tag is set.
    /// - Parameter tag: The tag to revert to.
    /// - Throws: Any `ReversionError` that occurs when applying the reversion.
    public func redo(to tag: some Hashable & Sendable) throws(Failure) {
        try _redo(to: tag)
    }

    /// Redo all changes in the current scope on the root object.
    /// - Throws: Any `ReversionError` that occurs when applying the reversion.
    public func redoCurrentScope() throws(Failure) {
        try _redoCurrentScope()
    }
}

// MARK: Combine
#if canImport(Combine)
@preconcurrency import Combine

extension VersioningController where Failure == ReversionError {

    /// Creates a controller that registers changes at a specific key path on an `ObservableObject` type, and observes the provided property, tracking all changes.
    ///
    /// This initializer subscribes to changes from the root object, and registers any changes. Whenever an undo, redo or scope action is made, the root object is notified so that any UI that depends on the controller can be updated.
    /// - Parameters:
    ///   - root: The owning instance of the value to be tracked, such as some view model.
    ///   - keyPath: The key path to the value to be tracked.
    ///   - debounceInterval: The debounce interval, indicating how much time must elapse between changes before they are stored. If `nil` then all changes are stored.
    public convenience init(
        on root: Root,
        at keyPath: WritableKeyPath<Root, Value> & Sendable,
        debounceInterval: ContinuousClock.Duration? = nil
    ) where
    Root: ObservableObject,
    Root.ObjectWillChangePublisher == ObservableObjectPublisher
    {
        let milliseconds = debounceInterval.map {
            Int(Double($0.components.seconds) * 1000 + Double($0.components.attoseconds) * 1e-15)
        }
        self.init(
            on: root,
            at: keyPath,
            debounceInterval: debounceInterval,
            updateRoot: { [weak root] newValue in
                root?[keyPath: keyPath] = newValue
            },
            didUpdate: { [weak publisher = root.objectWillChange] in
                publisher?.send()
            }
        )

        root.objectWillChange
            .debounce(
                for: .milliseconds(milliseconds ?? 1),
                scheduler: DispatchQueue.main
            )
            .compactMap { [weak root, keyPath] () -> Value? in
                root?[keyPath: keyPath]
            }
            .removeDuplicates()
            .sink { [weak self] newValue in
                guard let self, newValue != self.referenceValue else {
                    return
                }
                self._append(newValue, tag: nil)
            }
            .store(in: &cancellables)
    }
}
#endif

// MARK: Observation
#if canImport(Observation)
import Observation

extension VersioningController where Failure == ReversionError {

    /// Creates a controller that registers changes at a specific key path on an `Observable` type, and observes the provided property, tracking all changes.
    ///
    /// This initializer observes changes made to the specified key path, and registers any modifications. Whenever an undo, redo or scope action is made, the root object is notified so that any UI that depends on the controller can update.
    /// - Parameters:
    ///   - root: The owning instance of the value to be tracked, such as some view model.
    ///   - keyPath: The key path to the value to be tracked.
    ///   - observationRegistrar: The observation registrar of the `Observable` object, used to notify of any changes to this controller.
    ///   - debounceInterval: The debounce interval, indicating how much time must elapse between changes before they are stored. If `nil` then all changes are stored.
    public convenience init(
        on root: Root,
        at keyPath: WritableKeyPath<Root, Value> & Sendable,
        using observationRegistrar: ObservationRegistrar,
        debounceInterval: ContinuousClock.Duration? = nil
    ) where
    Root: AnyObject,
    Root: Observable
    {
        self.init(
            on: root,
            at: keyPath,
            debounceInterval: debounceInterval,
            updateRoot: { [weak root, keyPath] newValue in
                root?[keyPath: keyPath] = newValue
            },
            didUpdate: { [weak root, observationRegistrar, keyPath] in
                guard let root else {
                    return
                }
                observationRegistrar.willSet(root, keyPath: keyPath)
                observationRegistrar.didSet(root, keyPath: keyPath)
            }
        )

        observe(root: root, at: keyPath)
    }

    private func observe(root: Root?, at keyPath: WritableKeyPath<Root, Value> & Sendable)
    where Root: AnyObject,
          Root: Observable
    {
        withObservationTracking { [weak root, keyPath] in
            _ = root?[keyPath: keyPath]
        } onChange: { [weak self, weak root, keyPath] in
            Task { @MainActor in
                self?.append(root![keyPath: keyPath])
                self?.observe(root: root, at: keyPath)
            }
        }
    }
}
#endif
