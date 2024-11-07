import XCTest
@testable import Revertible

final class MultipleValueReversionTests: XCTestCase {}

// MARK: - Tests
extension MultipleValueReversionTests {
    
    func testRevert_willInvokeRevertOnChildReversion() {
        
        let reversion1 = MockValueReversion<Int>()
        let reversion2 = MockValueReversion<Int>()
        let multipleReversion = MultipleValueReversion([
            reversion1.erasedToAnyValueReversion(),
            reversion2.erasedToAnyValueReversion()
        ])
        
        var value = 1
        
        XCTAssertNil(reversion1.revertedObject)
        XCTAssertNil(reversion2.revertedObject)
        multipleReversion.revert(&value)
        XCTAssertEqual(reversion1.revertedObject, 1)
        XCTAssertEqual(reversion2.revertedObject, 1)
    }
    
    func testMapped_willInvokeMappedOnChildReversion() {
        
        let reversion1 = MockValueReversion<Int>()
        let reversion2 = MockValueReversion<Int>()
        let multipleReversion = MultipleValueReversion([
            reversion1.erasedToAnyValueReversion(),
            reversion2.erasedToAnyValueReversion()
        ])

        XCTAssertFalse(reversion1.mappedCalled)
        XCTAssertFalse(reversion2.mappedCalled)
        let _ = multipleReversion.mapped(to: \Int.self)
        XCTAssertTrue(reversion1.mappedCalled)
        XCTAssertTrue(reversion2.mappedCalled)
    }
}
