
final class UndoStack {
    
    // MARK: - Properties
    private var undoStack: [UndoAction]
    private var redoStack: [UndoAction]
    
    // MARK: - Initialiser
    init() {
        
        self.undoStack = []
        self.redoStack = []
    }
}

// MARK: - Action appending
extension UndoStack {
    
    func append<Root: AnyObject, Value: Versionable>(
        changesOn root: Root,
        at keyPath: WritableKeyPath<Root, Value>,
        previousValue: Value
    ) {
        
        let currentValue = root[keyPath: keyPath]
        let action = UndoAction(
            root: root,
            keyPath: keyPath,
            currentValue: currentValue,
            previousValue: previousValue
        )
        
        if let action {
            undoStack.append(action)
            redoStack.removeAll()
        }
    }
    
    func append(
        undo: @escaping () throws -> Void,
        redo: @escaping () throws -> Void
    ) {
        
        let action = UndoAction(
            undo: undo,
            redo: redo
        )
        
        undoStack.append(action)
        redoStack.removeAll()
    }
}

// MARK: - Undo / redo
extension UndoStack {
    
    func undo() throws {
        
        guard var action = undoStack.popLast() else {
            return
        }
        
        try action.undo()
        action.invert()
        redoStack.append(action)
    }
    
    func redo() throws {
     
        guard var action = redoStack.popLast() else {
            return
        }
        
        try action.undo()
        action.invert()
        undoStack.append(action)
    }
    
    var hasUndo: Bool {
        
        !undoStack.isEmpty
    }
    
    var hasRedo: Bool {
        
        !redoStack.isEmpty
    }
}
