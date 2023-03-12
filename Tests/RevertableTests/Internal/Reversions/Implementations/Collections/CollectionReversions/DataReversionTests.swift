import XCTest
@testable import Revertable

final class DataReversionTests: XCTestCase {}

// MARK: - Tests
extension DataReversionTests {
    
    // MARK: Insert
    func testRevert_onInsertReversion_withSelfKeyPath_willInsertElementsCorrectly() {
        
        var value = Data([0, 1, 2, 3])
        
        let reversion = DataReversion(
            insert: [
                .init(index: 0, element: .init(10)),
                .init(index: 6, element: .init(11)),
                .init(index: 7, element: .init(12)),
                .init(index: 2, element: .init(13))
            ]
        )
        
        reversion.revert(&value)
        
        XCTAssertEqual(value, Data([10, 0, 13, 1, 2, 3, 11, 12]))
    }
    
    // MARK: Remove
    func testRevert_onRemoveReversion_withSelfKeyPath_willRemoveElementsCorrectly() {
        
        var value = Data([0, 1, 2, 3])
        
        let reversion = DataReversion(
            remove: [
                0,
                2,
                3
            ]
        )
        
        reversion.revert(&value)
        
        XCTAssertEqual(value, Data([1]))
    }
    
    // MARK: Mapped insertion
    func testRevert_onInsertReversion_withMappedValueChildKeyPath_willInsertElementsCorrectly() {

        var value = MockStruct()
        
        let reversion = DataReversion(
            insert: [
                .init(index: 0, element: .init(10)),
                .init(index: 6, element: .init(11)),
                .init(index: 7, element: .init(12)),
                .init(index: 2, element: .init(13))
            ]
        )
        .mapped(to: \MockStruct.data)

        reversion.revert(&value)

        XCTAssertEqual(value.data, Data([10, 0, 13, 1, 2, 3, 11, 12]))
    }

    func testRevert_onInsertReversion_withMappedReferenceChildKeyPath_willInsertElementsCorrectly() {
        
        var value = MockClass()
        
        let reversion = DataReversion(
            insert: [
                .init(index: 0, element: .init(10)),
                .init(index: 6, element: .init(11)),
                .init(index: 7, element: .init(12)),
                .init(index: 2, element: .init(13))
            ]
        )
        .mapped(to: \MockClass.data)
        
        reversion.revert(&value)
        
        XCTAssertEqual(value.data, Data([10, 0, 13, 1, 2, 3, 11, 12]))
    }
    
    // MARK: Mapped removal
    func testRevert_onRemovalReversion_withMappedValueChildKeyPath_willRemoveElementsCorrectly() {

        var value = MockStruct()
        
        let reversion = DataReversion(
            remove: [
                0,
                2,
                3
            ]
        )
        .mapped(to: \MockStruct.data)

        reversion.revert(&value)

        XCTAssertEqual(value.data, Data([1]))
    }

    func testRevert_onRemoveReversion_withMappedReferenceChildKeyPath_willRemoveElementsCorrectly() {
        
        var value = MockClass()
        
        let reversion = DataReversion(
            remove: [
                0,
                2,
                3
            ]
        )
        .mapped(to: \MockClass.data)
        
        reversion.revert(&value)
        
        XCTAssertEqual(value.data, Data([1]))
    }
}
