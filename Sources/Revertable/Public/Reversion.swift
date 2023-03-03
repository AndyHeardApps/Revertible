
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
    public enum ReversionError: Error {
        
        case attemptingToRevertWrongVersion
    }
}
