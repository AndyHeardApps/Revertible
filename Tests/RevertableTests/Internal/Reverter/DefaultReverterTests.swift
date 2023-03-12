import XCTest
@testable import Revertable

final class DefaultReverterTests: XCTestCase {}

// MARK: - Tests
extension DefaultReverterTests {
    
    // MARK: Int
    func testAppendReversion_forChanges_onInt_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: Int(1),
            previous: Int(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.reversions.count, 1)
    }
    
    func testAppendReversion_forNoChanges_onInt_willCreateZeroReversions() {
        
        var reverter = DefaultReverter(
            current: Int(0),
            previous: Int(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.reversions.count, 0)
    }
    
    // MARK: Int64
    func testAppendReversion_forChanges_onInt64_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: Int64(1),
            previous: Int64(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.reversions.count, 1)
    }
    
    func testAppendReversion_forNoChanges_onInt64_willCreateZeroReversions() {
        
        var reverter = DefaultReverter(
            current: Int64(0),
            previous: Int64(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.reversions.count, 0)
    }
    
    // MARK: Int32
    func testAppendReversion_forChanges_onInt32_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: Int32(1),
            previous: Int32(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.reversions.count, 1)
    }
    
    func testAppendReversion_forNoChanges_onInt32_willCreateZeroReversions() {
        
        var reverter = DefaultReverter(
            current: Int32(0),
            previous: Int32(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.reversions.count, 0)
    }
    
    // MARK: Int16
    func testAppendReversion_forChanges_onInt16_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: Int16(1),
            previous: Int16(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.reversions.count, 1)
    }
    
    func testAppendReversion_forNoChanges_onInt16_willCreateZeroReversions() {
        
        var reverter = DefaultReverter(
            current: Int16(0),
            previous: Int16(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.reversions.count, 0)
    }
    
    // MARK: Int8
    func testAppendReversion_forChanges_onInt8_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: Int8(1),
            previous: Int8(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.reversions.count, 1)
    }
    
    func testAppendReversion_forNoChanges_onInt8_willCreateZeroReversions() {
        
        var reverter = DefaultReverter(
            current: Int8(0),
            previous: Int8(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.reversions.count, 0)
    }
    
    // MARK: UInt
    func testAppendReversion_forChanges_onUInt_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: UInt(1),
            previous: UInt(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.reversions.count, 1)
    }
    
    func testAppendReversion_forNoChanges_onUInt_willCreateZeroReversions() {
        
        var reverter = DefaultReverter(
            current: UInt(0),
            previous: UInt(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.reversions.count, 0)
    }
    
    // MARK: Int64
    func testAppendReversion_forChanges_onUInt64_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: UInt64(1),
            previous: UInt64(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.reversions.count, 1)
    }
    
    func testAppendReversion_forNoChanges_onUInt64_willCreateZeroReversions() {
        
        var reverter = DefaultReverter(
            current: UInt64(0),
            previous: UInt64(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.reversions.count, 0)
    }
    
    // MARK: Int32
    func testAppendReversion_forChanges_onUInt32_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: UInt32(1),
            previous: UInt32(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.reversions.count, 1)
    }
    
    func testAppendReversion_forNoChanges_onUInt32_willCreateZeroReversions() {
        
        var reverter = DefaultReverter(
            current: UInt32(0),
            previous: UInt32(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.reversions.count, 0)
    }
    
    // MARK: Int16
    func testAppendReversion_forChanges_onUInt16_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: UInt16(1),
            previous: UInt16(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.reversions.count, 1)
    }
    
    func testAppendReversion_forNoChanges_onUInt16_willCreateZeroReversions() {
        
        var reverter = DefaultReverter(
            current: UInt16(0),
            previous: UInt16(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.reversions.count, 0)
    }
    
    // MARK: Int8
    func testAppendReversion_forChanges_onUInt8_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: UInt8(1),
            previous: UInt8(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.reversions.count, 1)
    }
    
    func testAppendReversion_forNoChanges_onUInt8_willCreateZeroReversions() {
        
        var reverter = DefaultReverter(
            current: UInt8(0),
            previous: UInt8(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.reversions.count, 0)
    }
    
    // MARK: Double
    func testAppendReversion_forChanges_onDouble_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: Double(1),
            previous: Double(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.reversions.count, 1)
    }
    
    func testAppendReversion_forNoChanges_onDouble_willCreateZeroReversions() {
        
        var reverter = DefaultReverter(
            current: Double(0),
            previous: Double(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.reversions.count, 0)
    }

    // MARK: Float
    func testAppendReversion_forChanges_onFloat_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: Float(1),
            previous: Float(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.reversions.count, 1)
    }
    
    func testAppendReversion_forNoChanges_onFloat_willCreateZeroReversions() {
        
        var reverter = DefaultReverter(
            current: Float(0),
            previous: Float(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.reversions.count, 0)
    }

    // MARK: Float16
    func testAppendReversion_forChanges_onFloat16_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: Float16(1),
            previous: Float16(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.reversions.count, 1)
    }
    
    func testAppendReversion_forNoChanges_onFloat16_willCreateZeroReversions() {
        
        var reverter = DefaultReverter(
            current: Float16(0),
            previous: Float16(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.reversions.count, 0)
    }
    
    // MARK: Date
    func testAppendReversion_forChanges_onDate_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: Date(timeIntervalSinceReferenceDate: 0),
            previous: Date(timeIntervalSinceReferenceDate: 1)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.reversions.count, 1)
    }
    
    func testAppendReversion_forNoChanges_onDate_willCreateZeroReversions() {
        
        var reverter = DefaultReverter(
            current: Date(timeIntervalSinceReferenceDate: 0),
            previous: Date(timeIntervalSinceReferenceDate: 0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.reversions.count, 0)
    }

    // MARK: String
    func testAppendReversion_forSingleInsertionChange_onString_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: "abc",
            previous: "abcde"
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.reversions.count, 1)
    }

    func testAppendReversion_forMultipleInsertionChanges_onString_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: "abc",
            previous: "a12bcd"
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.reversions.count, 1)
    }

    func testAppendReversion_forSingleRemovalChange_onString_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: "abc",
            previous: "c"
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.reversions.count, 1)
    }
    
    func testAppendReversion_forMultipleRemovalChanges_onString_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: "abc",
            previous: "b"
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.reversions.count, 1)
    }

    func testAppendReversion_forRemovalChanges_andInsertionChanges_onString_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: "abc",
            previous: "11b22"
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.reversions.count, 2)
    }

    func testAppendReversion_forNoChanges_onString_willCreateZeroReversions() {
        
        var reverter = DefaultReverter(
            current: "abc",
            previous: "abc"
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.reversions.count, 0)
    }
    
    // MARK: Data
    func testAppendReversion_forSingleInsertionChange_onData_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: Data([0, 1, 2, 3]),
            previous: Data([0, 1, 2, 3, 4])
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.reversions.count, 1)
    }

    func testAppendReversion_forMultipleInsertionChanges_onData_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: Data([0, 1, 2, 3]),
            previous: Data([0, 5, 1, 2, 3, 4, 4])
        )

        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.reversions.count, 1)
    }

    func testAppendReversion_forSingleRemovalChange_onData_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: Data([0, 1, 2, 3]),
            previous: Data([0, 1, 3])
        )

        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.reversions.count, 1)
    }

    func testAppendReversion_forMultipleRemovalChanges_onData_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: Data([0, 1, 2, 3]),
            previous: Data([0, 2])
        )

        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.reversions.count, 1)
    }

    func testAppendReversion_forRemovalChanges_andInsertionChanges_onData_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: Data([0, 1, 2, 3]),
            previous: Data([2, 5, 3, 1, 1])
        )

        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.reversions.count, 2)
    }

    func testAppendReversion_forNoChanges_onData_willCreateZeroReversions() {

        var reverter = DefaultReverter(
            current: Data([0, 1, 2, 3]),
            previous: Data([0, 1, 2, 3])
        )

        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.reversions.count, 0)
    }
    
    // MARK: Set
    func testAppendReversion_forSingleInsertionChange_onSet_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: Set([0, 1, 2, 3]),
            previous: Set([0, 1, 2, 3, 4])
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.reversions.count, 1)
    }

    func testAppendReversion_forMultipleInsertionChanges_onSet_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: Set([0, 1, 2, 3]),
            previous: Set([0, 5, 1, 2, 3, 4, 4])
        )

        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.reversions.count, 1)
    }

    func testAppendReversion_forSingleRemovalChange_onSet_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: Set([0, 1, 2, 3]),
            previous: Set([0, 1, 3])
        )

        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.reversions.count, 1)
    }

    func testAppendReversion_forMultipleRemovalChanges_onSet_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: Set([0, 1, 2, 3]),
            previous: Set([0, 2])
        )

        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.reversions.count, 1)
    }

    func testAppendReversion_forRemovalChanges_andInsertionChanges_onSet_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: Set([0, 1, 2, 3]),
            previous: Set([2, 5, 3, 1, 1])
        )

        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.reversions.count, 2)
    }

    func testAppendReversion_forNoChanges_onSet_willCreateZeroReversions() {

        var reverter = DefaultReverter(
            current: Set([0, 1, 2, 3]),
            previous: Set([0, 1, 2, 3])
        )

        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.reversions.count, 0)
    }

    // MARK: Equatable array
    func testAppendReversion_forSingleInsertionChange_onEquatableArray_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: [0, 1, 2, 3],
            previous: [0, 1, 2, 3, 4]
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.reversions.count, 1)
    }

    func testAppendReversion_forMultipleInsertionChanges_onEquatableArray_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: [0, 1, 2, 3],
            previous: [0, 5, 1, 2, 3, 4, 4]
        )

        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.reversions.count, 1)
    }

    func testAppendReversion_forSingleRemovalChange_onEquatableArray_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: [0, 1, 2, 3],
            previous: [0, 1, 3]
        )

        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.reversions.count, 1)
    }

    func testAppendReversion_forMultipleRemovalChanges_onEquatableArray_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: [0, 1, 2, 3],
            previous: [0, 2]
        )

        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.reversions.count, 1)
    }

    func testAppendReversion_forRemovalChanges_andInsertionChanges_onEquatableArray_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: [0, 1, 2, 3],
            previous: [2, 5, 3, 1, 1]
        )

        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.reversions.count, 2)
    }

    func testAppendReversion_forNoChanges_onEquatableArray_willCreateZeroReversions() {

        var reverter = DefaultReverter(
            current: [0, 1, 2, 3],
            previous: [0, 1, 2, 3]
        )

        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.reversions.count, 0)
    }
    
    // TODO: - Identifiable array
    

    // MARK: Equatable Dictionary
    func testAppendReversion_forSingleInsertionChange_onEquatableDictionary_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: [0 : "0", 1 : "1", 2 : "2", 3 : "3"],
            previous: [0 : "0", 1 : "1", 2 : "2", 3 : "3", 4 : "4"]
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.reversions.count, 1)
    }

    func testAppendReversion_forMultipleInsertionChanges_onEquatableDictioanry_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: [0 : "0", 1 : "1", 2 : "2", 3 : "3"],
            previous: [0 : "0", 1 : "1", 2 : "2", 3 : "3", 4 : "4", 5 : "5"]
        )

        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.reversions.count, 1)
    }

    func testAppendReversion_forSingleRemovalChange_onEquatableDictionary_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: [0 : "0", 1 : "1", 2 : "2", 3 : "3"],
            previous: [0 : "0", 1 : "1", 3 : "3"]
        )

        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.reversions.count, 1)
    }

    func testAppendReversion_forMultipleRemovalChanges_onEquatableDictionary_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: [0 : "0", 1 : "1", 2 : "2", 3 : "3"],
            previous: [0 : "0", 3 : "3"]
        )

        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.reversions.count, 1)
    }

    func testAppendReversion_forRemovalChanges_andInsertionChanges_onEquatableDictionary_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: [0 : "0", 1 : "1", 2 : "2", 3 : "3"],
            previous: [2 : "2", 5 : "5", 3 : "3", 1 : "1", 6 : "6"]
        )

        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.reversions.count, 2)
    }

    func testAppendReversion_forNoChanges_onEquatableDictionary_willCreateZeroReversions() {

        var reverter = DefaultReverter(
            current: [0 : "0", 1 : "1", 2 : "2", 3 : "3"],
            previous: [0 : "0", 1 : "1", 2 : "2", 3 : "3"]
        )

        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.reversions.count, 0)
    }

    // TODO: - Identifiable dictionary

}
