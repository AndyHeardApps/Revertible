
struct VersioningStack<Value: Versionable & Sendable>: Sendable {

    // MARK: - Properties
    @Atomic private(set) var undoStack: [ReversionAction<Value>]
    @Atomic private(set) var redoStack: [ReversionAction<Value>]
    @Atomic private(set) var tag: AnyHashableSendable?

    // MARK: - Initialiser
    init(tag: AnyHashableSendable?) {

        self.undoStack = []
        self.redoStack = []
        self.tag = tag
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
        if undoStack.isEmpty {
            self.tag = tag
        } else {
            $undoStack {
                guard let lastUndoAction = $0.popLast() else { return }
                let taggedAction = lastUndoAction.tagged(tag)
                $0.append(taggedAction)
            }
        }
    }

    mutating func clear(tag: AnyHashableSendable) {
        if self.tag == tag {
            self.tag = nil
        }
        $undoStack {
            for index in $0.indices where $0[index].tag == tag {
                $0[index] = $0[index].tagged(nil)
            }
        }
        $redoStack {
            for index in $0.indices where $0[index].tag == tag {
                $0[index] = $0[index].tagged(nil)
            }
        }
    }
}

// MARK: - Undo / redo
extension VersioningStack {
    
    mutating func undo(_ value: inout Value) throws(ReversionError) {

        guard let action = undoStack.popLast() else {
            return
        }
        
        try action.perform(on: &value)
        redoStack.append(action.inverted())
    }

    mutating func undo(
        _ value: inout Value,
        to tag: AnyHashableSendable
    ) throws(ReversionError) {

        guard undoStack.compactMap(\.tag).contains(tag) || self.tag == tag else {
            return
        }

        while undoStack.last?.tag != tag && !undoStack.isEmpty {
            try undo(&value)
        }
    }

    mutating func undoAll(_ value: inout Value) throws(ReversionError) {

        while !undoStack.isEmpty {
            try undo(&value)
        }
    }

    mutating func redo(_ value: inout Value) throws(ReversionError) {

        guard let action = redoStack.popLast() else {
            return
        }
        
        try action.perform(on: &value)
        undoStack.append(action.inverted())
    }

    mutating func redoAll(_ value: inout Value) throws(ReversionError) {

        while !redoStack.isEmpty {
            try redo(&value)
        }
    }

    mutating func redo(
        _ value: inout Value,
        to tag: AnyHashableSendable
    ) throws(ReversionError) {

        guard redoStack.compactMap(\.tag).contains(tag) || self.tag == tag else {
            return
        }

        var lastTag: AnyHashableSendable?
        repeat {
            lastTag = redoStack.last?.tag
            try redo(&value)
        } while lastTag != tag && !redoStack.isEmpty
    }

    var hasUndo: Bool {
        !undoStack.isEmpty
    }

    var hasRedo: Bool {
        !redoStack.isEmpty
    }
}
