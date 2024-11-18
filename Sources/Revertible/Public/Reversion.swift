
/// An object that can be applied to an instance of its `Root` type to revert it to a previous state.
///
/// The instance that the ``Reversion`` is applied to must produce the same `hashValue` as the instance that was used to create the ``Reversion`` or an error will be thrown.
///
/// A ``Reversion`` is created by calling the ``Revertible/Revertible/reversion(to:)`` function on some ``Revertible/Revertible`` instance. This can then be stored and used to revert the instance back to its initial state.
///
/// Conforming a type to ``Versionable`` provides a simple interface allowing the automatic synthesis of the ``Revertible/Revertible/reversion(to:)`` function by simply implementing the ``Versionable/addReversions(into:)`` function.
public struct Reversion<Root: Hashable> {
    
    // MARK: - Properties
    private let checkedHashValue: Int
    private let reversion: AnyValueReversion<Root>
    
    // MARK: - Initialiser
    init(
        root: Root,
        reversion: AnyValueReversion<Root>
    ) {
        
        self.checkedHashValue = root.hashValue
        self.reversion = reversion
    }
    
    // MARK: - Functions
    
    /// Reverts the `object` to a previous state.
    /// - Parameter object: The object to be reverted to a previous state.
    /// - Throws: A ``ReversionError`` that may be caused by incorrect application of the ``Reversion``.
    public func revert(_ object: inout Root) throws {
        
        guard object.hashValue == checkedHashValue else {
            throw ReversionError.attemptingToRevertWrongVersion
        }
        
        reversion.revert(&object)
    }
}

// MARK: - Errors
/// Errors that can be thrown by the ``Reversion/revert(_:)`` function.
public enum ReversionError: Error {

    /// The ``Reversion`` was applied to the wrong instance. A ``Reversion`` can only be applied to an instance that was used to create it.
    case attemptingToRevertWrongVersion
}
