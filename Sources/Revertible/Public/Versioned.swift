
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
public struct _Versioned<Value: Versionable & Sendable, Failure: Error>: Sendable {

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
    private let handleError: @Sendable (ReversionError) throws(Failure) -> Void
    @Atomic private var storage: Value
    @Atomic private var _error: ReversionError?

    // MARK: - Initializer

    /// Creates a new ``Versioned`` property wrapper that exposes errors through throwing functions.
    /// - Parameters:
    ///   - wrappedValue: The initial tracked value.
    ///   - debounceInterval: The debounce interval, indicating how much time must elapse between changes before they are stored. If `nil` then all changes are stored.
    public init(
        wrappedValue: Value,
        debounceInterval: ContinuousClock.Duration? = nil
    ) where Failure == ReversionError {
        self.controller = .init(
            wrappedValue,
            debounceInterval: debounceInterval
        )
        self.handleError = { error throws(ReversionError) in throw error }
        self.storage = wrappedValue
    }

    /// Creates a new ``Versioned`` property wrapper that exposes errors through the `projectedValue.error` property.
    /// - Parameters:
    ///   - wrappedValue: The initial tracked value.
    ///   - debounceInterval: The debounce interval, indicating how much time must elapse between changes before they are stored. If `nil` then all changes are stored.
    public init(
        wrappedValue: Value,
        debounceInterval: ContinuousClock.Duration? = nil
    ) where Failure == Never {
        self.controller = .init(
            wrappedValue,
            debounceInterval: debounceInterval
        )
        self.handleError = { [__error] error in
            __error.wrappedValue = error
        }
        self.storage = wrappedValue
    }
}

// MARK: - Functions
extension Versioned {
    
    /// Provides access to undo and redo functionality for the wrapped type.
    public struct Controller: Sendable {

        private let controller: VersioningController<Value, Value, ReversionError>
        private let handleError: @Sendable (ReversionError) throws(Failure) -> Void
        @Atomic private var storage: Value
        @Atomic private var _error: ReversionError?

        fileprivate init(_ versioned: _Versioned) {
            self.controller = versioned.controller
            self.handleError = versioned.handleError
            self._storage = versioned._storage
            self._error = versioned._error
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
        public func undo() throws(Failure) {
            do {
                storage = try controller.undo()
            } catch {
                try handleError(error)
            }
        }

        /// Undo all the changes in the current scope up to the provided tag. If the tag cannot be found, nothing happens.
        /// - Parameter tag: The tag to revert to.
        public func undo(to tag: some Hashable & Sendable) throws(Failure) {
            do {
                storage = try controller.undo(to: tag)
            } catch {
                try handleError(error)
            }
        }

        /// Undo all changes in the current scope.
        public func undoCurrentScope() throws(Failure) {
            do {
                storage = try controller.undoCurrentScope()
            } catch {
                try handleError(error)
            }
        }

        /// Undo all changes in the current scope and then discard it.
        public func undoAndPopCurrentScope() throws(Failure) {
            do {
                storage = try controller.undoAndPopCurrentScope()
            } catch {
                try handleError(error)
            }
        }

        /// Redo the last undone change, if possible.
        public func redo() throws(Failure) {
            do {
                storage = try controller.redo()
            } catch {
                try handleError(error)
            }
        }
        
        /// Redo all the changes in the current scope up to and including the provided tag. If the tag cannot be found, nothing happens.
        /// - Parameter tag: The tag to revert to.
        public func redo(to tag: some Hashable & Sendable) throws(Failure) {
            do {
                storage = try controller.redo(to: tag)
            } catch {
                try handleError(error)
            }
        }

        /// Redo all changes in the current scope.
        public func redoCurrentScope() throws(Failure) {
            do {
                storage = try controller.redoCurrentScope()
            } catch {
                try handleError(error)
            }
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

extension _Versioned.Controller where Failure == Never {

    var error: ReversionError? {
        get {
            _error
        }
        nonmutating set {
            _error = newValue
        }
    }
}

/// A property wrapper that tracks changes over time, allowing it to be reverted to a previous state with the ``Controller/undo()`` function or have changes restored using the ``Controller/redo()`` function. These are accessed through the projected value using dollar syntax (`$value.undo()`). Changes are automatically registered whenever the wrapped value is set, but may be debounced using the parameter on the initializer.
///
/// This type only supports value types, as reference semantics makes it difficult to track separate instances of a value.
///
/// Any errors that occur during version control are assigned to the `$value.error` property, leaving all functions free to be used without explicit error handling.
///
/// This type is driven by the ``VersioningController``, so for further information refer to it's documentation.
///
/// ```
/// @Versioned var value = myStruct()   // id = 0
/// value.id = 5                        // id = 5
/// try $value.undo()                   // id = 0
/// try $value.redo()                   // id = 5
/// ```
public typealias Versioned<Value: Versionable & Sendable> = _Versioned<Value, Never>

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
public typealias ThrowingVersioned<Value: Versionable & Sendable> = _Versioned<Value, ReversionError>
