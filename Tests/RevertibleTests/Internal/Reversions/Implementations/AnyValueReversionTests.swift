import XCTest
@testable import Revertible

final class AnyValueReversionTests: XCTestCase {}

// MARK: - Tests
extension AnyValueReversionTests {
    
    func testRevert_willInvokeRevertOnWrappedReversion() {
        
        let reversion = MockValueReversion<Int>()
        let anyReversion = reversion.erasedToAnyValueReversion()
        
        var value = 1
        
        XCTAssertNil(reversion.revertedObject)
        anyReversion.revert(&value)
        XCTAssertEqual(reversion.revertedObject, 1)
    }
    
    func testMapped_willInvokeMappedOnWrappedReversion() {
        
        let reversion = MockValueReversion<Int>()
        let anyReversion = reversion.erasedToAnyValueReversion()
                
        XCTAssertFalse(reversion.mappedCalled)
        let _ = anyReversion.mapped(to: \Int.self)
        XCTAssertTrue(reversion.mappedCalled)
    }
}
