
struct ReversionAction<Value: Versionable> {

    // MARK: - Properties
    private let undoReversion: Reversion<Value>
    private let redoReversion: Reversion<Value>

    // MARK: - Initialisers
    private init(
        undoReversion: Reversion<Value>,
        redoReversion: Reversion<Value>
    ) {
        self.undoReversion = undoReversion
        self.redoReversion = redoReversion
    }

    init?(
        currentValue: Value,
        previousValue: Value
    ) {

        guard
            let undoReversion = currentValue.reversion(to: previousValue),
            let redoReversion = previousValue.reversion(to: currentValue)
        else {
            return nil
        }

        self.undoReversion = undoReversion
        self.redoReversion = redoReversion
    }
}

// MARK: - Undo
extension ReversionAction {

    func perform(on value: inout Value) throws {

        try undoReversion.revert(&value)
    }

    func inverted() -> Self {

        .init(
            undoReversion: redoReversion,
            redoReversion: undoReversion
        )
    }
}
