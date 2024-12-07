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
public final class VersioningController<Root: Sendable, Value: Versionable & Sendable>: @unchecked Sendable {

    // MARK: - Properties
    @Atomic private var stacks: [VersioningStack<Value>]
    @Atomic private var referenceValue: Value
    private let keyPath: WritableKeyPath<Root, Value> & Sendable
    private let updateRoot: (@Sendable (Value) -> Void)?
    @Atomic private var debounce: Debounce<DebouncedValue>?

    // MARK: - Initialisers
    
    /// Creates a controller for direct registration of changes and application of reversions.
    /// - Parameters:
    ///   - value: The initial value to be tracked.
    ///   - debounceInterval: The debounce interval, indicating how much time must elapse between changes before they are stored. If `nil` then all changes are stored.
    public init(
        _ value: Value,
        debounceInterval: ContinuousClock.Duration? = nil
    ) where Root == Value {

        if Value.self is AnyClass.Type {
            assertionFailure("VersioningController can only be used on value types.")
        }

        self.stacks = [.init(tag: nil)]
        self.referenceValue = value
        self.keyPath = \.self
        self.updateRoot = nil
        self.debounce = debounceInterval.map {
            .init(duration: $0) { [weak self] in
                self?._append($0.value, tag: $0.tag)
            }
        }
    }
    
    /// Creates  a controller that registers changes at a specific key path on a value type.
    /// - Parameters:
    ///   - root: The owning instance of the value to be tracked, such as some parent model.
    ///   - keyPath: The key path to the value to be tracked.
    ///   - debounceInterval: The debounce interval, indicating how much time must elapse between changes before they are stored. If `nil` then all changes are stored.
    public init(
        on root: Root,
        at keyPath: WritableKeyPath<Root, Value> & Sendable,
        debounceInterval: ContinuousClock.Duration? = nil
    ) {

        if Value.self is AnyClass.Type {
            assertionFailure("VersioningController can only be used on value types.")
        }

        self.stacks = [.init(tag: nil)]
        self.referenceValue = root[keyPath: keyPath]
        self.keyPath = keyPath
        self.updateRoot = nil
        self.debounce = debounceInterval.map {
            .init(duration: $0) { [weak self] in
                self?._append($0.value, tag: $0.tag)
            }
        }
    }

    /// Creates  a controller that registers changes at a specific key path on a reference type.
    /// - Parameters:
    ///   - root: The owning instance of the value to be tracked, such as some view model.
    ///   - keyPath: The key path to the value to be tracked.
    ///   - debounceInterval: The debounce interval, indicating how much time must elapse between changes before they are stored. If `nil` then all changes are stored.
    public init(
        on root: Root,
        at keyPath: WritableKeyPath<Root, Value> & Sendable,
        debounceInterval: ContinuousClock.Duration? = nil
    ) where Root: AnyObject {

        if Value.self is AnyClass.Type {
            assertionFailure("VersioningController can only be used on value types.")
        }

        self.stacks = [.init(tag: nil)]
        self.referenceValue = root[keyPath: keyPath]
        self.keyPath = keyPath
        self.updateRoot = { [weak root] newValue in
            root?[keyPath: keyPath] = newValue
        }
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
}

// MARK: - Stack management
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
    }
    
    /// Pops the current scope, squashing all changes in the scope into a single change and appending it to the previous scope. If this is called from the root scope, nothing happens.
    public func popCurrentScope() throws {
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
    }

    private func discardCurrentScope() {
        $stacks {
            if $0.count > 1 {
                _ = $0.popLast()
            }
        }
    }

    /// The current scope level, with the root being `0`.
    public var scopeLevel: Int {
        stacks.count-1
    }

    func reset() {
        stacks = [.init(tag: nil)]
    }
}

// MARK: - Undo / redo
extension VersioningController {

    /// Whether the current scope has an undo action available to perform.
    public var hasUndo: Bool {
        currentStack.hasUndo
    }

    /// Whether the current scope has a redo action available to perform.
    public var hasRedo: Bool {
        currentStack.hasRedo
    }
}

// MARK: - Value type reversion
extension VersioningController {

    // MARK: Append

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
    
