import XCTest
import Revertable

final class RevertableTests: XCTestCase {}

// MARK: - Mocks
extension RevertableTests {
    
    private struct Mock: Versionable, Identifiable {
        
        let id: Int
        
        var int: Int = 0
        var optionalInt: Int? = 0
        
        var int64: Int64 = 0
        var optionalInt64: Int64? = 0
        
        var int32: Int32 = 0
        var optionalInt32: Int32? = 0
        
        var int16: Int16 = 0
        var optionalInt16: Int16? = 0
        
        var int8: Int8 = 0
        var optionalInt8: Int8? = 0
        
        var uint: UInt = 0
        var optionalUInt: UInt? = 0
        
        var uint64: UInt64 = 0
        var optionalUInt64: UInt64? = 0
        
        var uint32: UInt32 = 0
        var optionalUInt32: UInt32? = 0
        
        var uint16: UInt16 = 0
        var optionalUInt16: UInt16? = 0
        
        var uint8: UInt8 = 0
        var optionalUInt8: UInt8? = 0
        
        var double: Double = 0
        var optionalDouble: Double? = 0
        
        var float: Float = 0
        var optionalFloat: Float? = 0
        
        #if os(iOS)
        var float16: Float16 = 0
        var optionalFloat16: Float16? = 0
        #endif
        var date: Date = .init(timeIntervalSinceReferenceDate: 0)
        var optionalDate: Date? = .init(timeIntervalSinceReferenceDate: 0)
        
        var uuid: UUID = .init(uuidString: "00000000-0000-0000-0000-000000000000")!
        var optionalUUID: UUID? = .init(uuidString: "00000000-0000-0000-0000-000000000000")
        
        var string: String = ""
        var optionalString: String? = ""
        
        var data: Data = .init()
        var optionalData: Data? = .init()
        
        var set: Set<Int> = []
        var optionalSet: Set<Int>? = []
        
        var identifiableArray: [Mock] = []
        var optionalIdentifiableArray: [Mock]? = []
        
        var identifiableDictionary: [Int : Mock] = [:]
        var optionalIdentifiableDictionary: [Int : Mock]? = [:]
        
        var identifiableChild: MockChild = .init(id: 0)
        var optionalIdentifiableChild: MockChild? = .init(id: 0)

        
        func addReversions(into reverter: inout some Reverter<Self>) {
            
            reverter.appendReversion(at: \.int)
            reverter.appendReversion(at: \.optionalInt)
            reverter.appendReversion(at: \.int64)
            reverter.appendReversion(at: \.optionalInt64)
            reverter.appendReversion(at: \.int32)
            reverter.appendReversion(at: \.optionalInt32)
            reverter.appendReversion(at: \.int16)
            reverter.appendReversion(at: \.optionalInt16)
            reverter.appendReversion(at: \.int8)
            reverter.appendReversion(at: \.optionalInt8)
            reverter.appendReversion(at: \.uint)
            reverter.appendReversion(at: \.optionalUInt)
            reverter.appendReversion(at: \.uint64)
            reverter.appendReversion(at: \.optionalUInt64)
            reverter.appendReversion(at: \.uint32)
            reverter.appendReversion(at: \.optionalUInt32)
            reverter.appendReversion(at: \.uint16)
            reverter.appendReversion(at: \.optionalUInt16)
            reverter.appendReversion(at: \.uint8)
            reverter.appendReversion(at: \.optionalUInt8)
            reverter.appendReversion(at: \.double)
            reverter.appendReversion(at: \.optionalDouble)
            reverter.appendReversion(at: \.float)
            reverter.appendReversion(at: \.optionalFloat)
            #if os(iOS)
            reverter.appendReversion(at: \.float16)
            reverter.appendReversion(at: \.optionalFloat16)
            #endif
            reverter.appendReversion(at: \.date)
            reverter.appendReversion(at: \.optionalDate)
            reverter.appendReversion(at: \.uuid)
            reverter.appendReversion(at: \.optionalUUID)
            reverter.appendReversion(at: \.string)
            reverter.appendReversion(at: \.optionalString)
            reverter.appendReversion(at: \.data)
            reverter.appendReversion(at: \.optionalData)
            reverter.appendReversion(at: \.set)
            reverter.appendReversion(at: \.optionalSet)
            reverter.appendReversion(at: \.identifiableArray)
            reverter.appendReversion(at: \.optionalIdentifiableArray)
            reverter.appendReversion(at: \.identifiableDictionary)
            reverter.appendReversion(at: \.optionalIdentifiableDictionary)
            reverter.appendReversion(at: \.identifiableChild)
            reverter.appendReversion(at: \.optionalIdentifiableChild)
        }
        
