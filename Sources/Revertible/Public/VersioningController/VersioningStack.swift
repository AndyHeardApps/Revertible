
struct VersioningStack<Value: Versionable & Sendable>: Sendable {

    // MARK: - Properties
    @Atomic private(set) var undoStack: [ReversionAction<Value>]
    @Atomic private(set) var redoStack: [ReversionAction<Value>]

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
        previousValue: Value,
        tag: AnyHashableSendable?
    ) {
        
        let action = ReversionAction(
            currentValue: currentValue,
            previousValue: previousValue,
            tag: tag
        )

        if let action {
            undoStack.append(action)
            redoStack.removeAll()
        }
    }

    mutating func tagCurrentVersion(_ tag: AnyHashableSendable?) {
        $undoStack {
            guard let lastUndoAction = $0.popLast() else { return }
            let taggedAction = lastUndoAction.tagged(tag)
            $0.append(taggedAction)
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

    mutating func undo(
        _ value: inout Value,
        to tag: AnyHashableSendable
    ) throws {

        guard undoStack.compactMap(\.tag).contains(tag) else {
            return
        }

        while undoStack.last?.tag != tag {
            try undo(&value)
        }
    }

    mutating func undoAll(_ value: inout Value) throws {

        while !undoStack.isEmpty {
            try undo(&value)
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

        while !redoStack.isEmpty {
            try redo(&value)
        }
    }

    mutating func redo(
        _ value: inout Value,
        to tag: AnyHashableSendable
    ) throws {

        guard redoStack.compactMap(\.tag).contains(tag) else {
            return
        }

        repeat {
            try redo(&value)
        } while undoStack.last?.tag != tag
    }

    var hasUndo: Bool {
        !undoStack.isEmpty
    }

    var hasRedo: Bool {
        !redoStack.isEmpty
    }
}
