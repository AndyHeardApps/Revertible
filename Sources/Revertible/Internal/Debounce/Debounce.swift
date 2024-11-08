
final class Debounce<T: Sendable>: @unchecked Sendable {

    // MARK: - Properties
    @Atomic private var stateMachine: StateMachine<T>
    @Atomic private var task: Task<Void, Never>?
    private let output: @Sendable (T) async -> Void

    // MARK: - Initializer
    init(
        duration: ContinuousClock.Duration,
        output: @Sendable @escaping (T) async -> Void
    ) {
        self.stateMachine = StateMachine(duration: duration)
        self.task = nil
        self.output = output
    }

    deinit {
        task?.cancel()
    }
}

// MARK: - Emit
extension Debounce {

    func emit(value: T) {
        let (shouldStartTask, dueTime) = stateMachine.newValue(value)


        guard shouldStartTask else {
            return
        }

        task = Task { [output, weak self] in
            var localDueTime = dueTime
            loop: while true {
                try? await Task.sleep(until: localDueTime, clock: .continuous)

                guard let action = self?.stateMachine.sleepIsOver() else {
                    continue
                }

                switch action {
                case let .finishDebouncing(value):
                    await output(value)
                    break loop
                case let .continueDebouncing(newDueTime):
                    localDueTime = newDueTime
                    continue loop
                }
            }
        }
    }
}
