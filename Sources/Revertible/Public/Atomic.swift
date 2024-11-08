import Foundation

@propertyWrapper
struct Atomic<T>: Sendable {

    // MARK: - Properties
    private let lock = NSRecursiveLock()
    private nonisolated(unsafe) var _wrappedValue: Box
    var wrappedValue: T {
        get {
            lock.withLock { _wrappedValue.value }
        }
        nonmutating set {
            lock.withLock { _wrappedValue.value = newValue }
        }
    }

    var projectedValue: Modifier {
        Modifier(lock: lock, wrappedValue: _wrappedValue)
    }

    // MARK: - Initializer
    init(wrappedValue: T) {
        self._wrappedValue = .init(value: wrappedValue)
    }

    final class Box {

        var value: T

        init(value: T) {
            self.value = value
        }
    }

    struct Modifier {
        fileprivate let lock: NSRecursiveLock
        fileprivate let wrappedValue: Box

        func callAsFunction<Return>(_ body: (inout T) throws -> Return) rethrows -> Return {
            lock.lock()
            defer { lock.unlock() }
            return try body(&wrappedValue.value)
        }
    }
}