    /// Updates the tag of the current version.
    /// - Parameter tag: Some tag to reference this version. This can be used later to apply reversions up to this tag.
    public func tagCurrentVersion(_ tag: some Hashable & Sendable) {
        for index in stacks.indices {
            stacks[index].clear(tag: .init(wrapped: tag))
        }
        currentStack.tagCurrentVersion(.init(wrapped: tag))
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



    // MARK: Undo

    /// Undo the last change, if possible.
    /// - Returns: The previously registered value.
    public func undo() throws -> Value {
        try currentStack.undo(&referenceValue)
        return referenceValue
    }
    
    /// Undo the last change, if possible.
    /// - Parameter value: The value to apply the undo to.
    public func undo(_ value: inout Value) throws {
        try currentStack.undo(&referenceValue)
        value = referenceValue
    }
    
    /// Undo the last change, if possible.
    /// - Parameter root: The parent object owning the value to apply the undo to.
    public func undo(root: inout Root) throws {
        try currentStack.undo(&referenceValue)
        root[keyPath: keyPath] = referenceValue
    }


    
    /// Undo all the changes in the current scope up to the provided tag. If the tag cannot be found, nothing happens.
    ///
    /// Tags are applied to versions, so calling this function performs all of the undo action up to, but not including the tagged version, so that the version provided alongside the tag is returned.
    /// - Parameter tag: The tag to revert to.
    /// - Returns: The value once reversions have been applied. If the tag is not found, the unmodified value is returned.
    public func undo(to tag: some Hashable & Sendable) throws -> Value {
        try currentStack.undo(&referenceValue, to: .init(wrapped: tag))
        return referenceValue
    }

    /// Undo all the changes in the current scope up to the provided tag. If the tag cannot be found, nothing happens.
    ///
    /// Tags are applied to versions, so calling this function performs all of the undo action up to, but not including the tagged version, so that the version provided alongside the tag is set.
    /// - Parameters:
    ///   - value: The value to apply the undos to.
    ///   - tag: The tag to revert to.
    public func undo(
        _ value: inout Value,
        to tag: some Hashable & Sendable
    ) throws {
        try currentStack.undo(&referenceValue, to: .init(wrapped: tag))
        value = referenceValue
    }
    
    /// Undo all the changes in the current scope up to the provided tag. If the tag cannot be found, nothing happens.
    ///
    /// Tags are applied to versions, so calling this function performs all of the undo action up to, but not including the tagged version, so that the version provided alongside the tag is set.
    /// - Parameters:
    ///   - root: The parent object owning the value to apply the undos to.
    ///   - tag: The tag to revert to.
    public func undo(
        root: inout Root,
        to tag: some Hashable & Sendable
    ) throws {
        try currentStack.undo(&referenceValue, to: .init(wrapped: tag))
        return root[keyPath: keyPath] = referenceValue
    }



    /// Undo all changes in the current scope.
    /// - Returns: The initial value once all undos have been applied.
    public func undoCurrentScope() throws -> Value {
        try currentStack.undoAll(&referenceValue)
        return referenceValue
    }
    
    /// Undo all changes in the current scope.
    /// - Parameter value: The value to apply the undos to.
    public func undoCurrentScope(_ value: inout Value) throws {
        try currentStack.undoAll(&referenceValue)
        value = referenceValue
    }
    
    /// Undo all changes in the current scope.
    /// - Parameter root: The parent object owning the value to apply the undos to.
    public func undoCurrentScope(root: inout Root) throws {
        try currentStack.undoAll(&referenceValue)
        root[keyPath: keyPath] = referenceValue
    }



    /// Undo all changes in the current scope and then discard it.
    /// - Returns: The initial value once all undos have been applied.
    public func undoAndPopCurrentScope() throws -> Value {
        let value = try undoCurrentScope()
        discardCurrentScope()
        return value
    }

    /// Undo all changes in the current scope and then discard it.
    /// - Parameter value: The value to apply the undos to.
    public func undoAndPopCurrentScope(_ value: inout Value) throws {
        try undoCurrentScope(&value)
        discardCurrentScope()
    }

    /// Undo all changes in the current scope and then discard it.
    /// - Parameter root: The parent object owning the value to apply the undos to.
    public func undoAndPopCurrentScope(root: inout Root) throws {
        try undoCurrentScope(root: &root)
        discardCurrentScope()
    }


    // MARK: Redo

    /// Redo the last undone change, if possible.
    /// - Returns: The value before the previous undo was applied.
    public func redo() throws -> Value {
        try currentStack.redo(&referenceValue)
        return referenceValue
    }

    /// Redo the last undone change, if possible.
    /// - Parameter value: The value to apply the redo to.
    public func redo(_ value: inout Value) throws {
        try currentStack.redo(&referenceValue)
        value = referenceValue
    }

    /// Redo the last change, if possible.
    /// - Parameter root: The parent object owning the value to apply the redo to.
    public func redo(root: inout Root) throws {
        try currentStack.redo(&referenceValue)
        root[keyPath: keyPath] = referenceValue
    }


    /// Redo all the changes in the current scope up to and including the provided tag. If the tag cannot be found, nothing happens.
    ///
    /// Tags are applied to versions, so calling this function performs all of the redo action up to and including the tagged version, so that the version provided alongside the tag is returned.
    /// - Parameter tag: The tag to revert to.
    /// - Returns: The value once reversions have been applied. If the tag is not found, the unmodified value is returned.
    public func redo(to tag: some Hashable & Sendable) throws -> Value {
        try currentStack.redo(&referenceValue, to: .init(wrapped: tag))
        return referenceValue
    }

    /// Redo all the changes in the current scope up to and including the provided tag. If the tag cannot be found, nothing happens.
    ///
    /// Tags are applied to versions, so calling this function performs all of the redo action up to and including the tagged version, so that the version provided alongside the tag is set.
    /// - Parameters:
    ///   - value: The value to apply the redos to.
    ///   - tag: The tag to revert to.
    public func redo(
        _ value: inout Value,
        to tag: some Hashable & Sendable
    ) throws {
        try currentStack.redo(&referenceValue, to: .init(wrapped: tag))
        value = referenceValue
    }

    /// Redo all the changes in the current scope up to and including the provided tag. If the tag cannot be found, nothing happens.
    ///
    /// Tags are applied to versions, so calling this function performs all of the redo action up to and including the tagged version, so that the version provided alongside the tag is set.
    /// - Parameters:
    ///   - root: The parent object owning the value to apply the redos to.
    ///   - tag: The tag to revert to.
    public func redo(
        root: inout Root,
        to tag: some Hashable & Sendable
    ) throws {
        try currentStack.redo(&referenceValue, to: .init(wrapped: tag))
        return root[keyPath: keyPath] = referenceValue
    }



    /// Redo all changes in the current scope.
    /// - Returns: The latest value once all redos have been applied.
    public func redoCurrentScope() throws -> Value {
        try currentStack.redoAll(&referenceValue)
        return referenceValue
    }

    /// Redo all changes in the current scope.
    /// - Parameter value: The value to apply the redos to.
    public func redoCurrentScope(_ value: inout Value) throws {
        try currentStack.redoAll(&referenceValue)
        value = referenceValue
    }

    /// Redo all changes in the current scope.
    /// - Parameter root: The parent object owning the value to apply the redos to.
    public func redoCurrentScope(root: inout Root) throws {
        try currentStack.redoAll(&referenceValue)
        root[keyPath: keyPath] = referenceValue
    }
}

// MARK: - Reference type reversion
extension VersioningController where Root: AnyObject {
    
