import Foundation

public final class VersioningController<Root: Sendable, Value: Versionable & Sendable>: @unchecked Sendable {

    // MARK: - Properties
    @Atomic private var stacks: [VersioningStack<Value>]
    @Atomic private var referenceValue: Value
    private let keyPath: WritableKeyPath<Root, Value> & Sendable
    private let updateRoot: @Sendable (Value) -> Void
    @Atomic private var debounce: Debounce<Value>?

    // MARK: - Initialisers

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

    /// Discards the current scope, if it is not the root scope of level `1`.
    public func discardCurrentScope() {
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

    /// Whether the current stack has an undo action available to perform.
    public var hasUndo: Bool {
        currentStack.hasUndo
    }

    /// Whether the current stack has a redo action available to perform.
    public var hasRedo: Bool {
        currentStack.hasRedo
    }
}

// MARK: - Value type reversion
extension VersioningController {

    // MARK: Append
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

    public func append(root updatedRoot: Root) {
        append(updatedRoot[keyPath: keyPath])
    }


    // MARK: Undo
    public func undo() throws -> Value {
        try currentStack.undo(&referenceValue)
        return referenceValue
    }

    public func undo(_ value: inout Value) throws {
        try currentStack.undo(&referenceValue)
        value = referenceValue
    }

    public func undo(root: inout Root) throws {
        try currentStack.undo(&referenceValue)
        root[keyPath: keyPath] = referenceValue
    }


    public func undoCurrentScope() throws -> Value {
        try currentStack.undoAll(&referenceValue)
        return referenceValue
    }

    public func undoCurrentScope(_ value: inout Value) throws {
        try currentStack.undoAll(&referenceValue)
        value = referenceValue
    }

    public func undoCurrentScope(_ root: inout Root) throws {
        try currentStack.undoAll(&referenceValue)
        root[keyPath: keyPath] = referenceValue
    }


    public func undoAndDiscardCurrentScope() throws -> Value {
        let value = try undoCurrentScope()
        discardCurrentScope()
        return value
    }

    public func undoAndDiscardCurrentScope(_ value: inout Value) throws {
        try undoCurrentScope(&value)
        discardCurrentScope()
    }

    public func undoAndDiscardCurrentScope(_ root: inout Root) throws {
        try undoCurrentScope(&root)
        discardCurrentScope()
    }


    // MARK: Redo

    public func redo() throws -> Value {
        try currentStack.redo(&referenceValue)
        return referenceValue
    }

    public func redo(_ value: inout Value) throws {
        try currentStack.redo(&referenceValue)
        value = referenceValue
    }

    public func redo(root: inout Root) throws {
        try currentStack.redo(&referenceValue)
        root[keyPath: keyPath] = referenceValue
    }


    public func redoCurrentScope() throws -> Value {
        try currentStack.redoAll(&referenceValue)
        return referenceValue
    }

    public func redoCurrentScope(_ value: inout Value) throws {
        try currentStack.redoAll(&referenceValue)
        value = referenceValue
    }

    public func redoCurrentScope(root: inout Root) throws {
        try currentStack.redoAll(&referenceValue)
        root[keyPath: keyPath] = referenceValue
    }
}

// MARK: - Reference type reversion
extension VersioningController where Root: AnyObject {

    public func undo() throws {
        try currentStack.undo(&referenceValue)
        updateRoot(referenceValue)
    }

    public func redo() throws {
        try currentStack.redo(&referenceValue)
        updateRoot(referenceValue)
    }
}
