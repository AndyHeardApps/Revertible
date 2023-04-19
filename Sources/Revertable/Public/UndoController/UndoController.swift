
/// Manages stacks of undo and redo actions.
///
/// Undo actions are registered with the ``append(undo:redo:)`` and ``append(changesOn:at:previousValue:)`` functions, which are called by the ``undo()`` function in the reverse order to which they were registered (last in first out). Once an action is performed by calling ``undo()``, it is automatically converted to a redo action, which is callable with ``redo()``.
///
/// Groups of actions can be managed by pushing and popping scopes using the ``pushNewScope()`` and ``discardCurrentScope()``. Scopes are separate, and are intended to be managed on a per-screen, or per-context basis.
public final class UndoController {
    
    // MARK: - Properties
    private var stacks: [UndoStack]
    
    // MARK: - Initialiser
    
    public init() {
        
        self.stacks = [.init()]
    }
}

// MARK: - Action appending
extension UndoController {
    
    /// Appends a new undo action based on a ``Revertable`` type on a class.
    /// - Parameters:
    ///   - root: The root object that owns the ``Revertable`` value.
    ///   - keyPath: The key path pointing towards the ``Revertable`` value.
    ///   - previousValue: The previous value to be reverted to.
    public func append<Root: AnyObject, Value: Revertable>(
        changesOn root: Root,
        at keyPath: WritableKeyPath<Root, Value>,
        previousValue: Value
    ) {
        
        currentStack.append(
            changesOn: root,
            at: keyPath,
            previousValue: previousValue
        )
    }
    
    /// Appends a new undo action based on closures
    /// - Parameters:
    ///   - undo: The closure called when undoing this action.
    ///   - redo: The closure called when redoing this action.
    public func append(
        undo: @escaping () throws -> Void,
        redo: @escaping () throws -> Void
    ) {
        
        currentStack.append(
            undo: undo,
            redo: redo
        )
    }
}

// MARK: - Stack management
extension UndoController {
    
    private var currentStack: UndoStack {
        
        if let stack = stacks.last {
            return stack
        } else {
            let stack = UndoStack()
            stacks.append(stack)
            return stack
        }
    }
    
    /// Creates and pushes a new scope that all new actions are added to.
    public func pushNewScope() {
        
        stacks.append(.init())
    }
    
    /// Discards the current scope, if it is not the root scope of level `1`.
    public func discardCurrentScope() {
        
        if stacks.count > 1 {
            _ = stacks.popLast()
        }
    }
    
    /// The current scope level, with the root being `1`.
    public var scopeLevel: Int {
        
        stacks.count
    }
}

// MARK: - Undo / redo
extension UndoController {
    
    /// Perform the next undo action, if available.
    public func undo() throws {
        
        try currentStack.undo()
    }
    
    /// Perform the next redo action, if available.
    public func redo() throws {
        
        try currentStack.redo()
    }
    
    /// Whether the current stack has an undo action available to perform.
    public var hasUndo: Bool {
        
        currentStack.hasUndo
    }
    
    /// Whether the current stack has a redo action available to perform.
    public var hasRedo: Bool {
        
        currentStack.hasRedo
    }
}
