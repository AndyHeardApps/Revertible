import XCTest
@testable import Revertable

final class SetReversionTests: XCTestCase {}

// MARK: - Tests
extension SetReversionTests {
    
    // MARK: Insert
    func testRevert_onInsertReversion_withValueSelfKeyPath_willInsertElementsCorrectly() {
        
        var value = Set([
            MockStruct(id: 0),
            MockStruct(id: 1),
            MockStruct(id: 2),
            MockStruct(id: 3)
        ])

        let reversion = SetReversion(
            insert: [
                MockStruct(id: 10),
                MockStruct(id: 12),
                MockStruct(id: 11),
                MockStruct(id: 13)
            ],
            inSetAt: \.self
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

        var value = Set([
            MockClass(id: 0),
            MockClass(id: 1),
            MockClass(id: 2),
            MockClass(id: 3)
        ])

        let reversion = SetReversion(
            insert: [
                MockClass(id: 10),
                MockClass(id: 12),
                MockClass(id: 11),
                MockClass(id: 13)
            ],
            inSetAt: \.self
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

        let reversion = SetReversion(
            insert: [
                10,
                12,
                11,
                13
            ],
            inSetAt: \MockStruct.equatableSet
        )

        reversion.revert(&value)

        XCTAssertEqual(value.equatableSet, [10, 0, 13, 1, 2, 3, 11, 12])
    }

    func testRevert_onInsertReversion_withReferenceChildKeyPath_willInsertElementsCorrectly() {

        var value = MockClass()

        let reversion = SetReversion(
            insert: [
                10,
                12,
                11,
                13
            ],
            inSetAt: \MockClass.equatableSet
        )

        reversion.revert(&value)

        XCTAssertEqual(value.equatableSet, [10, 0, 13, 1, 2, 3, 11, 12])
    }

    // MARK: Remove
    func testRevert_onRemoveReversion_withValueSelfKeyPath_willRemoveElementsCorrectly() {

        var value = Set([
            MockStruct(id: 0),
            MockStruct(id: 1),
            MockStruct(id: 2),
            MockStruct(id: 3)
        ])

        let reversion = SetReversion(
            remove: [
                MockStruct(id: 1),
                MockStruct(id: 2),
            ],
            fromSetAt: \.self
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

        var value = Set([
            MockClass(id: 0),
            MockClass(id: 1),
            MockClass(id: 2),
            MockClass(id: 3)
        ])

        let reversion = SetReversion(
            remove: [
                MockClass(id: 1),
                MockClass(id: 2),
            ],
            fromSetAt: \.self
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

        let reversion = SetReversion(
            remove: [
                1,
                2
            ],
            fromSetAt: \MockStruct.equatableSet
        )

        reversion.revert(&value)

        XCTAssertEqual(value.equatableSet, [0, 3])
    }

    func testRevert_onRemoveReversion_withReferenceChildKeyPath_willRemoveElementsCorrectly() {

        var value = MockClass()

        let reversion = SetReversion(
            remove: [
                1,
                2
            ],
            fromSetAt: \MockClass.equatableSet
        )

        reversion.revert(&value)

        XCTAssertEqual(value.equatableSet, [0, 3])
    }

    // MARK: Mapped insertion
    func testRevert_onInsertReversion_withMappedValueChildKeyPath_willInsertElementsCorrectly() {

        var value = MockStruct()

        let reversion = SetReversion(
            insert: [
                10,
                12,
                11,
                13
            ],
            inSetAt: \.self
        )
        .mapped(to: \MockStruct.equatableSet)

        reversion.revert(&value)

        XCTAssertEqual(value.equatableSet, [10, 0, 13, 1, 2, 3, 11, 12])
    }

    func testRevert_onInsertReversion_withMappedReferenceChildKeyPath_willInsertElementsCorrectly() {

        var value = MockClass()

        let reversion = SetReversion(
            insert: [
                10,
                12,
                11,
                13
            ],
            inSetAt: \.self
        )
        .mapped(to: \MockClass.equatableSet)

        reversion.revert(&value)

        XCTAssertEqual(value.equatableSet, [10, 0, 13, 1, 2, 3, 11, 12])
    }

    // MARK: Mapped removal
    func testRevert_onRemovalReversion_withMappedValueChildKeyPath_willRemoveElementsCorrectly() {

        var value = MockStruct()

        let reversion = SetReversion(
            remove: [
                1,
                2
            ],
            fromSetAt: \.self
        )
        .mapped(to: \MockStruct.equatableSet)

        reversion.revert(&value)

        XCTAssertEqual(value.equatableSet, [0, 3])
    }

    func testRevert_onRemoveReversion_withMappedReferenceChildKeyPath_willRemoveElementsCorrectly() {

        var value = MockClass()

        let reversion = SetReversion(
            remove: [
                1,
                2
            ],
            fromSetAt: \.self
        )
        .mapped(to: \MockClass.equatableSet)

        reversion.revert(&value)

        XCTAssertEqual(value.equatableSet, [0, 3])
    }
}
