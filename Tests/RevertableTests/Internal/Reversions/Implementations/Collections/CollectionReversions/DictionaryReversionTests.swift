import XCTest
@testable import Revertable

final class DictionaryReversionTests: XCTestCase {}

// MARK: - Tests
extension DictionaryReversionTests {
    
    // MARK: Insert
    func testRevert_onInsertReversion_withValueSelfKeyPath_willInsertElementsCorrectly() {
        
        var value = [
            0 : MockStruct(id: 0),
            1 : MockStruct(id: 1),
            2 : MockStruct(id: 2),
            3 : MockStruct(id: 3)
        ]
        
        let reversion = DictionaryReversion(
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
        
        let reversion = DictionaryReversion(
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
        
        let reversion = DictionaryReversion<[Int : MockStruct], Int, MockStruct>(
            remove: [
                0,
                3
            ]
        )
        
        reversion.revert(&value)
        
        XCTAssertEqual(
            value,
            [
                1 : MockStruct(id: 1),
                2 : MockStruct(id: 2)
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
        
        let reversion = DictionaryReversion<[Int : MockClass], Int, MockClass>(
            remove: [
                0,
                3
            ]
        )
        
        reversion.revert(&value)
        
        XCTAssertEqual(
            value,
            [
                1 : MockClass(id: 1),
                2 : MockClass(id: 2)
            ]
        )
    }
    
    // MARK: Mapped insertion
    func testRevert_onInsertReversion_withMappedValueChildKeyPath_willInsertElementsCorrectly() {

        var value = MockStruct()
        
        let reversion = DictionaryReversion(
            insert: [
                0 : "00",
                4 : "4"
            ]
        )
        .mapped(to: \MockStruct.equatableDictionary)

        reversion.revert(&value)

        XCTAssertEqual(value.equatableDictionary, [0 : "00", 1 : "1", 2 : "2", 3 : "3", 4 : "4"])
    }

    func testRevert_onInsertReversion_withMappedReferenceChildKeyPath_willInsertElementsCorrectly() {
        
        var value = MockClass()
        
        let reversion = DictionaryReversion(
            insert: [
                0 : "00",
                4 : "4"
            ]
        )
        .mapped(to: \MockClass.equatableDictionary)

        reversion.revert(&value)
        
        XCTAssertEqual(value.equatableDictionary, [0 : "00", 1 : "1", 2 : "2", 3 : "3", 4 : "4"])
    }
    
    // MARK: Mapped removal
    func testRevert_onRemovalReversion_withMappedValueChildKeyPath_willRemoveElementsCorrectly() {

        var value = MockStruct()
        
        let reversion = DictionaryReversion(
            remove: [
                0,
                3
            ]
        )
        .mapped(to: \MockStruct.equatableDictionary)

        reversion.revert(&value)

        XCTAssertEqual(value.equatableDictionary, [1 : "1", 2 : "2"])
    }

    func testRevert_onRemoveReversion_withMappedReferenceChildKeyPath_willRemoveElementsCorrectly() {
        
        var value = MockClass()
        
        let reversion = DictionaryReversion(
            remove: [
                0,
                3
            ]
        )
        .mapped(to: \MockClass.equatableDictionary)
        
        reversion.revert(&value)
        
        XCTAssertEqual(value.equatableDictionary, [1 : "1", 2 : "2"])
    }
}
