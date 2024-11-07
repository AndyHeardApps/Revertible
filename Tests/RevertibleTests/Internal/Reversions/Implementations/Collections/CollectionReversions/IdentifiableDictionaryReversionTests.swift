import XCTest
@testable import Revertible

final class IdentifiableDictionaryReversionTests: XCTestCase {}

// MARK: - Tests
extension IdentifiableDictionaryReversionTests {
    
    // MARK: Insert
    func testRevert_onInsertReversion_withValueSelfKeyPath_willInsertElementsCorrectly() {

        var value = [
            0 : MockStruct(id: 0),
            1 : MockStruct(id: 1),
            2 : MockStruct(id: 2),
            3 : MockStruct(id: 3)
        ]

        let reversion = IdentifiableDictionaryReversion(
            insert: [
                0 : MockStruct(id: 5),
                4 : MockStruct(id: 4)
            ]
        )

        reversion.revert(&value)

        XCTAssertEqual(
            value,
            [
                0 : MockStruct(id: 5),
                1 : MockStruct(id: 1),
                2 : MockStruct(id: 2),
                3 : MockStruct(id: 3),
                4 : MockStruct(id: 4)
            ]
        )
    }

    func testRevert_onInsertReversion_withReferenceSelfKeyPath_willInsertElementsCorrectly() {

        var value = [
            0 : MockClass(id: 0),
            1 : MockClass(id: 1),
            2 : MockClass(id: 2),
            3 : MockClass(id: 3)
        ]

        let reversion = IdentifiableDictionaryReversion(
            insert: [
                0 : MockClass(id: 5),
                4 : MockClass(id: 4)
            ]
        )

        reversion.revert(&value)

        XCTAssertEqual(
            value,
            [
                0 : MockClass(id: 5),
                1 : MockClass(id: 1),
                2 : MockClass(id: 2),
                3 : MockClass(id: 3),
                4 : MockClass(id: 4)
            ]
        )
    }

    // MARK: Remove
    func testRevert_onRemoveReversion_withValueSelfKeyPath_willRemoveElementsCorrectly() {

        var value = [
            0 : MockStruct(id: 0),
            1 : MockStruct(id: 1),
            2 : MockStruct(id: 2),
            3 : MockStruct(id: 3)
        ]

        let reversion = IdentifiableDictionaryReversion<[Int : MockStruct], Int, MockStruct>(
            remove: [
                2,
                1
            ]
        )

        reversion.revert(&value)

        XCTAssertEqual(
            value,
            [
                0 : MockStruct(id: 0),
                3 : MockStruct(id: 3)
            ]
        )
    }

    func testRevert_onRemoveReversion_withReferenceSelfKeyPath_willRemoveElementsCorrectly() {

        var value = [
            0 : MockClass(id: 0),
            1 : MockClass(id: 1),
            2 : MockClass(id: 2),
            3 : MockClass(id: 3)
        ]

        let reversion = IdentifiableDictionaryReversion<[Int : MockClass], Int, MockClass>(
            remove: [
                2,
                1
            ]
        )

        reversion.revert(&value)

        XCTAssertEqual(
            value,
            [
                0 : MockClass(id: 0),
                3 : MockClass(id: 3)
            ]
        )
    }

    // MARK: Move
    func testRevert_onMoveReversion_withValueSelfKeyPath_willMoveElementsCorrectly() {

        var value = [
            0 : MockStruct(id: 0),
            1 : MockStruct(id: 1),
            2 : MockStruct(id: 2),
            3 : MockStruct(id: 3)
        ]

        let reversion = IdentifiableDictionaryReversion<[Int : MockStruct], Int, MockStruct>(
            move: 0,
            to: 3
        )

        reversion.revert(&value)

        XCTAssertEqual(
            value,
            [
                1 : MockStruct(id: 1),
                2 : MockStruct(id: 2),
                3 : MockStruct(id: 0)
            ]
        )
    }

    func testRevert_onMoveReversion_withReferenceSelfKeyPath_willMoveElementsCorrectly() {

        var value = [
            0 : MockClass(id: 0),
            1 : MockClass(id: 1),
            2 : MockClass(id: 2),
            3 : MockClass(id: 3)
        ]

        let reversion = IdentifiableDictionaryReversion<[Int : MockClass], Int, MockClass>(
            move: 0,
            to: 3
        )

        reversion.revert(&value)

        XCTAssertEqual(
            value,
            [
                1 : MockClass(id: 1),
                2 : MockClass(id: 2),
                3 : MockClass(id: 0)
            ]
        )
    }

