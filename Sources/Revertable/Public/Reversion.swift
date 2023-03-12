
/// An object that can be applied to an instance of its `Root` type to revert it to a previous state.
///
/// The instance that the ``Reversion`` is applied to must produce the same `hashValue` as the instance that was used to create the ``Reversion`` or an error will be thrown.
///
/// A ``Reversion`` is created by calling the ``Revertable/Revertable/reversion(to:)`` function on some ``Revertable/Revertable`` instance. This can then be stored and used to revert the instance back to its initial state.
public struct Reversion<Root: Hashable> {
    
    // MARK: - Properties
    private let checkedHashValue: Int
    private let reversions: [AnyValueReversion<Root>]
    
    // MARK: - Initialiser
    init(
        root: Root,
        reverter: DefaultReverter<Root>
    ) {
        
        self.checkedHashValue = root.hashValue
        self.reversions = reverter.reversions
    }
    
    // MARK: - Functions
    
    /// Reverts the `object` to a previous state.
    /// - Parameter object: The object to be reverted to a previous state.
    /// - Throws: A ``ReversionError`` that may be caused by incorrect application of the ``Reversion``.
    public func revert(_ object: inout Root) throws {
        
        guard object.hashValue == checkedHashValue else {
            throw ReversionError.attemptingToRevertWrongVersion
        }
        
        for reversion in reversions {
            reversion.revert(&object)
        }
    }
}

// MARK: - Errors
extension Reversion {
    
    /// Errors that can be thrown by the ``Reversion/revert(_:)`` function.
    public enum ReversionError: Error {
        
        /// The ``Reversion`` was applied to the wrong instance. A ``Reversion`` can only be applied to an instance that was used to create it.
        case attemptingToRevertWrongVersion
    }
}
