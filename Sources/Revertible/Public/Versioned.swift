
/// A property wrapper that tracks changes over time, allowing it to be reverted to a previous state with the ``Controller/undo()`` function or have changes restored using the ``Controller/redo()`` function. These are accessed through the projected value using dollar syntax (`try $value.undo()`). Changes are automatically registered whenever the wrapped value is set, but may be debounced using the parameter on the initializer.
///
/// This type only supports value types, as reference semantics makes it difficult to track separate instances of a value.
///
/// This type is driven by the ``VersioningController``, so for further information refer to it's documentation.
@propertyWrapper
public struct Versioned<Value: Versionable & Sendable>: Sendable {

    // MARK: - Properties

    /// The value to track changes on. Setting this property will automatically try and track any changes made.
    public var wrappedValue: Value {
        get {
            storage
        }
        nonmutating set {
            storage = newValue
            controller.append(newValue)
        }
    }

    /// The controller for this value, providing undo and redo functionality.
    public var projectedValue: Controller {
        Controller(self)
    }

    private let controller: VersioningController<Value, Value>
    @Atomic private var storage: Value

    // MARK: - Initializer

    /// Creates a new ``Versioned`` property wrapper.
    /// - Parameters:
    ///   - wrappedValue: The initial tracked value.
    ///   - debounceInterval: The debounce interval, indicating how much time must elapse between changes before they are stored. If `nil` then all changes are stored.
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
    
    /// Provides access to undo and redo functionality for the wrapped type.
    public struct Controller: Sendable {

        private let controller: VersioningController<Value, Value>
        @Atomic private var storage: Value

        fileprivate init(_ versioned: Versioned) {
            self.controller = versioned.controller
            self._storage = versioned._storage
        }

        /// Creates and pushes a new scope that all new actions are added to.
        public func pushNewScope() {
            controller.pushNewScope()
        }

        /// The current scope level, with the root being `0`.
        public var scopeLevel: Int {
            controller.scopeLevel
        }

        /// Whether the current scope has an undo action available to perform.
        public var hasUndo: Bool {
            controller.hasUndo
        }

        /// Whether the current scope has a redo action available to perform.
        public var hasRedo: Bool {
            controller.hasRedo
        }

        /// Undo the last change, if possible.
        public func undo() throws {
            storage = try controller.undo()
        }

        /// Undo all changes in the current scope.
        public func undoCurrentScope() throws {
            storage = try controller.undoCurrentScope()
        }

        /// Undo all changes in the current scope and then discard it.
        public func undoAndPopCurrentScope() throws {
            storage = try controller.undoAndPopCurrentScope()
        }

        /// Redo the last undone change, if possible.
        public func redo() throws {
            storage = try controller.redo()
        }

        /// Redo all changes in the current scope.
        public func redoCurrentScope() throws {
            storage = try controller.redoCurrentScope()
        }
        
        /// Set the underlying wrapped value without triggering any change tracking. This may cause the currently stored undo and redo changes to break, meaning they are no longer usable and causing inconsistent state. You may need to call ``reset()`` to clear any invalidated stored undo and redo actions.
        /// - Parameter newValue: The new wrapped value.
        public func setWithoutTracking(_ newValue: Value) {
            storage = newValue
        }
        
        /// Clears all stored undo and redo actions. This may be needed when using ``setWithoutTracking(_:)``.
        public func reset() {
            controller.reset()
        }
    }
}
