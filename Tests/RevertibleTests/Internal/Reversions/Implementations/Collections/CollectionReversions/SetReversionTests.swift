import Testing
@testable import Revertible

@Suite("Set reversion")
struct SetReversionTests {}

// MARK: - Tests
extension SetReversionTests {
    
    // MARK: Insert
    @Test("Insert reversion with value self key path")
    func insertReversionOnValueSelfKeyPath() {
        
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
            ]
        )
        
        reversion.revert(&value)
        
        #expect(
            value ==
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

    @Test("Insert reversion with reference self key path")
    func insertReversionOnReferenceSelfKeyPath() {

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
            ]
        )

        reversion.revert(&value)

        #expect(
            value ==
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
    @Test("Remove reversion with value self key path")
    func removeReversionOnValueSelfKeyPath() {

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
            ]
        )

        reversion.revert(&value)

        #expect(
            value ==
            [
                MockStruct(id: 0),
                MockStruct(id: 3)
            ]
        )
    }

    @Test("Remove reversion with reference self key path")
    func removeReversionOnReferenceSelfKeyPath() {

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
            ]
        )

        reversion.revert(&value)

        #expect(
            value ==
            [
                MockClass(id: 0),
                MockClass(id: 3)
            ]
        )
    }

    // MARK: Mapped insertion
    @Test("Insert reversion with mapped value child key")
    func insertReversionWithMappedValueChildKey() {

        var value = MockStruct()

        let reversion = SetReversion(
            insert: [
                10,
                12,
                11,
                13
            ]
        )
        .mapped(to: \MockStruct.equatableSet)

        reversion.revert(&value)

        #expect(value.equatableSet == [10, 0, 13, 1, 2, 3, 11, 12])
    }

    @Test("Insert reversion with mapped reference child key path")
    func insertReversionWithMappedReferenceChildKeyPath() {

        var value = MockClass()

        let reversion = SetReversion(
            insert: [
                10,
                12,
                11,
                13
            ]
        )
        .mapped(to: \MockClass.equatableSet)

        reversion.revert(&value)

        #expect(value.equatableSet == [10, 0, 13, 1, 2, 3, 11, 12])
    }

    // MARK: Mapped removal
    @Test("Removal reversion with mapped value child key path")
    func removalReversionWithMappedValueChildKeyPath() {

        var value = MockStruct()

        let reversion = SetReversion(
            remove: [
                1,
                2
            ]
        )
        .mapped(to: \MockStruct.equatableSet)

        reversion.revert(&value)

        #expect(value.equatableSet == [0, 3])
    }

    @Test("Removal reversion with mapped reference child key path")
    func removalReversionWithMappedReferenceChildKeyPath() {

        var value = MockClass()

        let reversion = SetReversion(
            remove: [
                1,
                2
            ]
        )
        .mapped(to: \MockClass.equatableSet)

        reversion.revert(&value)

        #expect(value.equatableSet == [0, 3])
    }
}
