import XCTest
@testable import Revertable

final class SingleValueReversionTests: XCTestCase {
    
    
}

// MARK: - Tests
extension SingleValueReversionTests {
    
    func testRevert_onUnmappedKeypath_willRevertValue() {
        
        var value = 0
        let reversion = SingleValueReversion(value: value)
        
        value = 1
        
        XCTAssertEqual(value, 1)
        reversion.revert(&value)
        XCTAssertEqual(value, 0)
    }
    
    func testRevert_onMappedValueKeypath_willRevertValue() {
        
        var value = MockStruct(int: 0)
        let reversion = SingleValueReversion(value: value.int)
            .mapped(to: \MockStruct.int)
        
        value.int = 1
        
        XCTAssertEqual(value.int, 1)
        reversion.revert(&value)
        XCTAssertEqual(value.int, 0)
    }
    
    func testRevert_onMappedReferenceKeypath_willRevertValue() {
        
        var value = MockClass(int: 0)
        let reversion = SingleValueReversion(value: value.int)
            .mapped(to: \MockClass.int)
        
        value.int = 1
        
        XCTAssertEqual(value.int, 1)
        reversion.revert(&value)
        XCTAssertEqual(value.int, 0)
    }
}
