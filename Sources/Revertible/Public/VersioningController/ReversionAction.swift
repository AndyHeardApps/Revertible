
struct ReversionAction<Value: Versionable> {

    // MARK: - Properties
    private let undoReversion: Reversion<Value>
    private let redoReversion: Reversion<Value>
    let tag: AnyHashableSendable?

    // MARK: - Initialisers
    private init(
        undoReversion: Reversion<Value>,
        redoReversion: Reversion<Value>,
        tag: AnyHashableSendable?
    ) {
        self.undoReversion = undoReversion
        self.redoReversion = redoReversion
        self.tag = tag
    }

    init?(
        currentValue: Value,
        previousValue: Value,
        tag: AnyHashableSendable?
    ) {

        guard
            let undoReversion = currentValue.reversion(to: previousValue),
            let redoReversion = previousValue.reversion(to: currentValue)
        else {
            return nil
        }

        self.undoReversion = undoReversion
        self.redoReversion = redoReversion
        self.tag = tag
    }
}

// MARK: - Undo
extension ReversionAction {

    func perform(on value: inout Value) throws(ReversionError) {
        try undoReversion.revert(&value)
    }

    func inverted() -> Self {
        .init(
            undoReversion: redoReversion,
            redoReversion: undoReversion,
            tag: tag
        )
    }

    func tagged(_ tag: AnyHashableSendable?) -> Self {
        .init(
            undoReversion: undoReversion,
            redoReversion: redoReversion,
            tag: tag
        )
    }
}
