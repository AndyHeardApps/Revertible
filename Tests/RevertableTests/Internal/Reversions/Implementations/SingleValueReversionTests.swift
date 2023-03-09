import XCTest
@testable import Revertable

final class SingleValueReversionTests: XCTestCase {}

// MARK: - Tests
extension SingleValueReversionTests {
    
    func testRevert_onSelfKeypath_willRevertValue() {
        
        var value = 0
        let reversion = SingleValueReversion(
            value: value,
            at: \.self
        )
        
        value = 1
        
        XCTAssertEqual(value, 1)
        reversion.revert(&value)
        XCTAssertEqual(value, 0)
    }
    
    func testRevert_onValueChildKeypath_willRevertValue() {
        
        var value = MockStruct()
        let reversion = SingleValueReversion(
            value: value.int,
            at: \MockStruct.int
        )
        
        value.int = 1
        
        XCTAssertEqual(value.int, 1)
        reversion.revert(&value)
        XCTAssertEqual(value.int, 0)
    }
    
    func testRevert_onReferenceChildKeypath_willRevertValue() {
        
        var value = MockClass()
        let reversion = SingleValueReversion(
            value: value.int,
            at: \MockClass.int
        )
        
        value.int = 1
        
        XCTAssertEqual(value.int, 1)
        reversion.revert(&value)
        XCTAssertEqual(value.int, 0)
    }
    
    func testRevert_onMappedValueKeypath_willRevertValue() {
        
        var value = MockStruct()
        let reversion = SingleValueReversion(
            value: value.int,
            at: \.self
        )
        .mapped(to: \MockStruct.int)
        
        value.int = 1
        
        XCTAssertEqual(value.int, 1)
        reversion.revert(&value)
        XCTAssertEqual(value.int, 0)
    }
    
    func testRevert_onMappedReferenceKeypath_willRevertValue() {
        
        var value = MockClass()
        let reversion = SingleValueReversion(
            value: value.int,
            at: \.self
        )
        .mapped(to: \MockClass.int)
        
        value.int = 1
        
        XCTAssertEqual(value.int, 1)
        reversion.revert(&value)
        XCTAssertEqual(value.int, 0)
    }
}
