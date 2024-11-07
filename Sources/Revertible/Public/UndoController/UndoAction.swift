
struct UndoAction {
    
    // MARK: - Properties
    private let undoClosure: () throws -> Void
    private let redoClosure: () throws -> Void
    
    // MARK: - Initialisers
    init(
        undo: @escaping () throws -> Void,
        redo: @escaping () throws -> Void
    ) {
        self.undoClosure = undo
        self.redoClosure = redo
    }
    
    init?<Root: AnyObject, Value: Versionable>(
        root: Root,
        keyPath: WritableKeyPath<Root, Value>,
        currentValue: Value,
        previousValue: Value
    ) {
        
        guard
            let undoReversion = currentValue.reversion(to: previousValue),
            let redoReversion = previousValue.reversion(to: currentValue)
        else {
            return nil
        }
        
        self.undoClosure = { [weak root] in
            
            guard var root else {
                return
            }
            
            try undoReversion.revert(&root[keyPath: keyPath])
        }
        
        self.redoClosure = { [weak root] in
            
            guard var root else {
                return
            }
            
            try redoReversion.revert(&root[keyPath: keyPath])
        }
    }
}

// MARK: - Undo
extension UndoAction {

    func undo() throws {
        
        try undoClosure()
    }
    
    mutating func invert() {
        
        self = .init(
            undo: redoClosure,
            redo: undoClosure
        )
    }
}
