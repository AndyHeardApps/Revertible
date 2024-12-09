
final class Debounce<T, C>: @unchecked Sendable
where T: Sendable,
      C: Clock,
      C.Duration == Duration,
      C.Instant.Duration == Duration
{

    // MARK: - Properties
    @Atomic private var stateMachine: StateMachine<T, C>
    @Atomic private var task: Task<Void, Never>?
    private let clock: C
    private let output: @Sendable (T) async -> Void

    // MARK: - Initializer
    init(
        clock: C,
        duration: ContinuousClock.Duration,
        output: @Sendable @escaping (T) async -> Void
    ) {
        self.stateMachine = StateMachine(
            clock: clock,
            duration: duration
        )
        self.task = nil
        self.clock = clock
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
            loop: while !Task.isCancelled {
                try? await self?.clock.sleep(until: localDueTime, tolerance: nil)

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
