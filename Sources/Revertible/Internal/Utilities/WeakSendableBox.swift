import Foundation

@dynamicMemberLookup
final class WeakSendableBox<Wrapped: AnyObject>: @unchecked Sendable {

    // MARK: - Properties
    private let lock = NSRecursiveLock()
    private weak var _wrapped: Wrapped?
    var wrapped: Wrapped? {
        get { lock.withLock { _wrapped } }
        set { lock.withLock { _wrapped = newValue} }
    }

    // MARK: - Initializer
    init(_ wrapped: Wrapped) {
        self._wrapped = wrapped
    }

    // MARK: - Dynamic members
    subscript<Value>(dynamicMember keyPath: KeyPath<Wrapped, Value>) -> Value? {
        wrapped?[keyPath: keyPath]
    }

    subscript<Value>(dynamicMember keyPath: WritableKeyPath<Wrapped, Value>) -> Value? {
        get {
            wrapped?[keyPath: keyPath]
        }
        set {
            if let newValue {
                wrapped?[keyPath: keyPath] = newValue
            }
        }
    }
}
