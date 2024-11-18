import Foundation

struct StateMachine<T: Sendable>: Sendable {

    // MARK: - Properties
    private var state: State
    private let duration: ContinuousClock.Duration

    // MARK: - Initializer
    init(duration: ContinuousClock.Duration) {
        self.state = .idle
        self.duration = duration
    }
}

// MARK: - State updates
extension StateMachine {

    mutating func newValue(_ value: T) -> (Bool, ContinuousClock.Instant) {
        let dueTime = ContinuousClock.now + duration
        switch self.state {
        case .idle:
            self.state = .debouncing(value: value, dueTime: dueTime, isValueDuringSleep: false)
            return (true, dueTime)

        case .debouncing:
            self.state = .debouncing(value: value, dueTime: dueTime, isValueDuringSleep: true)
            return (false, dueTime)
        }
    }

    mutating func sleepIsOver() -> WakeAction {
        switch self.state {
        case .idle:
            fatalError("inconsistent state, no value was being debounced.")

        case .debouncing(let value, let dueTime, true):
            state = .debouncing(value: value, dueTime: dueTime, isValueDuringSleep: false)
            return .continueDebouncing(dueTime: dueTime)

        case .debouncing(let value, _, false):
            state = .idle
            return .finishDebouncing(value: value)

        }
    }
}

// MARK: - State
extension StateMachine {
    enum State: Sendable {
        case idle
        case debouncing(value: T, dueTime: ContinuousClock.Instant, isValueDuringSleep: Bool)
   }
}

// MARK: - Wake action
extension StateMachine {
    enum WakeAction {
        case continueDebouncing(dueTime: ContinuousClock.Instant)
        case finishDebouncing(value: T)
    }
}
