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
                .init(index: value.index(0), element: .init("z")),
                .init(index: value.index(4), element: .init("e")),
                .init(index: value.index(2), element: .init("y"))
            ]
        )
        
        reversion.revert(&value)
        
        XCTAssertEqual(value, "zaybecd")
    }

    // MARK: Remove
    func testRevert_onRemoveReversion_withSelfKeyPath_willRemoveElementsCorrectly() {

        var value = "abcd"

        let reversion = StringReversion(
            remove: [
                value.index(0),
                value.index(2),
                value.index(3)
            ]
        )

        reversion.revert(&value)

        XCTAssertEqual(value, "b")
    }

    // MARK: Mapped insertion
    func testRevert_onInsertReversion_withMappedValueChildKeyPath_willInsertElementsCorrectly() {

        var value = MockStruct()

        let reversion = StringReversion(
            insert: [
                .init(index: value.string.index(0), element: .init("z")),
                .init(index: value.string.index(4), element: .init("e")),
                .init(index: value.string.index(2), element: .init("y"))
            ]
        )
        .mapped(to: \MockStruct.string)

        reversion.revert(&value)

        XCTAssertEqual(value.string, "zaybecd")
    }

    func testRevert_onInsertReversion_withMappedReferenceChildKeyPath_willInsertElementsCorrectly() {

        var value = MockClass()

        let reversion = StringReversion(
            insert: [
                .init(index: value.string.index(0), element: .init("z")),
                .init(index: value.string.index(4), element: .init("e")),
                .init(index: value.string.index(2), element: .init("y"))
            ]
        )
        .mapped(to: \MockClass.string)

        reversion.revert(&value)

        XCTAssertEqual(value.string, "zaybecd")
    }

    // MARK: Mapped removal
    func testRevert_onRemovalReversion_withMappedValueChildKeyPath_willRemoveElementsCorrectly() {

        var value = MockStruct()

        let reversion = StringReversion(
            remove: [
                value.string.index(0),
                value.string.index(2),
                value.string.index(3)
            ]
        )
        .mapped(to: \MockStruct.string)

        reversion.revert(&value)

        XCTAssertEqual(value.string, "b")
    }

    func testRevert_onRemoveReversion_withMappedReferenceChildKeyPath_willRemoveElementsCorrectly() {

        var value = MockClass()

        let reversion = StringReversion(
            remove: [
                value.string.index(0),
                value.string.index(2),
                value.string.index(3)
            ]
        )
        .mapped(to: \MockClass.string)

        reversion.revert(&value)

        XCTAssertEqual(value.string, "b")
    }
}