        mutating func mutateAllNonIdentifiables() {
            
            mutateNonOptionalNonIdentifiables()
            mutateOptionalNonIdentifiables()
        }
        
        mutating func mutateNonOptionalNonIdentifiables() {
            
            int = .random(in: 1...10)
            int64 = .random(in: 1...10)
            int32 = .random(in: 1...10)
            int16 = .random(in: 1...10)
            int8 = .random(in: 1...10)
            uint = .random(in: 1...10)
            uint64 = .random(in: 1...10)
            uint32 = .random(in: 1...10)
            uint16 = .random(in: 1...10)
            uint8 = .random(in: 1...10)
            double = .random(in: 1...10)
            float = .random(in: 1...10)
            #if os(iOS)
            float16 = .random(in: 1...10)
            #endif
            date = .init(timeIntervalSinceReferenceDate: .random(in: 1...10))
            uuid = .init()
            string = UUID().uuidString
            data = UUID().uuidString.data(using: .utf8)!
            set = [.random(in: 1...10), .random(in: 1...10), .random(in: 1...10), .random(in: 1...10)]
        }
        
        mutating func mutateOptionalNonIdentifiables() {
            
            optionalInt = .random(in: 1...10)
            optionalInt64 = .random(in: 1...10)
            optionalInt32 = .random(in: 1...10)
            optionalInt16 = .random(in: 1...10)
            optionalInt8 = .random(in: 1...10)
            optionalUInt = .random(in: 1...10)
            optionalUInt64 = .random(in: 1...10)
            optionalUInt32 = .random(in: 1...10)
            optionalUInt16 = .random(in: 1...10)
            optionalUInt8 = .random(in: 1...10)
            optionalDouble = .random(in: 1...10)
            optionalFloat = .random(in: 1...10)
            #if os(iOS)
            optionalFloat16 = .random(in: 1...10)
            #endif
            optionalDate = .init(timeIntervalSinceReferenceDate: .random(in: 1...10))
            optionalUUID = .init()
            optionalString = UUID().uuidString
            optionalData = UUID().uuidString.data(using: .utf8)!
            optionalSet = [.random(in: 1...10), .random(in: 1...10), .random(in: 1...10), .random(in: 1...10)]
        }
        
        mutating func mutateAllIdentifiables() {
            
            mutateNonOptionalIdentifiables()
            mutateOptionalIdentifiables()
        }
        
        mutating func mutateNonOptionalIdentifiables() {
            
            identifiableArray = [Mock(id: 0), Mock(id: 1)]
            identifiableArray[0].mutateAllNonIdentifiables()
            identifiableArray[1].mutateAllNonIdentifiables()
            identifiableDictionary = [0 : Mock(id: 0), 1 : Mock(id: 1)]
            identifiableDictionary[0]?.mutateAllNonIdentifiables()
            identifiableDictionary[1]?.mutateAllNonIdentifiables()
            identifiableChild.int = .random(in: 1...10)
        }
        
        mutating func mutateOptionalIdentifiables() {
            
            optionalIdentifiableArray = [Mock(id: 0), Mock(id: 1)]
            optionalIdentifiableArray?[0].mutateAllNonIdentifiables()
            optionalIdentifiableArray?[1].mutateAllNonIdentifiables()
            optionalIdentifiableDictionary = [0 : Mock(id: 0), 1 : Mock(id: 1)]
            optionalIdentifiableDictionary?[0]?.mutateAllNonIdentifiables()
            optionalIdentifiableDictionary?[1]?.mutateAllNonIdentifiables()
            optionalIdentifiableChild?.int = .random(in: 1...10)
        }
        
