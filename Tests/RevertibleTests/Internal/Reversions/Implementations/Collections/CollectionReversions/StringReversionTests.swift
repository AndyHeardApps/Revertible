import Testing
@testable import Revertible

@Suite("String reversion")
struct StringReversionTests {}

// MARK: - Helpers
extension String {
    
    func index(_ offset: Int) -> Index {
        
        self.index(startIndex, offsetBy: offset)
    }
}

// MARK: - Tests
extension StringReversionTests {
    
    // MARK: Insert
    @Test("Insert reversion with self key path")
    func insertReversionWithSelfKeyPath() {

        var value = "abcd"
        
        let reversion = StringReversion(
            insert: [
                .init(index: value.index(0), elements: .init("z")),
                .init(index: value.index(4), elements: .init("ef")),
                .init(index: value.index(2), elements: .init("y"))
            ]
        )
        
        reversion.revert(&value)
        
        #expect(value == "zaybefcd")
    }

    // MARK: Remove
    @Test("Remove reversion with self key path")
    func removeReversionWithSelfKeyPath() {

        var value = "abcd"

        let reversion = StringReversion(
            remove: [
                value.index(0)...value.index(0),
                value.index(2)...value.index(3),
            ]
        )

        reversion.revert(&value)

        #expect(value == "b")
    }

    // MARK: Mapped insertion
    @Test("Insert reversion with mapped value child key path")
    func insertReversionWithMappedValueChildKeyPath() {

        var value = MockStruct()

        let reversion = StringReversion(
            insert: [
                .init(index: value.string.index(0), elements: .init("z")),
                .init(index: value.string.index(4), elements: .init("ef")),
                .init(index: value.string.index(2), elements: .init("y"))
            ]
        )
        .mapped(to: \MockStruct.string)

        reversion.revert(&value)

        #expect(value.string == "zaybefcd")
    }

    @Test("Insert reversion with mapped reference child key path")
    func insertReversionWithMappedReferenceChildKeyPath() {

        var value = MockClass()

        let reversion = StringReversion(
            insert: [
                .init(index: value.string.index(0), elements: .init("z")),
                .init(index: value.string.index(4), elements: .init("ef")),
                .init(index: value.string.index(2), elements: .init("y"))
            ]
        )
        .mapped(to: \MockClass.string)

        reversion.revert(&value)

        #expect(value.string == "zaybefcd")
    }

    // MARK: Mapped removal
    @Test("Remove reversion with mapped value child key path")
    func removeReversionWithMappedValueChildKeyPath() {

        var value = MockStruct()

        let reversion = StringReversion(
            remove: [
                value.string.index(0)...value.string.index(0),
                value.string.index(2)...value.string.index(3),
            ]
        )
        .mapped(to: \MockStruct.string)

        reversion.revert(&value)

        #expect(value.string == "b")
    }

    @Test("Remove reversion with mapped reference child key path")
    func removeReversionWithMappedReferenceChildKeyPath() {

        var value = MockClass()

        let reversion = StringReversion(
            remove: [
                value.string.index(0)...value.string.index(0),
                value.string.index(2)...value.string.index(3),
            ]
        )
        .mapped(to: \MockClass.string)

        reversion.revert(&value)

        #expect(value.string == "b")
    }
}
