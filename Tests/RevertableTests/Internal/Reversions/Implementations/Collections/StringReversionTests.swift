import XCTest
@testable import Revertable

final class StringReversionTests: XCTestCase {}

// MARK: - Helpers
extension String {
    
    func index(_ offset: Int) -> Index {
        
        self.index(startIndex, offsetBy: offset)
    }
}

// MARK: - Tests
extension StringReversionTests {
    
    // MARK: Insert
    func testRevert_onInsertReversion_withSelfKeyPath_willInsertElementsCorrectly() {
        
        var value = "abcd"
        
        let reversion = StringReversion(
            insert: [
                .init(index: value.index(0), elements: .init("z")),
                .init(index: value.index(4), elements: .init("ef")),
                .init(index: value.index(2), elements: .init("y"))
            ],
            inStringAt: \.self
        )
        
        reversion.revert(&value)
        
        XCTAssertEqual(value, "zaybefcd")
    }

    func testRevert_onInsertReversion_withValueChildKeyPath_willInsertElementsCorrectly() {

        var value = MockStruct()

        let reversion = StringReversion(
            insert: [
                .init(index: value.string.index(0), elements: .init("z")),
                .init(index: value.string.index(4), elements: .init("ef")),
                .init(index: value.string.index(2), elements: .init("y"))
            ],
            inStringAt: \MockStruct.string
        )

        reversion.revert(&value)

        XCTAssertEqual(value.string, "zaybefcd")
    }

    func testRevert_onInsertReversion_withReferenceChildKeyPath_willInsertElementsCorrectly() {

        var value = MockClass()
        
        let reversion = StringReversion(
            insert: [
                .init(index: value.string.index(0), elements: .init("z")),
                .init(index: value.string.index(4), elements: .init("ef")),
                .init(index: value.string.index(2), elements: .init("y"))
            ],
            inStringAt: \MockClass.string
        )
        
        reversion.revert(&value)
        
        XCTAssertEqual(value.string, "zaybefcd")
    }

    // MARK: Remove
    func testRevert_onRemoveReversion_withSelfKeyPath_willRemoveElementsCorrectly() {

        var value = "abcd"

        let reversion = StringReversion(
            remove: [
                value.index(0)...value.index(0),
                value.index(2)...value.index(3)
            ],
            fromStringAt: \.self
        )

        reversion.revert(&value)

        XCTAssertEqual(value, "b")
    }

    func testRevert_onRemoveReversion_withValueChildKeyPath_willRemoveElementsCorrectly() {

        var value = MockStruct()

        let reversion = StringReversion(
            remove: [
                value.string.index(0)...value.string.index(0),
                value.string.index(2)...value.string.index(3)
            ],
            fromStringAt: \MockStruct.string
        )

        reversion.revert(&value)

        XCTAssertEqual(value.string, "b")
    }

    func testRevert_onRemoveReversion_withReferenceChildKeyPath_willRemoveElementsCorrectly() {

        var value = MockClass()

        let reversion = StringReversion(
            remove: [
                value.string.index(0)...value.string.index(0),
                value.string.index(2)...value.string.index(3)
            ],
            fromStringAt: \MockClass.string
        )

        reversion.revert(&value)

        XCTAssertEqual(value.string, "b")
    }

    // MARK: Mapped insertion
    func testRevert_onInsertReversion_withMappedValueChildKeyPath_willInsertElementsCorrectly() {

        var value = MockStruct()

        let reversion = StringReversion(
            insert: [
                .init(index: value.string.index(0), elements: .init("z")),
                .init(index: value.string.index(4), elements: .init("ef")),
                .init(index: value.string.index(2), elements: .init("y"))
            ],
            inStringAt: \.self
        )
        .mapped(to: \MockStruct.string)

        reversion.revert(&value)

        XCTAssertEqual(value.string, "zaybefcd")
    }

    func testRevert_onInsertReversion_withMappedReferenceChildKeyPath_willInsertElementsCorrectly() {

        var value = MockClass()

        let reversion = StringReversion(
            insert: [
                .init(index: value.string.index(0), elements: .init("z")),
                .init(index: value.string.index(4), elements: .init("ef")),
                .init(index: value.string.index(2), elements: .init("y"))
            ],
            inStringAt: \.self
        )
        .mapped(to: \MockClass.string)

        reversion.revert(&value)

        XCTAssertEqual(value.string, "zaybefcd")
    }

    // MARK: Mapped removal
    func testRevert_onRemovalReversion_withMappedValueChildKeyPath_willRemoveElementsCorrectly() {

        var value = MockStruct()

        let reversion = StringReversion(
            remove: [
                value.string.index(0)...value.string.index(0),
                value.string.index(2)...value.string.index(3)
            ],
            fromStringAt: \.self
        )
        .mapped(to: \MockStruct.string)

        reversion.revert(&value)

        XCTAssertEqual(value.string, "b")
    }

    func testRevert_onRemoveReversion_withMappedReferenceChildKeyPath_willRemoveElementsCorrectly() {

        var value = MockClass()

        let reversion = StringReversion(
            remove: [
                value.string.index(0)...value.string.index(0),
                value.string.index(2)...value.string.index(3)
            ],
            fromStringAt: \.self
        )
        .mapped(to: \MockClass.string)

        reversion.revert(&value)

        XCTAssertEqual(value.string, "b")
    }
}
