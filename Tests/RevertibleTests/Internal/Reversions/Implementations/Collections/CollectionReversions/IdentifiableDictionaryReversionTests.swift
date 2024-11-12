import Testing
@testable import Revertible

@Suite("Identifiable dictionary reversion")
struct IdentifiableDictionaryReversionTests {}

// MARK: - Tests
extension IdentifiableDictionaryReversionTests {
    
    // MARK: Insert
    @Test("Insert reversion with value self key path")
    func insertReversionOnValueSelfKeyPath() {

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

        #expect(
            value ==
            [
                0 : MockStruct(id: 5),
                1 : MockStruct(id: 1),
                2 : MockStruct(id: 2),
                3 : MockStruct(id: 3),
                4 : MockStruct(id: 4)
            ]
        )
    }

    @Test("Insert reversion with reference self key path")
    func insertReversionOnReferenceSelfKeyPath() {

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

        #expect(
            value ==
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
    @Test("Remove reversion with value self key path")
    func removeReversionOnValueSelfKeyPath() {

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

        #expect(
            value ==
            [
                0 : MockStruct(id: 0),
                3 : MockStruct(id: 3)
            ]
        )
    }

    @Test("Remove reversion with reference self key path")
    func removeReversionOnReferenceSelfKeyPath() {

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

        #expect(
            value ==
            [
                0 : MockClass(id: 0),
                3 : MockClass(id: 3)
            ]
        )
    }

    // MARK: Move
    @Test("Move reversion with value self key path")
    func moveReversionOnValueSelfKeyPath() {

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

        #expect(
            value ==
            [
                1 : MockStruct(id: 1),
                2 : MockStruct(id: 2),
                3 : MockStruct(id: 0)
            ]
        )
    }

    @Test("Move reversion with reference self key path")
    func moveReversionOnReferenceSelfKeyPath() {

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

        #expect(
            value ==
            [
                1 : MockClass(id: 1),
                2 : MockClass(id: 2),
                3 : MockClass(id: 0)
            ]
        )
    }

    // MARK: Mapped insertion
    @Test("Insert reversion with mapped value self value child key path")
    func insertReversionOnMappedValueSelfValueChildKeyPath() {

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

        #expect(
            value.identifiableValueDictionary ==
            [
                0 : MockStruct(id: 5),
                1 : MockStruct(id: 1),
                2 : MockStruct(id: 2),
                3 : MockStruct(id: 3),
                4 : MockStruct(id: 4)
            ]
        )
    }

    @Test("Insert reversion with mapped value self reference child key path")
    func insertReversionOnMappedValueSelfReferenceChildKeyPath() {

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

        #expect(
            value.identifiableReferenceDictionary ==
            [
                0 : MockClass(id: 5),
                1 : MockClass(id: 1),
                2 : MockClass(id: 2),
                3 : MockClass(id: 3),
                4 : MockClass(id: 4)
            ]
        )
    }

    @Test("Insert reversion with mapped reference self value child key path")
    func insertReversionOnMappedReferenceSelfValueChildKeyPath() {

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

        #expect(
            value.identifiableValueDictionary ==
            [
                0 : MockStruct(id: 5),
                1 : MockStruct(id: 1),
                2 : MockStruct(id: 2),
                3 : MockStruct(id: 3),
                4 : MockStruct(id: 4)
            ]
        )
    }

    @Test("Insert reversion with mapped reference self reference child key path")
    func insertReversionOnMappedReferenceSelfReferenceChildKeyPath() {

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

        #expect(
            value.identifiableReferenceDictionary ==
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
    @Test("Remove reversion with mapped value self value child key path")
    func removeReversionOnMappedValueSelfValueChildKeyPath() {

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

        #expect(
            value.identifiableValueDictionary ==
            [
                0 : MockStruct(id: 0),
                3 : MockStruct(id: 3)
            ]
        )
    }

    @Test("Remove reversion with mapped value self reference child key path")
    func removeReversionOnMappedValueSelfReferenceChildKeyPath() {

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

        #expect(
            value.identifiableReferenceDictionary ==
            [
                0 : MockClass(id: 0),
                3 : MockClass(id: 3)
            ]
        )
    }

    @Test("Remove reversion with mapped reference self value child key path")
    func removeReversionWithMappedReferenceSelfValueChildKeyPath() {

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

        #expect(
            value.identifiableValueDictionary ==
            [
                0 : MockStruct(id: 0),
                3 : MockStruct(id: 3)
            ]
        )
    }

    @Test("Remove reversion with mapped reference self reference child key path")
    func removeReversionWithMappedReferenceSelfReferenceChildKeyPath() {

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

        #expect(
            value.identifiableReferenceDictionary ==
            [
                0 : MockClass(id: 0),
                3 : MockClass(id: 3)
            ]
        )
    }

    // MARK: Mapped move
    @Test("Move reversion with mapped value self value child key path")
    func moveReversionWithMappedValueSelfValueChildKeyPath() {

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

        #expect(
            value.identifiableValueDictionary ==
            [
                1 : MockStruct(id: 1),
                2 : MockStruct(id: 2),
                3 : MockStruct(id: 0)
            ]
        )
    }

    @Test("Move reversion with mapped value self reference child key path")
    func moveReversionWithMappedValueSelfReferenceChildKeyPath() {

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

        #expect(
            value.identifiableReferenceDictionary ==
            [
                1 : MockClass(id: 1),
                2 : MockClass(id: 2),
                3 : MockClass(id: 0)
            ]
        )
    }

    @Test("Move reversion with mapped reference self value child key path")
    func moveReversionWithMappedReferenceSelfValueChildKeyPath() {

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

        #expect(
            value.identifiableValueDictionary ==
            [
                1 : MockStruct(id: 1),
                2 : MockStruct(id: 2),
                3 : MockStruct(id: 0)
            ]
        )
    }

    @Test("Move reversion with mapped reference self reference child key path")
    func moveReversionWithMappedReferenceSelfReferenceChildKeyPath() {

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

        #expect(
            value.identifiableReferenceDictionary ==
            [
                1 : MockClass(id: 1),
                2 : MockClass(id: 2),
                3 : MockClass(id: 0)
            ]
        )
    }
}
