
/// A property wrapper that tracks changes over time, allowing it to be reverted to a previous state with the ``Controller/undo()`` function or have changes restored using the ``Controller/redo()`` function. These are accessed through the projected value using dollar syntax (`try $value.undo()`). Changes are automatically registered whenever the wrapped value is set, but may be debounced using the parameter on the initializer.
///
/// This type only supports value types, as reference semantics makes it difficult to track separate instances of a value.
///
/// This type is driven by the ``VersioningController``, so for further information refer to it's documentation.
///
/// ```
/// @Versioned var value = myStruct()   // id = 0
/// value.id = 5                        // id = 5
/// try $value.undo()                   // id = 0
/// try $value.redo()                   // id = 5
/// ```
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

    private let controller: VersioningController<Value, Value, ReversionError>
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

        private let controller: VersioningController<Value, Value, ReversionError>
        @Atomic private var storage: Value

        fileprivate init(_ Versioned: Versioned) {
            self.controller = Versioned.controller
            self._storage = Versioned._storage
        }

        /// Creates and pushes a new scope that all new actions are added to.
        public func pushNewScope() {
            controller.pushNewScope()
        }

        /// The current scope level, with the root being `0`.
        public var scopeLevel: Int {
            controller.scopeLevel
        }

        /// Updates the tag of the current version.
        /// - Parameter tag: Some tag to reference this version. This can be used later to apply reversions up to this tag.
        public func tag(_ tag: some Hashable & Sendable) {
            controller.tagCurrentVersion(tag)
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

        /// Undo all the changes in the current scope up to the provided tag. If the tag cannot be found, nothing happens.
        /// - Parameter tag: The tag to revert to.
        public func undo(to tag: some Hashable & Sendable) throws {
            storage = try controller.undo(to: tag)
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
        
        /// Redo all the changes in the current scope up to and including the provided tag. If the tag cannot be found, nothing happens.
        /// - Parameter tag: The tag to revert to.
        public func redo(to tag: some Hashable & Sendable) throws {
            storage = try controller.redo(to: tag)
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
        
        /// Applies all of the changes made in the transaction as a single modification and stores it in the history.
        /// - Parameter closure: The closure in which to make the modifications to the value, stored as a single modification.
        public func setWithTransaction<E: Error>(_ closure: (inout Value) throws(E) -> Void) throws(E) {
            try closure(&storage)
            controller.append(storage)
        }

        /// Applies all of the changes made in the transaction as a single modification and stores it in the history.
        /// - Parameter closure: The closure in which to make the modifications to the value, stored as a single modification.
        public func setWithTransaction<E: Error>(_ closure: (inout Value) async throws(E) -> Void) async throws(E) {
            try await closure(&storage)
            controller.append(storage)
        }

        /// Clears all stored undo and redo actions. This may be needed when using ``setWithoutTracking(_:)``.
        public func reset() {
            controller.reset()
        }
    }
}
