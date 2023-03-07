import Revertable

struct MockStruct {
    
    // MARK: - Properties
    var int = 0
    
    // MARK: - Initialiser
    init(int: Int = 0) {
        
        self.int = int
    }
}

// MARK: - Revertable
extension MockStruct: Revertable {
    
    func addReversions(into reverter: inout some Reverter<MockStruct>) {
        
        reverter.appendReversion(at: \.int)
    }
    
    static func == (lhs: MockStruct, rhs: MockStruct) -> Bool {
        
        lhs.int == rhs.int
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(int)
    }
}
