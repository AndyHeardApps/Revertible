
public struct TopLevelRevertable<Root: Hashable> {
    
    // MARK: - Properties
    private let checkedHashValue: Int
    
    // MARK: - Initialiser
    init(_ root: Root) {
        
        self.checkedHashValue = root.hashValue
    }
    
    // MARK: - Functions
    func revert(_ object: inout Root) throws {
        
        guard object.hashValue == checkedHashValue else {
            throw ReversionError.attemptingToRevertWrongVersion
        }
    }
}

// MARK: - Errors
extension TopLevelRevertable {
    public enum ReversionError: Error {
        
        case attemptingToRevertWrongVersion
    }
}