        mutating func setOptionalsToNil() {
            
            optionalInt = nil
            optionalInt64 = nil
            optionalInt32 = nil
            optionalInt16 = nil
            optionalInt8 = nil
            optionalUInt = nil
            optionalUInt64 = nil
            optionalUInt32 = nil
            optionalUInt16 = nil
            optionalUInt8 = nil
            optionalDouble = nil
            optionalFloat = nil
            #if os(iOS)
            optionalFloat16 = nil
            #endif
            optionalDate = nil
            optionalUUID = nil
            optionalString = nil
            optionalData = nil
            optionalSet = nil
            optionalIdentifiableArray = nil
            optionalIdentifiableDictionary = nil
            optionalIdentifiableChild = nil
        }
    }

    private struct MockChild: Versionable, Identifiable {
        
        let id: Int
        var int: Int = 0
        
        func addReversions(into reverter: inout some Reverter<Self>) {
            
            reverter.appendReversion(at: \.int)
        }
    }
}

extension String {
    
    static func randomCharacter() -> String {
        String("abcdefghijklmnopqrstuvwxyz".randomElement()!)
    }
}

// MARK: - Tests
extension RevertableTests {
    
    // MARK: Single value reversions
    func testRevert_onOverwritingReversion_willRevertToOriginal() throws {
        
        struct Mock: Versionable {
            let data: Data
            
            func addReversions(into reverter: inout some Reverter<Self>) {
                reverter.appendOverwriteReversion(at: \.self)
            }
        }
        
        var value = Mock(data: Data(1...3))
        let original = value
        value = Mock(data: Data(3...7))
        
        let reversion = value.reversion(to: original)

        XCTAssertNotNil(reversion)
        XCTAssertNotEqual(value, original)
        try reversion?.revert(&value)
        XCTAssertEqual(value, original)
    }
    
    func testRevert_onNonOptional_nonIdentifiable_mutations_willRevertToOriginal() throws {
        
        var value = Mock(id: 0)
        let original = value
        
        value.mutateNonOptionalNonIdentifiables()
        
        let reversion = value.reversion(to: original)
        
        XCTAssertNotNil(reversion)
        XCTAssertNotEqual(value, original)
        try reversion?.revert(&value)
        XCTAssertEqual(value, original)
    }
    
    func testRevert_onOptional_nonIdentifiable_mutations_willRevertToOriginal() throws {
        
        var value = Mock(id: 0)
        let original = value
        
        value.mutateOptionalNonIdentifiables()
        
        let reversion = value.reversion(to: original)
        
        XCTAssertNotNil(reversion)
        XCTAssertNotEqual(value, original)
        try reversion?.revert(&value)
        XCTAssertEqual(value, original)
    }

    func testRevert_onNonOptional_identifiable_insertions_willRevertToOriginal() throws {
        
        var value = Mock(id: 0)
        value.mutateNonOptionalIdentifiables()

        let original = value
        
        value.mutateNonOptionalIdentifiables()
        
        let reversion = value.reversion(to: original)
        
        XCTAssertNotNil(reversion)
        XCTAssertNotEqual(value, original)
        try reversion?.revert(&value)
        XCTAssertEqual(value, original)
    }
    
    func testRevert_onOptional_identifiable_insertions_willRevertToOriginal() throws {
        
        var value = Mock(id: 0)
        let original = value
        
        value.mutateOptionalIdentifiables()
        
        let reversion = value.reversion(to: original)
        
        XCTAssertNotNil(reversion)
        XCTAssertNotEqual(value, original)
        try reversion?.revert(&value)
        XCTAssertEqual(value, original)
    }
    
    func testRevert_onNonOptional_identifiable_removals_willRevertToOriginal() throws {
        
        var value = Mock(id: 0)
        value.mutateNonOptionalIdentifiables()
        let original = value
        
        value = Mock(id: 0)
        
        let reversion = value.reversion(to: original)
        
        XCTAssertNotNil(reversion)
        XCTAssertNotEqual(value, original)
        try reversion?.revert(&value)
        XCTAssertEqual(value, original)
    }
    
    func testRevert_onOptional_identifiable_removals_willRevertToOriginal() throws {
        
        var value = Mock(id: 0)
        value.mutateOptionalIdentifiables()
        let original = value
        
        value = Mock(id: 0)

        let reversion = value.reversion(to: original)
        
        XCTAssertNotNil(reversion)
        XCTAssertNotEqual(value, original)
        try reversion?.revert(&value)
        XCTAssertEqual(value, original)
    }

