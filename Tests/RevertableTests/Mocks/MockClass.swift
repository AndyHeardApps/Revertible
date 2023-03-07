import Revertable

final class MockClass {
    
    // MARK: - Properties
    var int = 0
    
    // MARK: - Initialiser
    init(int: Int = 0) {
        
        self.int = int
    }
}

// MARK: - Revertable
extension MockClass: Revertable {
    
    func addReversions(into reverter: inout some Reverter<MockClass>) {
        
        reverter.appendReversion(at: \.int)
    }
    
    static func == (lhs: MockClass, rhs: MockClass) -> Bool {
        
        lhs.int == rhs.int
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(int)
    }
}
