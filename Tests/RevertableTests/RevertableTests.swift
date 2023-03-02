import XCTest
import Revertable

final class RevertableTests: XCTestCase {
    
    func testExample() throws {

//        var test = Test()
//        let original = test
//        
//        test.int = 99
    }
}

struct Test: Revertable {
    
    var int: Int = 3
    
    func addReversions(to previous: Test, into reverter: inout some Reverter<Self>) {
        
//        reverter.appendReversion(at: \.int)
    }
}