    func testRevert_onNonOptional_identifiable_mutations_willRevertToOriginal() throws {
        
        var value = Mock(id: 0)
        value.mutateNonOptionalIdentifiables()
        let original = value
        
        value.mutateNonOptionalIdentifiables()
        
        var newElement = Mock(id: 3)
        newElement.mutateAllNonIdentifiables()
        value.identifiableArray.insert(newElement, at: 0)
        
        value.identifiableDictionary[2] = value.identifiableDictionary[0]
        value.identifiableDictionary[0] = newElement
        
        let reversion = value.reversion(to: original)
        
        XCTAssertNotNil(reversion)
        XCTAssertNotEqual(value, original)
        try reversion?.revert(&value)
        XCTAssertEqual(value, original)
    }
    
    func testRevert_onOptional_identifiable_mutations_willRevertToOriginal() throws {
        
        var value = Mock(id: 0)
        value.mutateOptionalIdentifiables()
        let original = value
        
        value.mutateNonOptionalIdentifiables()
        var newElement = Mock(id: 3)
        newElement.mutateAllNonIdentifiables()
        value.optionalIdentifiableArray?.insert(newElement, at: 0)

        let temp = value.optionalIdentifiableDictionary?[0]
        value.optionalIdentifiableDictionary?[2] = temp
        value.optionalIdentifiableDictionary?[0] = newElement

        let reversion = value.reversion(to: original)
        
        XCTAssertNotNil(reversion)
        XCTAssertNotEqual(value, original)
        try reversion?.revert(&value)
        XCTAssertEqual(value, original)
    }
    
    func testRevert_whenAllOptionalsAreNil_willRevertToOriginal() throws {
        
        var value = Mock(id: 0)
        value.mutateAllNonIdentifiables()
        value.mutateAllIdentifiables()
        let original = value
        
        value.setOptionalsToNil()

        let reversion = value.reversion(to: original)
        
        XCTAssertNotNil(reversion)
        XCTAssertNotEqual(value, original)
        try reversion?.revert(&value)
        XCTAssertEqual(value, original)
    }
    
    func testRevert_onNoMutations_willCreateNilReversion() throws {
        
        let value = Mock(id: 0)
        let original = value
        
        let reversion = value.reversion(to: original)
        
        XCTAssertNil(reversion)
    }
    
    func testRevert_onWrongObjectVersion_willThrowError() throws {
        
        var value = Mock(id: 0)
        let original = value
        
        value.mutateAllNonIdentifiables()

        let reversion = value.reversion(to: original)
        
        value.mutateAllNonIdentifiables()
        
        XCTAssertNotNil(reversion)
        XCTAssertThrowsError(try reversion?.revert(&value))
    }
    
    // MARK: Set reversions
    func testRevert_onHashableSet_withMutations_willRevertToOriginal() throws {
        
        var value = Set(1...3)
        let original = value
        value.remove(2)
        
        let reversion = value.reversion(to: original)
        
        XCTAssertNotNil(reversion)
        XCTAssertNotEqual(value, original)
        try reversion?.revert(&value)
        XCTAssertEqual(value, original)
    }
    
    func testRevert_onHashableSet_withNoMutations_willRevertToOriginal() throws {
        
        let value = Set(1...3)
        let original = value
        
        let reversion = value.reversion(to: original)
        
        XCTAssertNil(reversion)
    }
    
    func testRevert_onIdentifiableSet_withMutations_willRevertToOriginal() throws {
        
        var value = Set([Mock(id: 0), Mock(id: 1)])
        let original = value
        value.removeFirst()
        
        let reversion = value.reversion(to: original)
        
        XCTAssertNotNil(reversion)
        XCTAssertNotEqual(value, original)
        try reversion?.revert(&value)
        XCTAssertEqual(value, original)
    }
    
    func testRevert_onIdentifiableSet_withNoMutations_willRevertToOriginal() throws {
        
        let value = Set([Mock(id: 0), Mock(id: 1)])
        let original = value
        
        let reversion = value.reversion(to: original)
        
        XCTAssertNil(reversion)
    }
    
