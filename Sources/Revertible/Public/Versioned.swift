
@propertyWrapper
public struct Versioned<Value: Versionable & Sendable>: Sendable {

    // MARK: - Properties
    public var wrappedValue: Value {
        get {
            storage
        }
        nonmutating set {
            storage = newValue
            controller.append(newValue)
        }
    }

    public var projectedValue: Self {
        self
    }

    private let controller: VersioningController<Value, Value>
    @Atomic private var storage: Value

    // MARK: - Initializer
    public init(
        wrappedValue: Value,
        debounceInterval: ContinuousClock.Duration? = nil
    ) {
        self.controller = .init(wrappedValue, debounceInterval: debounceInterval)
        self.storage = wrappedValue
    }
}

// MARK: - Functions
extension Versioned {

    public func pushNewScope() {
        controller.pushNewScope()
    }

    public func discardCurrentScope() {
        controller.discardCurrentScope()
    }

    public var scopeLevel: Int {
        controller.scopeLevel
    }

    public var hasUndo: Bool {
        controller.hasUndo
    }

    public var hasRedo: Bool {
        controller.hasRedo
    }

    public func undo() throws {
        storage = try controller.undo()
    }

    public func undoCurrentScope() throws {
        storage = try controller.undoCurrentScope()
    }

    public func undoAndDiscardCurrentScope() throws {
        storage = try controller.undoAndDiscardCurrentScope()
    }

    public func redo() throws {
        storage = try controller.redo()
    }

    public func redoCurrentScope() throws {
        storage = try controller.redoCurrentScope()
    }
}