    // MARK: Mapped insertion
    func testRevert_onInsertReversion_withMappedValueSelfValueChildKeyPath_willInsertElementsCorrectly() {

        var value = MockStruct()
        value.identifiableValueDictionary = [
            0 : MockStruct(id: 0),
            1 : MockStruct(id: 1),
            2 : MockStruct(id: 2),
            3 : MockStruct(id: 3)
        ]

        let reversion = IdentifiableDictionaryReversion(
            insert: [
                0 : MockStruct(id: 5),
                4 : MockStruct(id: 4)
            ]
        )
        .mapped(to: \MockStruct.identifiableValueDictionary)

        reversion.revert(&value)

        XCTAssertEqual(
            value.identifiableValueDictionary,
            [
                0 : MockStruct(id: 5),
                1 : MockStruct(id: 1),
                2 : MockStruct(id: 2),
                3 : MockStruct(id: 3),
                4 : MockStruct(id: 4)
            ]
        )
    }

    func testRevert_onInsertReversion_withMappedValueSelfReferenceChildKeyPath_willInsertElementsCorrectly() {

        var value = MockStruct()
        value.identifiableReferenceDictionary = [
            0 : MockClass(id: 0),
            1 : MockClass(id: 1),
            2 : MockClass(id: 2),
            3 : MockClass(id: 3)
        ]

        let reversion = IdentifiableDictionaryReversion(
            insert: [
                0 : MockClass(id: 5),
                4 : MockClass(id: 4)
            ]
        )
        .mapped(to: \MockStruct.identifiableReferenceDictionary)

        reversion.revert(&value)

        XCTAssertEqual(
            value.identifiableReferenceDictionary,
            [
                0 : MockClass(id: 5),
                1 : MockClass(id: 1),
                2 : MockClass(id: 2),
                3 : MockClass(id: 3),
                4 : MockClass(id: 4)
            ]
        )
    }

    func testRevert_onInsertReversion_withMappedReferenceSelfValueChildKeyPath_willInsertElementsCorrectly() {

        var value = MockClass()
        value.identifiableValueDictionary = [
            0 : MockStruct(id: 0),
            1 : MockStruct(id: 1),
            2 : MockStruct(id: 2),
            3 : MockStruct(id: 3)
        ]

        let reversion = IdentifiableDictionaryReversion(
            insert: [
                0 : MockStruct(id: 5),
                4 : MockStruct(id: 4)
            ]
        )
        .mapped(to: \MockClass.identifiableValueDictionary)

        reversion.revert(&value)

        XCTAssertEqual(
            value.identifiableValueDictionary,
            [
                0 : MockStruct(id: 5),
                1 : MockStruct(id: 1),
                2 : MockStruct(id: 2),
                3 : MockStruct(id: 3),
                4 : MockStruct(id: 4)
            ]
        )
    }

    func testRevert_onInsertReversion_withMappedReferenceSelfReferenceChildKeyPath_willInsertElementsCorrectly() {

        var value = MockClass()
        value.identifiableReferenceDictionary = [
            0 : MockClass(id: 0),
            1 : MockClass(id: 1),
            2 : MockClass(id: 2),
            3 : MockClass(id: 3)
        ]

        let reversion = IdentifiableDictionaryReversion(
            insert: [
                0 : MockClass(id: 5),
                4 : MockClass(id: 4)
            ]
        )
        .mapped(to: \MockClass.identifiableReferenceDictionary)

        reversion.revert(&value)

        XCTAssertEqual(
            value.identifiableReferenceDictionary,
            [
                0 : MockClass(id: 5),
                1 : MockClass(id: 1),
                2 : MockClass(id: 2),
                3 : MockClass(id: 3),
                4 : MockClass(id: 4)
            ]
        )
    }

    // MARK: Mapped removal
    func testRevert_onRemoveReversion_withMappedValueSelfValueChildKeyPath_willRemoveElementsCorrectly() {

        var value = MockStruct()
        value.identifiableValueDictionary = [
            0 : MockStruct(id: 0),
            1 : MockStruct(id: 1),
            2 : MockStruct(id: 2),
            3 : MockStruct(id: 3)
        ]

        let reversion = IdentifiableDictionaryReversion(
            remove: [
                1,
                2
            ]
        )
        .mapped(to: \MockStruct.identifiableValueDictionary)

        reversion.revert(&value)

        XCTAssertEqual(
            value.identifiableValueDictionary,
            [
                0 : MockStruct(id: 0),
                3 : MockStruct(id: 3)
            ]
        )
    }

    func testRevert_onRemoveReversion_withMappedValueSelfReferenceChildKeyPath_willRemoveElementsCorrectly() {

        var value = MockStruct()
        value.identifiableReferenceDictionary = [
            0 : MockClass(id: 0),
            1 : MockClass(id: 1),
            2 : MockClass(id: 2),
            3 : MockClass(id: 3)
        ]

        let reversion = IdentifiableDictionaryReversion(
            remove: [
                1,
                2
            ]
        )
        .mapped(to: \MockStruct.identifiableReferenceDictionary)

        reversion.revert(&value)

        XCTAssertEqual(
            value.identifiableReferenceDictionary,
            [
                0 : MockClass(id: 0),
                3 : MockClass(id: 3)
            ]
        )
    }

