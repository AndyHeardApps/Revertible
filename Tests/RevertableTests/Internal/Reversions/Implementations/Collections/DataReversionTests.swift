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
                .init(index: 0, elements: .init([10])),
                .init(index: 6, elements: .init([11, 12])),
                .init(index: 2, elements: .init([13]))
            ],
            inDataAt: \.self
        )
        
        reversion.revert(&value)
        
        XCTAssertEqual(value, Data([10, 0, 13, 1, 2, 3, 11, 12]))
    }
    
    func testRevert_onInsertReversion_withValueChildKeyPath_willInsertElementsCorrectly() {
        
        var value = MockStruct()
        
        let reversion = DataReversion(
            insert: [
                .init(index: 0, elements: .init([10])),
                .init(index: 6, elements: .init([11, 12])),
                .init(index: 2, elements: .init([13]))
            ],
            inDataAt: \MockStruct.data
        )
        
        reversion.revert(&value)
        
        XCTAssertEqual(value.data, Data([10, 0, 13, 1, 2, 3, 11, 12]))
    }

    func testRevert_onInsertReversion_withReferenceChildKeyPath_willInsertElementsCorrectly() {
        
        var value = MockClass()
        
        let reversion = DataReversion(
            insert: [
                .init(index: 0, elements: .init([10])),
                .init(index: 6, elements: .init([11, 12])),
                .init(index: 2, elements: .init([13]))
            ],
            inDataAt: \MockClass.data
        )
        
        reversion.revert(&value)
        
        XCTAssertEqual(value.data, Data([10, 0, 13, 1, 2, 3, 11, 12]))
    }
    
    // MARK: Remove
    func testRevert_onRemoveReversion_withSelfKeyPath_willRemoveElementsCorrectly() {
        
        var value = Data([0, 1, 2, 3])
        
        let reversion = DataReversion(
            remove: [
                0...0,
                2...3
            ],
            fromDataAt: \.self
        )
        
        reversion.revert(&value)
        
        XCTAssertEqual(value, Data([1]))
    }
    
    func testRevert_onRemoveReversion_withValueChildKeyPath_willRemoveElementsCorrectly() {
        
        var value = MockStruct()
        
        let reversion = DataReversion(
            remove: [
                0...0,
                2...3
            ],
            fromDataAt: \MockStruct.data
        )
        
        reversion.revert(&value)
        
        XCTAssertEqual(value.data, Data([1]))
    }

    func testRevert_onRemoveReversion_withReferenceChildKeyPath_willRemoveElementsCorrectly() {
        
        var value = MockClass()
        
        let reversion = DataReversion(
            remove: [
                0...0,
                2...3
            ],
            fromDataAt: \MockClass.data
        )

        reversion.revert(&value)
        
        XCTAssertEqual(value.data, Data([1]))
    }
    
    // MARK: Mapped insertion
    func testRevert_onInsertReversion_withMappedValueChildKeyPath_willInsertElementsCorrectly() {

        var value = MockStruct()
        
        let reversion = DataReversion(
            insert: [
                .init(index: 0, elements: .init([10])),
                .init(index: 6, elements: .init([11, 12])),
                .init(index: 2, elements: .init([13]))
            ],
            inDataAt: \.self
        )
        .mapped(to: \MockStruct.data)

        reversion.revert(&value)

        XCTAssertEqual(value.data, Data([10, 0, 13, 1, 2, 3, 11, 12]))
    }

    func testRevert_onInsertReversion_withMappedReferenceChildKeyPath_willInsertElementsCorrectly() {
        
        var value = MockClass()
        
        let reversion = DataReversion(
            insert: [
                .init(index: 0, elements: .init([10])),
                .init(index: 6, elements: .init([11, 12])),
                .init(index: 2, elements: .init([13]))
            ],
            inDataAt: \.self
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
                0...0,
                2...3
            ],
            fromDataAt: \.self
        )
        .mapped(to: \MockStruct.data)

        reversion.revert(&value)

        XCTAssertEqual(value.data, Data([1]))
    }

    func testRevert_onRemoveReversion_withMappedReferenceChildKeyPath_willRemoveElementsCorrectly() {
        
        var value = MockClass()
        
        let reversion = DataReversion(
            remove: [
                0...0,
                2...3
            ],
            fromDataAt: \.self
        )
        .mapped(to: \MockClass.data)
        
        reversion.revert(&value)
        
        XCTAssertEqual(value.data, Data([1]))
    }
}
