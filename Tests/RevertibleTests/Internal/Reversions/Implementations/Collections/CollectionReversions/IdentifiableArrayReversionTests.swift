import XCTest
@testable import Revertible

final class IdentifiableArrayReversionTests: XCTestCase {}

// MARK: - Tests
extension IdentifiableArrayReversionTests {
    
    // MARK: Insert
    func testRevert_onInsertReversion_withValueSelfKeyPath_willInsertElementsCorrectly() {
        
        var value = [
            MockStruct(id: 0),
            MockStruct(id: 1),
            MockStruct(id: 2),
            MockStruct(id: 3)
        ]

        let reversion = IdentifiableArrayReversion(
            insert: [
                .init(index: 0, element: MockStruct(id: 10)),
                .init(index: 7, element: MockStruct(id: 12)),
                .init(index: 6, element: MockStruct(id: 11)),
                .init(index: 2, element: MockStruct(id: 13))
            ]
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

        let reversion = IdentifiableArrayReversion(
            insert: [
                .init(index: 0, element: MockClass(id: 10)),
                .init(index: 7, element: MockClass(id: 12)),
                .init(index: 6, element: MockClass(id: 11)),
                .init(index: 2, element: MockClass(id: 13))
            ]
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
    
    // MARK: Remove
    func testRevert_onRemoveReversion_withValueSelfKeyPath_willRemoveElementsCorrectly() {
        
        var value = [
            MockStruct(id: 0),
            MockStruct(id: 1),
            MockStruct(id: 2),
            MockStruct(id: 3)
        ]
        
        let reversion = IdentifiableArrayReversion<[MockStruct], MockStruct>(
            remove: [
                2,
                1
            ]
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
        
        let reversion = IdentifiableArrayReversion<[MockClass], MockClass>(
            remove: [
                2,
                1
            ]
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
    
    // MARK: Move
    func testRevert_onMoveReversion_withValueSelfKeyPath_willMoveElementsCorrectly() {
        
        var value = [
            MockStruct(id: 0),
            MockStruct(id: 1),
            MockStruct(id: 2),
            MockStruct(id: 3)
        ]
        
        let reversion = IdentifiableArrayReversion<[MockStruct], MockStruct>(
            move: 0,
            to: 3
        )
        
        reversion.revert(&value)
        
        XCTAssertEqual(
            value,
            [
                MockStruct(id: 1),
                MockStruct(id: 2),
                MockStruct(id: 3),
                MockStruct(id: 0)
            ]
        )
    }
    
    func testRevert_onMoveReversion_withReferenceSelfKeyPath_willMoveElementsCorrectly() {
        
        var value = [
            MockClass(id: 0),
            MockClass(id: 1),
            MockClass(id: 2),
            MockClass(id: 3)
        ]
        
        let reversion = IdentifiableArrayReversion<[MockClass], MockClass>(
            move: 0,
            to: 3
        )
        
        reversion.revert(&value)
        
        XCTAssertEqual(
            value,
            [
                MockClass(id: 1),
                MockClass(id: 2),
                MockClass(id: 3),
                MockClass(id: 0)
            ]
        )
    }
    
    // MARK: Mapped insertion
    func testRevert_onInsertReversion_withMappedValueSelfValueChildKeyPath_willInsertElementsCorrectly() {

        var value = MockStruct()
        value.identifiableValueArray = [
            MockStruct(id: 0),
            MockStruct(id: 1),
            MockStruct(id: 2),
            MockStruct(id: 3)
        ]

        let reversion = IdentifiableArrayReversion(
            insert: [
                .init(index: 0, element: MockStruct(id: 10)),
                .init(index: 7, element: MockStruct(id: 12)),
                .init(index: 6, element: MockStruct(id: 11)),
                .init(index: 2, element: MockStruct(id: 13))
            ]
        )
        .mapped(to: \MockStruct.identifiableValueArray)

        reversion.revert(&value)

        XCTAssertEqual(
            value.identifiableValueArray,
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
    
    func testRevert_onInsertReversion_withMappedValueSelfReferenceChildKeyPath_willInsertElementsCorrectly() {

        var value = MockStruct()
        value.identifiableReferenceArray = [
            MockClass(id: 0),
            MockClass(id: 1),
            MockClass(id: 2),
            MockClass(id: 3)
        ]

        let reversion = IdentifiableArrayReversion(
            insert: [
                .init(index: 0, element: MockClass(id: 10)),
                .init(index: 7, element: MockClass(id: 12)),
                .init(index: 6, element: MockClass(id: 11)),
                .init(index: 2, element: MockClass(id: 13))
            ]
        )
        .mapped(to: \MockStruct.identifiableReferenceArray)

        reversion.revert(&value)

        XCTAssertEqual(
            value.identifiableReferenceArray,
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

    func testRevert_onInsertReversion_withMappedReferenceSelfValueChildKeyPath_willInsertElementsCorrectly() {
        
        var value = MockClass()
        value.identifiableValueArray = [
            MockStruct(id: 0),
            MockStruct(id: 1),
            MockStruct(id: 2),
            MockStruct(id: 3)
        ]

        let reversion = IdentifiableArrayReversion(
            insert: [
                .init(index: 0, element: MockStruct(id: 10)),
                .init(index: 7, element: MockStruct(id: 12)),
                .init(index: 6, element: MockStruct(id: 11)),
                .init(index: 2, element: MockStruct(id: 13))
            ]
        )
        .mapped(to: \MockClass.identifiableValueArray)
        
        reversion.revert(&value)
        
        XCTAssertEqual(
            value.identifiableValueArray,
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
    
    func testRevert_onInsertReversion_withMappedReferenceSelfReferenceChildKeyPath_willInsertElementsCorrectly() {
        
        var value = MockClass()
        value.identifiableReferenceArray = [
            MockClass(id: 0),
            MockClass(id: 1),
            MockClass(id: 2),
            MockClass(id: 3)
        ]

        let reversion = IdentifiableArrayReversion(
            insert: [
                .init(index: 0, element: MockClass(id: 10)),
                .init(index: 7, element: MockClass(id: 12)),
                .init(index: 6, element: MockClass(id: 11)),
                .init(index: 2, element: MockClass(id: 13))
            ]
        )
        .mapped(to: \MockClass.identifiableReferenceArray)
        
        reversion.revert(&value)
        
        XCTAssertEqual(
            value.identifiableReferenceArray,
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
    
    // MARK: Mapped removal
    func testRevert_onRemoveReversion_withMappedValueSelfValueChildKeyPath_willRemoveElementsCorrectly() {

        var value = MockStruct()
        value.identifiableValueArray = [
            MockStruct(id: 0),
            MockStruct(id: 1),
            MockStruct(id: 2),
            MockStruct(id: 3)
        ]

        let reversion = IdentifiableArrayReversion(
            remove: [
                1,
                2
            ]
        )
        .mapped(to: \MockStruct.identifiableValueArray)

        reversion.revert(&value)

        XCTAssertEqual(
            value.identifiableValueArray,
            [
                MockStruct(id: 0),
                MockStruct(id: 3)
            ]
        )
    }

    func testRevert_onRemoveReversion_withMappedValueSelfReferenceChildKeyPath_willRemoveElementsCorrectly() {

        var value = MockStruct()
        value.identifiableReferenceArray = [
            MockClass(id: 0),
            MockClass(id: 1),
            MockClass(id: 2),
            MockClass(id: 3)
        ]

        let reversion = IdentifiableArrayReversion(
            remove: [
                1,
                2
            ]
        )
        .mapped(to: \MockStruct.identifiableReferenceArray)

        reversion.revert(&value)

        XCTAssertEqual(
            value.identifiableReferenceArray,
            [
                MockClass(id: 0),
                MockClass(id: 3)
            ]
        )
    }

    func testRevert_onRemoveReversion_withMappedReferenceSelfValueChildKeyPath_willRemoveElementsCorrectly() {
        
        var value = MockClass()
        value.identifiableValueArray = [
            MockStruct(id: 0),
            MockStruct(id: 1),
            MockStruct(id: 2),
            MockStruct(id: 3)
        ]

        let reversion = IdentifiableArrayReversion(
            remove: [
                1,
                2
            ]
        )
        .mapped(to: \MockClass.identifiableValueArray)
        
        reversion.revert(&value)
        
        XCTAssertEqual(
            value.identifiableValueArray,
            [
                MockStruct(id: 0),
                MockStruct(id: 3)
            ]
        )
    }

    func testRevert_onRemoveReversion_withMappedReferenceSelfReferenceChildKeyPath_willRemoveElementsCorrectly() {
        
        var value = MockClass()
        value.identifiableReferenceArray = [
            MockClass(id: 0),
            MockClass(id: 1),
            MockClass(id: 2),
            MockClass(id: 3)
        ]

        let reversion = IdentifiableArrayReversion(
            remove: [
                1,
                2
            ]
        )
        .mapped(to: \MockClass.identifiableReferenceArray)
        
        reversion.revert(&value)
        
        XCTAssertEqual(
            value.identifiableReferenceArray,
            [
                MockClass(id: 0),
                MockClass(id: 3)
            ]
        )
    }

    // MARK: Mapped move
    func testRevert_onMoveReversion_withMappedValueSelfValueChildKeyPath_willMoveElementsCorrectly() {

        var value = MockStruct()
        value.identifiableValueArray = [
            MockStruct(id: 0),
            MockStruct(id: 1),
            MockStruct(id: 2),
            MockStruct(id: 3)
        ]

        let reversion = IdentifiableArrayReversion(
            move: 0,
            to: 3
        )
        .mapped(to: \MockStruct.identifiableValueArray)

        reversion.revert(&value)

        XCTAssertEqual(
            value.identifiableValueArray,
            [
                MockStruct(id: 1),
                MockStruct(id: 2),
                MockStruct(id: 3),
                MockStruct(id: 0)
            ]
        )
    }
    
    func testRevert_onMoveReversion_withMappedValueSelfReferenceChildKeyPath_willMoveElementsCorrectly() {

        var value = MockStruct()
        value.identifiableReferenceArray = [
            MockClass(id: 0),
            MockClass(id: 1),
            MockClass(id: 2),
            MockClass(id: 3)
        ]

        let reversion = IdentifiableArrayReversion(
            move: 0,
            to: 3
        )
        .mapped(to: \MockStruct.identifiableReferenceArray)

        reversion.revert(&value)

        XCTAssertEqual(
            value.identifiableReferenceArray,
            [
                MockClass(id: 1),
                MockClass(id: 2),
                MockClass(id: 3),
                MockClass(id: 0)
            ]
        )
    }
    
    func testRevert_onMoveReversion_withMappedReferenceSelfValueChildKeyPath_willMoveElementsCorrectly() {

        var value = MockClass()
        value.identifiableValueArray = [
            MockStruct(id: 0),
            MockStruct(id: 1),
            MockStruct(id: 2),
            MockStruct(id: 3)
        ]

        let reversion = IdentifiableArrayReversion(
            move: 0,
            to: 3
        )
        .mapped(to: \MockClass.identifiableValueArray)

        reversion.revert(&value)

        XCTAssertEqual(
            value.identifiableValueArray,
            [
                MockStruct(id: 1),
                MockStruct(id: 2),
                MockStruct(id: 3),
                MockStruct(id: 0)
            ]
        )
    }
    
    func testRevert_onMoveReversion_withMappedReferenceSelfReferenceChildKeyPath_willMoveElementsCorrectly() {

        var value = MockClass()
        value.identifiableReferenceArray = [
            MockClass(id: 0),
            MockClass(id: 1),
            MockClass(id: 2),
            MockClass(id: 3)
        ]

        let reversion = IdentifiableArrayReversion(
            move: 0,
            to: 3
        )
        .mapped(to: \MockClass.identifiableReferenceArray)

        reversion.revert(&value)

        XCTAssertEqual(
            value.identifiableReferenceArray,
            [
                MockClass(id: 1),
                MockClass(id: 2),
                MockClass(id: 3),
                MockClass(id: 0)
            ]
        )
    }
}