    func testRevert_onRemoveReversion_withMappedReferenceSelfValueChildKeyPath_willRemoveElementsCorrectly() {

        var value = MockClass()
        value.identifiableValueDictionary = [
            0 : MockStruct(id: 0),
            1 : MockStruct(id: 1),
            2 : MockStruct(id: 2),
            3 : MockStruct(id: 3)
        ]

        let reversion = IdentifiableDictionaryReversion(
            remove: [
                1,
                2
            ]
        )
        .mapped(to: \MockClass.identifiableValueDictionary)

        reversion.revert(&value)

        XCTAssertEqual(
            value.identifiableValueDictionary,
            [
                0 : MockStruct(id: 0),
                3 : MockStruct(id: 3)
            ]
        )
    }

    func testRevert_onRemoveReversion_withMappedReferenceSelfReferenceChildKeyPath_willRemoveElementsCorrectly() {

        var value = MockClass()
        value.identifiableReferenceDictionary = [
            0 : MockClass(id: 0),
            1 : MockClass(id: 1),
            2 : MockClass(id: 2),
            3 : MockClass(id: 3)
        ]

        let reversion = IdentifiableDictionaryReversion(
            remove: [
                1,
                2
            ]
        )
        .mapped(to: \MockClass.identifiableReferenceDictionary)

        reversion.revert(&value)

        XCTAssertEqual(
            value.identifiableReferenceDictionary,
            [
                0 : MockClass(id: 0),
                3 : MockClass(id: 3)
            ]
        )
    }

    // MARK: Mapped move
    func testRevert_onMoveReversion_withMappedValueSelfValueChildKeyPath_willMoveElementsCorrectly() {

        var value = MockStruct()
        value.identifiableValueDictionary = [
            0 : MockStruct(id: 0),
            1 : MockStruct(id: 1),
            2 : MockStruct(id: 2),
            3 : MockStruct(id: 3)
        ]

        let reversion = IdentifiableDictionaryReversion(
            move: 0,
            to: 3
        )
        .mapped(to: \MockStruct.identifiableValueDictionary)

        reversion.revert(&value)

        XCTAssertEqual(
            value.identifiableValueDictionary,
            [
                1 : MockStruct(id: 1),
                2 : MockStruct(id: 2),
                3 : MockStruct(id: 0)
            ]
        )
    }

    func testRevert_onMoveReversion_withMappedValueSelfReferenceChildKeyPath_willMoveElementsCorrectly() {

        var value = MockStruct()
        value.identifiableReferenceDictionary = [
            0 : MockClass(id: 0),
            1 : MockClass(id: 1),
            2 : MockClass(id: 2),
            3 : MockClass(id: 3)
        ]

        let reversion = IdentifiableDictionaryReversion(
            move: 0,
            to: 3
        )
        .mapped(to: \MockStruct.identifiableReferenceDictionary)

        reversion.revert(&value)

        XCTAssertEqual(
            value.identifiableReferenceDictionary,
            [
                1 : MockClass(id: 1),
                2 : MockClass(id: 2),
                3 : MockClass(id: 0)
            ]
        )
    }

    func testRevert_onMoveReversion_withMappedReferenceSelfValueChildKeyPath_willMoveElementsCorrectly() {

        var value = MockClass()
        value.identifiableValueDictionary = [
            0 : MockStruct(id: 0),
            1 : MockStruct(id: 1),
            2 : MockStruct(id: 2),
            3 : MockStruct(id: 3)
        ]

        let reversion = IdentifiableDictionaryReversion(
            move: 0,
            to: 3
        )
        .mapped(to: \MockClass.identifiableValueDictionary)

        reversion.revert(&value)

        XCTAssertEqual(
            value.identifiableValueDictionary,
            [
                1 : MockStruct(id: 1),
                2 : MockStruct(id: 2),
                3 : MockStruct(id: 0)
            ]
        )
    }

    func testRevert_onMoveReversion_withMappedReferenceSelfReferenceChildKeyPath_willMoveElementsCorrectly() {

        var value = MockClass()
        value.identifiableReferenceDictionary = [
            0 : MockClass(id: 0),
            1 : MockClass(id: 1),
            2 : MockClass(id: 2),
            3 : MockClass(id: 3)
        ]

        let reversion = IdentifiableDictionaryReversion(
            move: 0,
            to: 3
        )
        .mapped(to: \MockClass.identifiableReferenceDictionary)

        reversion.revert(&value)

        XCTAssertEqual(
            value.identifiableReferenceDictionary,
            [
                1 : MockClass(id: 1),
                2 : MockClass(id: 2),
                3 : MockClass(id: 0)
            ]
        )
    }
}