    /// Undo the last change on the root object.
    public func undo() throws {
        try currentStack.undo(&referenceValue)
        updateRoot?(referenceValue)
    }

    /// Undo all the changes in the current scope up to the provided tag on the root object. If the tag cannot be found, nothing happens.
    ///
    /// Tags are applied to versions, so calling this function performs all of the undo action up to, but not including the tagged version, so that the version provided alongside the tag is set.
    /// - Parameter tag: The tag to revert to.
    public func undo(to tag: some Hashable & Sendable) throws {
        try currentStack.undo(&referenceValue, to: .init(wrapped: tag))
        updateRoot?(referenceValue)
    }

    /// Undo all changes in the current scope on the root object.
    public func undoCurrentScope() throws {
        try currentStack.undoAll(&referenceValue)
        updateRoot?(referenceValue)
    }

    /// Undo all changes in the current scope on the root object and then discard the current scope.
    public func undoAndPopCurrentScope() throws {
        try currentStack.undoAll(&referenceValue)
        discardCurrentScope()
        updateRoot?(referenceValue)
    }

    /// Redo the last undone change on the root object.
    public func redo() throws {
        try currentStack.redo(&referenceValue)
        updateRoot?(referenceValue)
    }

    /// Redo all the changes in the current scope up and including to the provided tag on the root object. If the tag cannot be found, nothing happens.
    ///
    /// Tags are applied to versions, so calling this function performs all of the redo action up to and including the tagged version, so that the version provided alongside the tag is set.
    /// - Parameter tag: The tag to revert to.
    public func redo(to tag: some Hashable & Sendable) throws {
        try currentStack.redo(&referenceValue, to: .init(wrapped: tag))
        updateRoot?(referenceValue)
    }

    /// Redo all changes in the current scope on the root object.
    public func redoCurrentScope() throws {
        try currentStack.redoAll(&referenceValue)
        updateRoot?(referenceValue)
    }

    /// Applies all of the changes made in the transaction as a single modification and stores it in the history.
    /// - Parameter closure: The closure in which to make the modifications to the value, stored as a single modification.
    public func setWithTransaction<E: Error>(_ closure: (inout Value) throws(E) -> Void) throws(E) {
        try closure(&referenceValue)
        updateRoot?(referenceValue)
        append(referenceValue)

    }

    /// Applies all of the changes made in the transaction as a single modification and stores it in the history.
    /// - Parameter closure: The closure in which to make the modifications to the value, stored as a single modification.
    public func setWithTransaction<E: Error>(_ closure: (inout Value) async throws(E) -> Void) async throws(E) {
        try await closure(&referenceValue)
        updateRoot?(referenceValue)
        append(referenceValue)
    }
}
