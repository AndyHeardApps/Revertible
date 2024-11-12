import Testing
@testable import Revertible

@Suite("Identifiable array reversion")
struct IdentifiableArrayReversionTests {}

// MARK: - Tests
extension IdentifiableArrayReversionTests {
    
    // MARK: Insert
    @Test("Insert reversion with value self key path")
    func insertReversionOnValueSelfKeyPath() {
        
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
        
        #expect(
            value ==
            [
                MockClass(id: 0),
                MockClass(id: 3)
            ]
        )
    }
    
    // MARK: Move
    @Test("Move reversion with value self key path")
    func moveReversionOnValueSelfKeyPath() {

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
        
        #expect(
            value ==
            [
                MockStruct(id: 1),
                MockStruct(id: 2),
                MockStruct(id: 3),
                MockStruct(id: 0)
            ]
        )
    }
    
    @Test("Move reversion with reference self key path")
    func moveReversionOnReferenceSelfKeyPath() {
        
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
        
        #expect(
            value ==
            [
                MockClass(id: 1),
                MockClass(id: 2),
                MockClass(id: 3),
                MockClass(id: 0)
            ]
        )
    }
    
    // MARK: Mapped insertion
    @Test("Insert reversion with mapped value self value child key path")
    func insertReversionOnMappedValueSelfValueChildKeyPath() {

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

        #expect(
            value.identifiableValueArray ==
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
    
    @Test("Insert reversion with mapped value self reference child key path")
    func insertReversionOnMappedValueSelfReferenceChildKeyPath() {

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

        #expect(
            value.identifiableReferenceArray ==
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

    @Test("Insert reversion with mapped reference self value child key path")
    func insertReversionOnMappedReferenceSelfValueChildKeyPath() {
        
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
        
        #expect(
            value.identifiableValueArray ==
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
    
    @Test("Insert reversion with mapped reference self reference child key path")
    func insertReversionOnMappedReferenceSelfReferenceChildKeyPath() {

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
        
        #expect(
            value.identifiableReferenceArray ==
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
    @Test("Remove reversion with mapped value self value child key path")
    func removeReversionOnMappedValueSelfValueChildKeyPath() {

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

        #expect(
            value.identifiableValueArray ==
            [
                MockStruct(id: 0),
                MockStruct(id: 3)
            ]
        )
    }

    @Test("Remove reversion with mapped value self reference child key path")
    func removeReversionOnMappedValueSelfReferenceChildKeyPath() {

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

        #expect(
            value.identifiableReferenceArray ==
            [
                MockClass(id: 0),
                MockClass(id: 3)
            ]
        )
    }

    @Test("Remove reversion with mapped reference self value child key path")
    func removeReversionWithMappedReferenceSelfValueChildKeyPath() {

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
        
        #expect(
            value.identifiableValueArray ==
            [
                MockStruct(id: 0),
                MockStruct(id: 3)
            ]
        )
    }

    @Test("Remove reversion with mapped reference self reference child key path")
    func removeReversionWithMappedReferenceSelfReferenceChildKeyPath() {

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
        
        #expect(
            value.identifiableReferenceArray ==
            [
                MockClass(id: 0),
                MockClass(id: 3)
            ]
        )
    }

    // MARK: Mapped move
    @Test("Move reversion with mapped value self value child key path")
    func moveReversionWithMappedValueSelfValueChildKeyPath() {

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

        #expect(
            value.identifiableValueArray ==
            [
                MockStruct(id: 1),
                MockStruct(id: 2),
                MockStruct(id: 3),
                MockStruct(id: 0)
            ]
        )
    }

    @Test("Move reversion with mapped value self reference child key path")
    func moveReversionWithMappedValueSelfReferenceChildKeyPath() {

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

        #expect(
            value.identifiableReferenceArray ==
            [
                MockClass(id: 1),
                MockClass(id: 2),
                MockClass(id: 3),
                MockClass(id: 0)
            ]
        )
    }

    @Test("Move reversion with mapped reference self value child key path")
    func moveReversionWithMappedReferenceSelfValueChildKeyPath() {

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

        #expect(
            value.identifiableValueArray ==
            [
                MockStruct(id: 1),
                MockStruct(id: 2),
                MockStruct(id: 3),
                MockStruct(id: 0)
            ]
        )
    }

    @Test("Move reversion with mapped reference self reference child key path")
    func moveReversionWithMappedReferenceSelfReferenceChildKeyPath() {

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

        #expect(
            value.identifiableReferenceArray ==
            [
                MockClass(id: 1),
                MockClass(id: 2),
                MockClass(id: 3),
                MockClass(id: 0)
            ]
        )
    }
}