    // MARK: Array reversions
    func testRevert_onIdentifiableArray_withMutations_willRevertToOriginal() throws {
        
        var value = [Mock(id: 0), Mock(id: 1)]
        let original = value
        value.removeFirst()
        value[0].mutateAllIdentifiables()
        value[0].mutateAllNonIdentifiables()
        value.append(Mock(id: 2))
        
        let reversion = value.reversion(to: original)
        
        XCTAssertNotNil(reversion)
        XCTAssertNotEqual(value, original)
        try reversion?.revert(&value)
        XCTAssertEqual(value, original)
    }
    
    func testRevert_onIdentifiableArray_withNoMutations_willRevertToOriginal() throws {
        
        let value = [Mock(id: 0), Mock(id: 1)]
        let original = value
        
        let reversion = value.reversion(to: original)
        
        XCTAssertNil(reversion)
    }
    
    // MARK: Dictionary reversions    
    func testRevert_onIdentifiableDictionary_withMutations_willRevertToOriginal() throws {
        
        var value = ["1" : Mock(id: 1), "2" : Mock(id: 2)]
        let original = value
        value.removeValue(forKey: "1")
        value["2"]?.mutateAllIdentifiables()
        value["2"]?.mutateAllNonIdentifiables()
        value["3"] = Mock(id: 3)
        
        let reversion = value.reversion(to: original)
        
        XCTAssertNotNil(reversion)
        XCTAssertNotEqual(value, original)
        try reversion?.revert(&value)
        XCTAssertEqual(value, original)
    }
    
    func testRevert_onIdentifiableDictionary_withNoMutations_willRevertToOriginal() throws {
        
        let value = ["1" : Mock(id: 1), "2" : Mock(id: 2)]
        let original = value
        
        let reversion = value.reversion(to: original)
        
        XCTAssertNil(reversion)
    }
    
    // MARK: Data reversions
    func testRevert_onData_withMutations_willRevertToOriginal() throws {
        
        var value = Data(1...3)
        let original = value
        value.remove(at: 1)
        value.append(4)
        
        let reversion = value.reversion(to: original)
        
        XCTAssertNotNil(reversion)
        XCTAssertNotEqual(value, original)
        try reversion?.revert(&value)
        XCTAssertEqual(value, original)
    }
    
    func testRevert_onData_withNoMutations_willRevertToOriginal() throws {
        
        let value = Data(1...3)
        let original = value
        
        let reversion = value.reversion(to: original)
        
        XCTAssertNil(reversion)
    }

    // MARK: String reversions
    func testRevert_onString_withMutations_willRevertToOriginal() throws {
        
        var value = "1234"
        let original = value
        value = "1345"
        
        let reversion = value.reversion(to: original)
        
        XCTAssertNotNil(reversion)
        XCTAssertNotEqual(value, original)
        try reversion?.revert(&value)
        XCTAssertEqual(value, original)
    }
    
    func testRevert_onString_withNoMutations_willRevertToOriginal() throws {
        
        let value = "1234"
        let original = value
        
        let reversion = value.reversion(to: original)
        
        XCTAssertNil(reversion)
    }

    // MARK: - Efficiency
    func testEfficiency() {
        
        var value = Mock(id: 0)
        value.mutateAllIdentifiables()
        value.mutateAllNonIdentifiables()
        let v0 = value
        
        value.mutateAllIdentifiables()
        value.mutateAllNonIdentifiables()

        var newElement = Mock(id: 3)
        newElement.mutateAllNonIdentifiables()
        value.optionalIdentifiableArray?.insert(newElement, at: 0)

        let temp = value.optionalIdentifiableDictionary?[0]
        value.optionalIdentifiableDictionary?[2] = temp
        value.optionalIdentifiableDictionary?[0] = newElement
        
        let v1 = value
        
        value.setOptionalsToNil()
        
        let v2 = value
        
        measure(metrics: [XCTClockMetric(), XCTMemoryMetric()]) {
            var valueToRevert = value
            let reversion1 = v1.reversion(to: v0)
            let reversion2 = v2.reversion(to: v1)
        
            try! reversion2?.revert(&valueToRevert)
            try! reversion1?.revert(&valueToRevert)
        }
    }
}
