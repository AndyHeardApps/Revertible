import XCTest
@testable import Revertable

final class ArrayReversionTests: XCTestCase {}

// MARK: - Tests
extension ArrayReversionTests {
    
    // MARK: Insert
    func testRevert_onInsertReversion_withValueSelfKeyPath_willInsertElementsCorrectly() {
        
        var value = [
            MockStruct(id: 0),
            MockStruct(id: 1),
            MockStruct(id: 2),
            MockStruct(id: 3)
        ]

        let reversion = ArrayReversion(
            insert: [
                .init(index: 0, element: MockStruct(id: 10)),
                .init(index: 7, element: MockStruct(id: 12)),
                .init(index: 6, element: MockStruct(id: 11)),
                .init(index: 2, element: MockStruct(id: 13))
            ],
            inArrayAt: \.self
        )
        
        reversion.revert(&value)
        
        XCTAssertEqual(
            value,
            [
                MockStruct(id: 10),
                MockStruct(id: 0),
                MockStruct(id: 13),
                MockStruct(id: 1),
                MockStruct(id: 2),
                MockStruct(id: 3),
                MockStruct(id: 11),
                MockStruct(id: 12)
            ]
        )
    }
    
    func testRevert_onInsertReversion_withReferenceSelfKeyPath_willInsertElementsCorrectly() {
        
        var value = [
            MockClass(id: 0),
            MockClass(id: 1),
            MockClass(id: 2),
            MockClass(id: 3)
        ]

        let reversion = ArrayReversion(
            insert: [
                .init(index: 0, element: MockClass(id: 10)),
                .init(index: 7, element: MockClass(id: 12)),
                .init(index: 6, element: MockClass(id: 11)),
                .init(index: 2, element: MockClass(id: 13))
            ],
            inArrayAt: \.self
        )
        
        reversion.revert(&value)
        
        XCTAssertEqual(
            value,
            [
                MockClass(id: 10),
                MockClass(id: 0),
                MockClass(id: 13),
                MockClass(id: 1),
                MockClass(id: 2),
                MockClass(id: 3),
                MockClass(id: 11),
                MockClass(id: 12)
            ]
        )
    }
    
    func testRevert_onInsertReversion_withValueChildKeyPath_willInsertElementsCorrectly() {
        
        var value = MockStruct()
        
        let reversion = ArrayReversion(
            insert: [
                .init(index: 0, element: 10),
                .init(index: 7, element: 12),
                .init(index: 6, element: 11),
                .init(index: 2, element: 13)
            ],
            inArrayAt: \MockStruct.equatableArray
        )
        
        reversion.revert(&value)
        
        XCTAssertEqual(value.equatableArray, [10, 0, 13, 1, 2, 3, 11, 12])
    }

    func testRevert_onInsertReversion_withReferenceChildKeyPath_willInsertElementsCorrectly() {
        
        var value = MockClass()
        
        let reversion = ArrayReversion(
            insert: [
                .init(index: 0, element: 10),
                .init(index: 7, element: 12),
                .init(index: 6, element: 11),
                .init(index: 2, element: 13)
            ],
            inArrayAt: \MockClass.equatableArray
        )
        
        reversion.revert(&value)
        
        XCTAssertEqual(value.equatableArray, [10, 0, 13, 1, 2, 3, 11, 12])
    }
    
    // MARK: Remove
    func testRevert_onRemoveReversion_withValueSelfKeyPath_willRemoveElementsCorrectly() {
        
        var value = [
            MockStruct(id: 0),
            MockStruct(id: 1),
            MockStruct(id: 2),
            MockStruct(id: 3)
        ]
        
        let reversion = ArrayReversion<[MockStruct], MockStruct>(
            remove: [
                2,
                1
            ],
            fromArrayAt: \.self
        )
        
        reversion.revert(&value)
        
        XCTAssertEqual(
            value,
            [
                MockStruct(id: 0),
                MockStruct(id: 3)
            ]
        )
    }
    
    func testRevert_onRemoveReversion_withReferenceSelfKeyPath_willRemoveElementsCorrectly() {
        
        var value = [
            MockClass(id: 0),
            MockClass(id: 1),
            MockClass(id: 2),
            MockClass(id: 3)
        ]
        
        let reversion = ArrayReversion<[MockClass], MockClass>(
            remove: [
                2,
                1
            ],
            fromArrayAt: \.self
        )
        
        reversion.revert(&value)
        
        XCTAssertEqual(
            value,
            [
                MockClass(id: 0),
                MockClass(id: 3)
            ]
        )
    }
    
    func testRevert_onRemoveReversion_withValueChildKeyPath_willRemoveElementsCorrectly() {
        
        var value = MockStruct()
        
        let reversion = ArrayReversion(
            remove: [
                1,
                2
            ],
            fromArrayAt: \MockStruct.equatableArray
        )
        
        reversion.revert(&value)
        
        XCTAssertEqual(value.equatableArray, [0, 3])
    }

    func testRevert_onRemoveReversion_withReferenceChildKeyPath_willRemoveElementsCorrectly() {
        
        var value = MockClass()
        
        let reversion = ArrayReversion(
            remove: [
                1,
                2
            ],
            fromArrayAt: \MockClass.equatableArray
        )
        
        reversion.revert(&value)
        
        XCTAssertEqual(value.equatableArray, [0, 3])
    }
    
    // MARK: Mapped insertion
    func testRevert_onInsertReversion_withMappedValueChildKeyPath_willInsertElementsCorrectly() {

        var value = MockStruct()
        
        let reversion = ArrayReversion(
            insert: [
                .init(index: 0, element: 10),
                .init(index: 7, element: 12),
                .init(index: 6, element: 11),
                .init(index: 2, element: 13)
            ],
            inArrayAt: \.self
        )
        .mapped(to: \MockStruct.equatableArray)

        reversion.revert(&value)

        XCTAssertEqual(value.equatableArray, [10, 0, 13, 1, 2, 3, 11, 12])
    }

    func testRevert_onInsertReversion_withMappedReferenceChildKeyPath_willInsertElementsCorrectly() {
        
        var value = MockClass()
        
        let reversion = ArrayReversion(
            insert: [
                .init(index: 0, element: 10),
                .init(index: 7, element: 12),
                .init(index: 6, element: 11),
                .init(index: 2, element: 13)
            ],
            inArrayAt: \.self
        )
        .mapped(to: \MockClass.equatableArray)
        
        reversion.revert(&value)
        
        XCTAssertEqual(value.equatableArray, [10, 0, 13, 1, 2, 3, 11, 12])
    }
    
    // MARK: Mapped removal
    func testRevert_onRemovalReversion_withMappedValueChildKeyPath_willRemoveElementsCorrectly() {

        var value = MockStruct()
        
        let reversion = ArrayReversion(
            remove: [
                1,
                2
            ],
            fromArrayAt: \.self
        )
        .mapped(to: \MockStruct.equatableArray)

        reversion.revert(&value)

        XCTAssertEqual(value.equatableArray, [0, 3])
    }

    func testRevert_onRemoveReversion_withMappedReferenceChildKeyPath_willRemoveElementsCorrectly() {
        
        var value = MockClass()
        
        let reversion = ArrayReversion(
            remove: [
                1,
                2
            ],
            fromArrayAt: \.self
        )
        .mapped(to: \MockClass.equatableArray)
        
        reversion.revert(&value)
        
        XCTAssertEqual(value.equatableArray, [0, 3])
    }
}
