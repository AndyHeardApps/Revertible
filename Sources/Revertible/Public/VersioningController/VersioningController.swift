import Foundation

/// Provides a simplified interface for registering changes managing reversions of a variable.
///
/// - Note  This class can only be used to manage reversions for instances of value types. The value type may be contained in a reference type, to be used as the `Root`, but the value to be tracked must be a value type.
///
/// This class is used to register modifications to a single value, and perform undo and redo actions on that value. Changes are stored in a stack on a last in - first out bases, and any undo actions are automatically converted into redo actions when applied.
///
/// There a several functions that allow for pushing and popping of additional scopes, which provides a way to group together sets of changes. This can be used in cases such as when a new screen is pushed, and content is modified, but not saved. A new scope can be pushed for the new screen, and when the changes are abandonded the scope can be undone and popped. A new scope is created using the ``pushNewScope()`` function and the ``undoAndPopCurrentScope()`` function and it's variants can be used to pop the scope.
///
/// There are a couple of different ways to use this class, each having it's own initializer.
///
/// 1. In place
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
    private let updateRoot: @Sendable (Value) -> Void
    @Atomic private var debounce: Debounce<Value>?

    // MARK: - Initialisers
    
    /// Creates a controller for in place registering and application of changes.
    /// - Parameters:
    ///   - value: The initial value to be tracked.
    ///   - debounceInterval: The debounce interval, indicating how much time must elapse between changes before they are stored. If `nil` then all changes are stored.
    public init(
        _ value: Value,
        debounceInterval: ContinuousClock.Duration? = nil
    ) where Root == Value {

        if type(of: value) is AnyClass {
            assertionFailure("VersioningController can only be used on value types.")
        }

        self.stacks = [.init()]
        self.referenceValue = value
        self.keyPath = \.self
        self.updateRoot = { _ in }
        self.debounce = debounceInterval.map {
            .init(duration: $0) { [weak self] in
                self?._append($0)
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

        let referenceValue = root[keyPath: keyPath]
        if type(of: referenceValue) is AnyClass {
            assertionFailure("VersioningController can only be used on value types.")
        }

        self.stacks = [.init()]
        self.referenceValue = referenceValue
        self.keyPath = keyPath
        self.updateRoot = { _ in }
        self.debounce = debounceInterval.map {
            .init(duration: $0) { [weak self] in
                self?._append($0)
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

        let referenceValue = root[keyPath: keyPath]
        if type(of: referenceValue) is AnyClass {
            assertionFailure("VersioningController can only be used on value types.")
        }

        self.stacks = [.init()]
        self.referenceValue = referenceValue
        self.keyPath = keyPath
        self.updateRoot = { [weak root] newValue in
            root?[keyPath: keyPath] = newValue
        }
        self.debounce = debounceInterval.map {
            .init(duration: $0) { [weak self] in
                self?._append($0)
            }
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
                    let stack = VersioningStack<Value>()
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
        stacks.append(.init())
    }

    private func popCurrentScope() {
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
    /// - Parameter newValue: The updated value to register changes on.
    public func append(_ newValue: Value) {

        $debounce {
            if $0 != nil {
                $0?.emit(value: newValue)
            } else {
                _append(newValue)
            }
        }
    }

    private func _append(_ newValue: Value) {

        $referenceValue {
            currentStack.append(
                currentValue: newValue,
                previousValue: $0
            )
            $0 = newValue
        }
    }

    /// Attempts to append the changes from the provided value to the current scope. If no changes have been made then nothing is appended to the scope.
    /// - Parameter updatedRoot: The object owning the value to register changes for.
    public func append(root updatedRoot: Root) {
        append(updatedRoot[keyPath: keyPath])
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
        popCurrentScope()
        return value
    }

    /// Undo all changes in the current scope and then discard it.
    /// - Parameter value: The value to apply the undos to.
    public func undoAndPopCurrentScope(_ value: inout Value) throws {
        try undoCurrentScope(&value)
        popCurrentScope()
    }

    /// Undo all changes in the current scope and then discard it.
    /// - Parameter root: The parent object owning the value to apply the undos to.
    public func undoAndPopCurrentScope(root: inout Root) throws {
        try undoCurrentScope(root: &root)
        popCurrentScope()
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
        updateRoot(referenceValue)
    }

    /// Undo all changes in the current scope on the root object.
    public func undoCurrentScope() throws {
        try currentStack.undoAll(&referenceValue)
        updateRoot(referenceValue)
    }

    /// Undo all changes in the current scope on the root object and then discard the current scope.
    public func undoAndPopCurrentScope() throws {
        try currentStack.undoAll(&referenceValue)
        popCurrentScope()
        updateRoot(referenceValue)
    }

    /// Redo the last undone change on the root object.
    public func redo() throws {
        try currentStack.redo(&referenceValue)
        updateRoot(referenceValue)
    }

    /// Redo all changes in the current scope on the root object.
    public func redoCurrentScope() throws {
        try currentStack.redoAll(&referenceValue)
        updateRoot(referenceValue)
    }
}
