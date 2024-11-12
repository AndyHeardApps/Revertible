
struct VersioningStack<Value: Versionable & Sendable>: Sendable {

    // MARK: - Properties
    @Atomic private var undoStack: [ReversionAction<Value>]
    @Atomic private var redoStack: [ReversionAction<Value>]

    // MARK: - Initialiser
    init() {
        
        self.undoStack = []
        self.redoStack = []
    }
}

// MARK: - Action appending
extension VersioningStack {
    
    mutating func append(
        currentValue: Value,
        previousValue: Value
    ) {
        
        let action = ReversionAction(
            currentValue: currentValue,
            previousValue: previousValue
        )

        if let action {
            undoStack.append(action)
            redoStack.removeAll()
        }
    }
}

// MARK: - Undo / redo
extension VersioningStack {
    
    mutating func undo(_ value: inout Value) throws {

        guard let action = undoStack.popLast() else {
            return
        }
        
        try action.perform(on: &value)
        redoStack.append(action.inverted())
    }

    mutating func undoAll(_ value: inout Value) throws {

        try $undoStack {
            while !$0.isEmpty {
                try undo(&value)
            }
        }
    }

    mutating func redo(_ value: inout Value) throws {

        guard let action = redoStack.popLast() else {
            return
        }
        
        try action.perform(on: &value)
        undoStack.append(action.inverted())
    }

    mutating func redoAll(_ value: inout Value) throws {

        try $redoStack {
            while !$0.isEmpty {
                try redo(&value)
            }
        }
    }

    var hasUndo: Bool {
        !undoStack.isEmpty
    }

    var hasRedo: Bool {
        !redoStack.isEmpty
    }
}
