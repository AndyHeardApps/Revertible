import XCTest
@testable import Revertable

final class DefaultReverterTests: XCTestCase {}

// MARK: - Tests
extension DefaultReverterTests {
    
    // MARK: - Int
    func testAppendReversion_forChanges_onInt_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: Int(1),
            previous: Int(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 1)
    }
    
    func testAppendReversion_forNoChanges_onInt_willCreateZeroReversions() {
        
        var reverter = DefaultReverter(
            current: Int(0),
            previous: Int(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 0)
    }
    
    // MARK: - Optional Int
    func testAppendReversion_forChanges_onOptionalInt_willCreateCorrectReversions() {
        
        let values: [(Int?, Int?)] = [
            (0, 1),
            (nil, 1),
            (0, nil)
        ]
        
        for (current, previous) in values {
            var reverter = DefaultReverter(
                current: current,
                previous: previous
            )
            
            reverter.appendReversion(at: \.self)
            
            XCTAssertEqual(reverter.count, 1)
        }
    }
    
    func testAppendReversion_forNoChanges_onOptionalInt_willCreateZeroReversions() {
        
        let values: [(Int?, Int?)] = [
            (0, 0),
            (nil, nil)
        ]
        
        for (current, previous) in values {
            var reverter = DefaultReverter(
                current: current,
                previous: previous
            )
            
            reverter.appendReversion(at: \.self)
            
            XCTAssertEqual(reverter.count, 0)
        }
    }
    
    // MARK: - Int64
    func testAppendReversion_forChanges_onInt64_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: Int64(1),
            previous: Int64(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 1)
    }
    
    func testAppendReversion_forNoChanges_onInt64_willCreateZeroReversions() {
        
        var reverter = DefaultReverter(
            current: Int64(0),
            previous: Int64(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 0)
    }
    
    // MARK: - Optional Int64
    func testAppendReversion_forChanges_onOptionalInt64_willCreateCorrectReversions() {
        
        let values: [(Int64?, Int64?)] = [
            (0, 1),
            (nil, 1),
            (0, nil)
        ]
        
        for (current, previous) in values {
            var reverter = DefaultReverter(
                current: current,
                previous: previous
            )
            
            reverter.appendReversion(at: \.self)
            
            XCTAssertEqual(reverter.count, 1)
        }
    }
    
    func testAppendReversion_forNoChanges_onOptionalInt64_willCreateZeroReversions() {
        
        let values: [(Int64?, Int64?)] = [
            (0, 0),
            (nil, nil)
        ]
        
        for (current, previous) in values {
            var reverter = DefaultReverter(
                current: current,
                previous: previous
            )
            
            reverter.appendReversion(at: \.self)
            
            XCTAssertEqual(reverter.count, 0)
        }
    }

    // MARK: - Int32
    func testAppendReversion_forChanges_onInt32_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: Int32(1),
            previous: Int32(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 1)
    }
    
    func testAppendReversion_forNoChanges_onInt32_willCreateZeroReversions() {
        
        var reverter = DefaultReverter(
            current: Int32(0),
            previous: Int32(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 0)
    }
    
    // MARK: - Optional Int32
    func testAppendReversion_forChanges_onOptionalInt32_willCreateCorrectReversions() {
        
        let values: [(Int32?, Int32?)] = [
            (0, 1),
            (nil, 1),
            (0, nil)
        ]
        
        for (current, previous) in values {
            var reverter = DefaultReverter(
                current: current,
                previous: previous
            )
            
            reverter.appendReversion(at: \.self)
            
            XCTAssertEqual(reverter.count, 1)
        }
    }
    
    func testAppendReversion_forNoChanges_onOptionalInt32_willCreateZeroReversions() {
        
        let values: [(Int32?, Int32?)] = [
            (0, 0),
            (nil, nil)
        ]
        
        for (current, previous) in values {
            var reverter = DefaultReverter(
                current: current,
                previous: previous
            )
            
            reverter.appendReversion(at: \.self)
            
            XCTAssertEqual(reverter.count, 0)
        }
    }

    // MARK: - Int16
    func testAppendReversion_forChanges_onInt16_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: Int16(1),
            previous: Int16(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 1)
    }
    
    func testAppendReversion_forNoChanges_onInt16_willCreateZeroReversions() {
        
        var reverter = DefaultReverter(
            current: Int16(0),
            previous: Int16(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 0)
    }
    
    // MARK: - Optional Int16
    func testAppendReversion_forChanges_onOptionalInt16_willCreateCorrectReversions() {
        
        let values: [(Int16?, Int16?)] = [
            (0, 1),
            (nil, 1),
            (0, nil)
        ]
        
        for (current, previous) in values {
            var reverter = DefaultReverter(
                current: current,
                previous: previous
            )
            
            reverter.appendReversion(at: \.self)
            
            XCTAssertEqual(reverter.count, 1)
        }
    }
    
    func testAppendReversion_forNoChanges_onOptionalInt16_willCreateZeroReversions() {
        
        let values: [(Int16?, Int16?)] = [
            (0, 0),
            (nil, nil)
        ]
        
        for (current, previous) in values {
            var reverter = DefaultReverter(
                current: current,
                previous: previous
            )
            
            reverter.appendReversion(at: \.self)
            
            XCTAssertEqual(reverter.count, 0)
        }
    }
    
    // MARK: - Int8
    func testAppendReversion_forChanges_onInt8_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: Int8(1),
            previous: Int8(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 1)
    }
    
    func testAppendReversion_forNoChanges_onInt8_willCreateZeroReversions() {
        
        var reverter = DefaultReverter(
            current: Int8(0),
            previous: Int8(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 0)
    }
    
    // MARK: - Optional Int8
    func testAppendReversion_forChanges_onOptionalInt8_willCreateCorrectReversions() {
        
        let values: [(Int8?, Int8?)] = [
            (0, 1),
            (nil, 1),
            (0, nil)
        ]
        
        for (current, previous) in values {
            var reverter = DefaultReverter(
                current: current,
                previous: previous
            )
            
            reverter.appendReversion(at: \.self)
            
            XCTAssertEqual(reverter.count, 1)
        }
    }
    
    func testAppendReversion_forNoChanges_onOptionalInt8_willCreateZeroReversions() {
        
        let values: [(Int8?, Int8?)] = [
            (0, 0),
            (nil, nil)
        ]
        
        for (current, previous) in values {
            var reverter = DefaultReverter(
                current: current,
                previous: previous
            )
            
            reverter.appendReversion(at: \.self)
            
            XCTAssertEqual(reverter.count, 0)
        }
    }
    
    // MARK: - UInt
    func testAppendReversion_forChanges_onUInt_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: UInt(1),
            previous: UInt(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 1)
    }
    
    func testAppendReversion_forNoChanges_onUInt_willCreateZeroReversions() {
        
        var reverter = DefaultReverter(
            current: UInt(0),
            previous: UInt(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 0)
    }
    
    // MARK: - Optional UInt
    func testAppendReversion_forChanges_onOptionalUInt_willCreateCorrectReversions() {
        
        let values: [(UInt?, UInt?)] = [
            (0, 1),
            (nil, 1),
            (0, nil)
        ]
        
        for (current, previous) in values {
            var reverter = DefaultReverter(
                current: current,
                previous: previous
            )
            
            reverter.appendReversion(at: \.self)
            
            XCTAssertEqual(reverter.count, 1)
        }
    }
    
    func testAppendReversion_forNoChanges_onOptionalUInt_willCreateZeroReversions() {
        
        let values: [(UInt?, UInt?)] = [
            (0, 0),
            (nil, nil)
        ]
        
        for (current, previous) in values {
            var reverter = DefaultReverter(
                current: current,
                previous: previous
            )
            
            reverter.appendReversion(at: \.self)
            
            XCTAssertEqual(reverter.count, 0)
        }
    }
    
    // MARK: - UInt64
    func testAppendReversion_forChanges_onUInt64_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: UInt64(1),
            previous: UInt64(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 1)
    }
    
    func testAppendReversion_forNoChanges_onUInt64_willCreateZeroReversions() {
        
        var reverter = DefaultReverter(
            current: UInt64(0),
            previous: UInt64(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 0)
    }
    
    // MARK: - Optional UInt64
    func testAppendReversion_forChanges_onOptionalUInt64_willCreateCorrectReversions() {
        
        let values: [(UInt64?, UInt64?)] = [
            (0, 1),
            (nil, 1),
            (0, nil)
        ]
        
        for (current, previous) in values {
            var reverter = DefaultReverter(
                current: current,
                previous: previous
            )
            
            reverter.appendReversion(at: \.self)
            
            XCTAssertEqual(reverter.count, 1)
        }
    }
    
    func testAppendReversion_forNoChanges_onOptionalUInt64_willCreateZeroReversions() {
        
        let values: [(UInt64?, UInt64?)] = [
            (0, 0),
            (nil, nil)
        ]
        
        for (current, previous) in values {
            var reverter = DefaultReverter(
                current: current,
                previous: previous
            )
            
            reverter.appendReversion(at: \.self)
            
            XCTAssertEqual(reverter.count, 0)
        }
    }
    
    // MARK: - UInt32
    func testAppendReversion_forChanges_onUInt32_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: UInt32(1),
            previous: UInt32(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 1)
    }
    
    func testAppendReversion_forNoChanges_onUInt32_willCreateZeroReversions() {
        
        var reverter = DefaultReverter(
            current: UInt32(0),
            previous: UInt32(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 0)
    }
    
    // MARK: - Optional UInt32
    func testAppendReversion_forChanges_onOptionalUInt32_willCreateCorrectReversions() {
        
        let values: [(UInt32?, UInt32?)] = [
            (0, 1),
            (nil, 1),
            (0, nil)
        ]
        
        for (current, previous) in values {
            var reverter = DefaultReverter(
                current: current,
                previous: previous
            )
            
            reverter.appendReversion(at: \.self)
            
            XCTAssertEqual(reverter.count, 1)
        }
    }
    
    func testAppendReversion_forNoChanges_onOptionalUInt32_willCreateZeroReversions() {
        
        let values: [(UInt32?, UInt32?)] = [
            (0, 0),
            (nil, nil)
        ]
        
        for (current, previous) in values {
            var reverter = DefaultReverter(
                current: current,
                previous: previous
            )
            
            reverter.appendReversion(at: \.self)
            
            XCTAssertEqual(reverter.count, 0)
        }
    }
    
    // MARK: - UInt16
    func testAppendReversion_forChanges_onUInt16_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: UInt16(1),
            previous: UInt16(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 1)
    }
    
    func testAppendReversion_forNoChanges_onUInt16_willCreateZeroReversions() {
        
        var reverter = DefaultReverter(
            current: UInt16(0),
            previous: UInt16(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 0)
    }
    
    // MARK: - Optional UInt16
    func testAppendReversion_forChanges_onOptionalUInt16_willCreateCorrectReversions() {
        
        let values: [(UInt16?, UInt16?)] = [
            (0, 1),
            (nil, 1),
            (0, nil)
        ]
        
        for (current, previous) in values {
            var reverter = DefaultReverter(
                current: current,
                previous: previous
            )
            
            reverter.appendReversion(at: \.self)
            
            XCTAssertEqual(reverter.count, 1)
        }
    }
    
    func testAppendReversion_forNoChanges_onOptionalUInt16_willCreateZeroReversions() {
        
        let values: [(UInt16?, UInt16?)] = [
            (0, 0),
            (nil, nil)
        ]
        
        for (current, previous) in values {
            var reverter = DefaultReverter(
                current: current,
                previous: previous
            )
            
            reverter.appendReversion(at: \.self)
            
            XCTAssertEqual(reverter.count, 0)
        }
    }

    
    // MARK: - UInt8
    func testAppendReversion_forChanges_onUInt8_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: UInt8(1),
            previous: UInt8(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 1)
    }
    
    func testAppendReversion_forNoChanges_onUInt8_willCreateZeroReversions() {
        
        var reverter = DefaultReverter(
            current: UInt8(0),
            previous: UInt8(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 0)
    }
    
    // MARK: - Optional UInt8
    func testAppendReversion_forChanges_onOptionalUInt8_willCreateCorrectReversions() {
        
        let values: [(UInt8?, UInt8?)] = [
            (0, 1),
            (nil, 1),
            (0, nil)
        ]
        
        for (current, previous) in values {
            var reverter = DefaultReverter(
                current: current,
                previous: previous
            )
            
            reverter.appendReversion(at: \.self)
            
            XCTAssertEqual(reverter.count, 1)
        }
    }
    
    func testAppendReversion_forNoChanges_onOptionalUInt8_willCreateZeroReversions() {
        
        let values: [(UInt8?, UInt8?)] = [
            (0, 0),
            (nil, nil)
        ]
        
        for (current, previous) in values {
            var reverter = DefaultReverter(
                current: current,
                previous: previous
            )
            
            reverter.appendReversion(at: \.self)
            
            XCTAssertEqual(reverter.count, 0)
        }
    }
    
    // MARK: - Double
    func testAppendReversion_forChanges_onDouble_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: Double(1),
            previous: Double(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 1)
    }
    
    func testAppendReversion_forNoChanges_onDouble_willCreateZeroReversions() {
        
        var reverter = DefaultReverter(
            current: Double(0),
            previous: Double(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 0)
    }
    
    // MARK: - Optional Double
    func testAppendReversion_forChanges_onOptionalDouble_willCreateCorrectReversions() {
        
        let values: [(Double?, Double?)] = [
            (0, 1),
            (nil, 1),
            (0, nil)
        ]
        
        for (current, previous) in values {
            var reverter = DefaultReverter(
                current: current,
                previous: previous
            )
            
            reverter.appendReversion(at: \.self)
            
            XCTAssertEqual(reverter.count, 1)
        }
    }
    
    func testAppendReversion_forNoChanges_onOptionalDouble_willCreateZeroReversions() {
        
        let values: [(Double?, Double?)] = [
            (0, 0),
            (nil, nil)
        ]
        
        for (current, previous) in values {
            var reverter = DefaultReverter(
                current: current,
                previous: previous
            )
            
            reverter.appendReversion(at: \.self)
            
            XCTAssertEqual(reverter.count, 0)
        }
    }

    // MARK: - Float
    func testAppendReversion_forChanges_onFloat_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: Float(1),
            previous: Float(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 1)
    }
    
    func testAppendReversion_forNoChanges_onFloat_willCreateZeroReversions() {
        
        var reverter = DefaultReverter(
            current: Float(0),
            previous: Float(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 0)
    }
    
    // MARK: - Optional Float
    func testAppendReversion_forChanges_onOptionalFloat_willCreateCorrectReversions() {
        
        let values: [(Float?, Float?)] = [
            (0, 1),
            (nil, 1),
            (0, nil)
        ]
        
        for (current, previous) in values {
            var reverter = DefaultReverter(
                current: current,
                previous: previous
            )
            
            reverter.appendReversion(at: \.self)
            
            XCTAssertEqual(reverter.count, 1)
        }
    }
    
    func testAppendReversion_forNoChanges_onOptionalFloat_willCreateZeroReversions() {
        
        let values: [(Float?, Float?)] = [
            (0, 0),
            (nil, nil)
        ]
        
        for (current, previous) in values {
            var reverter = DefaultReverter(
                current: current,
                previous: previous
            )
            
            reverter.appendReversion(at: \.self)
            
            XCTAssertEqual(reverter.count, 0)
        }
    }

    // MARK: - Float16
    func testAppendReversion_forChanges_onFloat16_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: Float16(1),
            previous: Float16(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 1)
    }
    
    func testAppendReversion_forNoChanges_onFloat16_willCreateZeroReversions() {
        
        var reverter = DefaultReverter(
            current: Float16(0),
            previous: Float16(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 0)
    }
    
    // MARK: - Optional Float16
    func testAppendReversion_forChanges_onOptionalFloat16_willCreateCorrectReversions() {
        
        let values: [(Float16?, Float16?)] = [
            (0, 1),
            (nil, 1),
            (0, nil)
        ]
        
        for (current, previous) in values {
            var reverter = DefaultReverter(
                current: current,
                previous: previous
            )
            
            reverter.appendReversion(at: \.self)
            
            XCTAssertEqual(reverter.count, 1)
        }
    }
    
    func testAppendReversion_forNoChanges_onOptionalFloat16_willCreateZeroReversions() {
        
        let values: [(Float?, Float?)] = [
            (0, 0),
            (nil, nil)
        ]
        
        for (current, previous) in values {
            var reverter = DefaultReverter(
                current: current,
                previous: previous
            )
            
            reverter.appendReversion(at: \.self)
            
            XCTAssertEqual(reverter.count, 0)
        }
    }
    
    // MARK: - Date
    func testAppendReversion_forChanges_onDate_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: Date(timeIntervalSinceReferenceDate: 0),
            previous: Date(timeIntervalSinceReferenceDate: 1)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 1)
    }
    
    func testAppendReversion_forNoChanges_onDate_willCreateZeroReversions() {
        
        var reverter = DefaultReverter(
            current: Date(timeIntervalSinceReferenceDate: 0),
            previous: Date(timeIntervalSinceReferenceDate: 0)
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 0)
    }
    
    // MARK: - Optional Date
    func testAppendReversion_forChanges_onOptionalDate_willCreateCorrectReversions() {
        
        let values: [(Date?, Date?)] = [
            (Date(timeIntervalSinceReferenceDate: 0), Date(timeIntervalSinceReferenceDate: 1)),
            (nil, Date(timeIntervalSinceReferenceDate: 1)),
            (Date(timeIntervalSinceReferenceDate: 0), nil)
        ]
        
        for (current, previous) in values {
            var reverter = DefaultReverter(
                current: current,
                previous: previous
            )
            
            reverter.appendReversion(at: \.self)
            
            XCTAssertEqual(reverter.count, 1)
        }
    }
    
    func testAppendReversion_forNoChanges_onOptionalDate_willCreateZeroReversions() {
        
        let values: [(Date?, Date?)] = [
            (Date(timeIntervalSinceReferenceDate: 0), Date(timeIntervalSinceReferenceDate: 0)),
            (nil, nil)
        ]
        
        for (current, previous) in values {
            var reverter = DefaultReverter(
                current: current,
                previous: previous
            )
            
            reverter.appendReversion(at: \.self)
            
            XCTAssertEqual(reverter.count, 0)
        }
    }
    
    // MARK: - UUID
    func testAppendReversion_forChanges_onUUID_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: UUID(),
            previous: UUID()
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 1)
    }
    
    func testAppendReversion_forNoChanges_onUUID_willCreateZeroReversions() {
        
        let value = UUID()
        var reverter = DefaultReverter(
            current: value,
            previous: value
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 0)
    }
    
    // MARK: - Optional Date
    func testAppendReversion_forChanges_onOptionalUUID_willCreateCorrectReversions() {
        
        let values: [(UUID?, UUID?)] = [
            (UUID(), UUID()),
            (nil, UUID()),
            (UUID(), nil)
        ]
        
        for (current, previous) in values {
            var reverter = DefaultReverter(
                current: current,
                previous: previous
            )
            
            reverter.appendReversion(at: \.self)
            
            XCTAssertEqual(reverter.count, 1)
        }
    }
    
    func testAppendReversion_forNoChanges_onOptionalUUID_willCreateZeroReversions() {
        
        let value = UUID()
        let values: [(UUID?, UUID?)] = [
            (value, value),
            (nil, nil)
        ]
        
        for (current, previous) in values {
            var reverter = DefaultReverter(
                current: current,
                previous: previous
            )
            
            reverter.appendReversion(at: \.self)
            
            XCTAssertEqual(reverter.count, 0)
        }
    }

    // MARK: - String
    func testAppendReversion_forSingleInsertionChange_onString_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: "abc",
            previous: "abcde"
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 1)
    }

    func testAppendReversion_forMultipleInsertionChanges_onString_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: "abc",
            previous: "a12bcd"
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 1)
    }

    func testAppendReversion_forSingleRemovalChange_onString_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: "abc",
            previous: "c"
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 1)
    }
    
    func testAppendReversion_forMultipleRemovalChanges_onString_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: "abc",
            previous: "b"
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 1)
    }

    func testAppendReversion_forRemovalChanges_andInsertionChanges_onString_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: "abc",
            previous: "11b22"
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 2)
    }

    func testAppendReversion_forNoChanges_onString_willCreateZeroReversions() {
        
        var reverter = DefaultReverter(
            current: "abc",
            previous: "abc"
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 0)
    }

    // MARK: - Optional String
    func testAppendReversion_forFullInsertionChange_onOptionalString_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: nil,
            previous: "abc"
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 1)
    }

    func testAppendReversion_forFullRemovalChange_onOptionalString_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: "abc",
            previous: nil
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 1)
    }

    func testAppendReversion_forNoChanges_onOptionalString_willCreateZeroReversions() {
        
        let values: [(String?, String?)] = [
            ("abc", "abc"),
            (nil, nil)
        ]

        for (current, previous) in values {
            var reverter = DefaultReverter(
                current: current,
                previous: previous
            )
            
            reverter.appendReversion(at: \.self)
            
            XCTAssertEqual(reverter.count, 0)
        }
    }

    // MARK: - Data
    func testAppendReversion_forSingleInsertionChange_onData_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: Data([0, 1, 2, 3]),
            previous: Data([0, 1, 2, 3, 4])
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 1)
    }

    func testAppendReversion_forMultipleInsertionChanges_onData_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: Data([0, 1, 2, 3]),
            previous: Data([0, 5, 1, 2, 3, 4, 4])
        )

        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.count, 1)
    }

    func testAppendReversion_forSingleRemovalChange_onData_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: Data([0, 1, 2, 3]),
            previous: Data([0, 1, 3])
        )

        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.count, 1)
    }

    func testAppendReversion_forMultipleRemovalChanges_onData_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: Data([0, 1, 2, 3]),
            previous: Data([0, 2])
        )

        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.count, 1)
    }

    func testAppendReversion_forRemovalChanges_andInsertionChanges_onData_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: Data([0, 1, 2, 3]),
            previous: Data([2, 5, 3, 1, 1])
        )

        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.count, 2)
    }

    func testAppendReversion_forNoChanges_onData_willCreateZeroReversions() {

        var reverter = DefaultReverter(
            current: Data([0, 1, 2, 3]),
            previous: Data([0, 1, 2, 3])
        )

        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.count, 0)
    }
    
    // MARK: - Optional Data
    func testAppendReversion_forFullInsertionChange_onOptionalData_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: nil,
            previous: Data([0, 1, 2, 3])
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 1)
    }

    func testAppendReversion_forFullRemovalChange_onOptionalData_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: Data([0, 1, 2, 3]),
            previous: nil
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 1)
    }

    func testAppendReversion_forNoChanges_onOptionalData_willCreateZeroReversions() {
        
        let values: [(Data?, Data?)] = [
            (Data([0, 1, 2, 3]), Data([0, 1, 2, 3])),
            (nil, nil)
        ]

        for (current, previous) in values {
            var reverter = DefaultReverter(
                current: current,
                previous: previous
            )
            
            reverter.appendReversion(at: \.self)
            
            XCTAssertEqual(reverter.count, 0)
        }
    }
    
    // MARK: - Set
    func testAppendReversion_forSingleInsertionChange_onSet_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: Set([0, 1, 2, 3]),
            previous: Set([0, 1, 2, 3, 4])
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 1)
    }

    func testAppendReversion_forMultipleInsertionChanges_onSet_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: Set([0, 1, 2, 3]),
            previous: Set([0, 5, 1, 2, 3, 4, 4])
        )

        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.count, 1)
    }

    func testAppendReversion_forSingleRemovalChange_onSet_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: Set([0, 1, 2, 3]),
            previous: Set([0, 1, 3])
        )

        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.count, 1)
    }

    func testAppendReversion_forMultipleRemovalChanges_onSet_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: Set([0, 1, 2, 3]),
            previous: Set([0, 2])
        )

        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.count, 1)
    }

    func testAppendReversion_forRemovalChanges_andInsertionChanges_onSet_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: Set([0, 1, 2, 3]),
            previous: Set([2, 5, 3, 1, 1])
        )

        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.count, 2)
    }

    func testAppendReversion_forNoChanges_onSet_willCreateZeroReversions() {

        var reverter = DefaultReverter(
            current: Set([0, 1, 2, 3]),
            previous: Set([0, 1, 2, 3])
        )

        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.count, 0)
    }
    
    // MARK: - Optional Set
    func testAppendReversion_forFullInsertionChange_onOptionalSet_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: nil,
            previous: Set([0, 1, 2, 3])
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 1)
    }

    func testAppendReversion_forFullRemovalChange_onOptionalSet_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: Set([0, 1, 2, 3]),
            previous: nil
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 1)
    }

    func testAppendReversion_forNoChanges_onOptionalSet_willCreateZeroReversions() {
        
        let values: [(Set<Int>?, Set<Int>?)] = [
            (Set([0, 1, 2, 3]), Set([0, 1, 2, 3])),
            (nil, nil)
        ]

        for (current, previous) in values {
            var reverter = DefaultReverter(
                current: current,
                previous: previous
            )
            
            reverter.appendReversion(at: \.self)
            
            XCTAssertEqual(reverter.count, 0)
        }
    }

    // MARK: - Equatable array
    func testAppendReversion_forSingleInsertionChange_onEquatableArray_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: [0, 1, 2, 3],
            previous: [0, 1, 2, 3, 4]
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 1)
    }

    func testAppendReversion_forMultipleInsertionChanges_onEquatableArray_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: [0, 1, 2, 3],
            previous: [0, 5, 1, 2, 3, 4, 4]
        )

        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.count, 1)
    }

    func testAppendReversion_forSingleRemovalChange_onEquatableArray_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: [0, 1, 2, 3],
            previous: [0, 1, 3]
        )

        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.count, 1)
    }

    func testAppendReversion_forMultipleRemovalChanges_onEquatableArray_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: [0, 1, 2, 3],
            previous: [0, 2]
        )

        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.count, 1)
    }

    func testAppendReversion_forRemovalChanges_andInsertionChanges_onEquatableArray_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: [0, 1, 2, 3],
            previous: [2, 5, 3, 1, 1]
        )

        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.count, 2)
    }

    func testAppendReversion_forNoChanges_onEquatableArray_willCreateZeroReversions() {

        var reverter = DefaultReverter(
            current: [0, 1, 2, 3],
            previous: [0, 1, 2, 3]
        )

        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.count, 0)
    }
    
    // MARK: - Optional Array
    func testAppendReversion_forFullInsertionChange_onOptionalArray_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: nil,
            previous: [0, 1, 2, 3]
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 1)
    }

    func testAppendReversion_forFullRemovalChange_onOptionalArray_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: [0, 1, 2, 3],
            previous: nil
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 1)
    }

    func testAppendReversion_forNoChanges_onOptionalArray_willCreateZeroReversions() {
        
        let values: [([Int]?, [Int]?)] = [
            ([0, 1, 2, 3], [0, 1, 2, 3]),
            (nil, nil)
        ]

        for (current, previous) in values {
            var reverter = DefaultReverter(
                current: current,
                previous: previous
            )
            
            reverter.appendReversion(at: \.self)
            
            XCTAssertEqual(reverter.count, 0)
        }
    }
    
    // MARK: - Identifiable array
    func testAppendReversion_forSingleInsertionChange_onIdentifiableArray_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: [
                MockStruct(id: 0),
                MockStruct(id: 1),
                MockStruct(id: 2)
            ],
            previous: [
                MockStruct(id: 0),
                MockStruct(id: 1),
                MockStruct(id: 2),
                MockStruct(id: 3)
            ]
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 1)
    }

    func testAppendReversion_forMultipleInsertionChanges_onIdentifiableArray_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: [
                MockStruct(id: 0),
                MockStruct(id: 1),
                MockStruct(id: 2)
            ],
            previous: [
                MockStruct(id: 0),
                MockStruct(id: 1),
                MockStruct(id: 2),
                MockStruct(id: 3),
                MockStruct(id: 4)
            ]
        )
        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.count, 1)
    }

    func testAppendReversion_forSingleRemovalChange_onIdentifiableArray_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: [
                MockStruct(id: 0),
                MockStruct(id: 1),
                MockStruct(id: 2)
            ],
            previous: [
                MockStruct(id: 0),
                MockStruct(id: 1)
            ]
        )
        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.count, 1)
    }

    func testAppendReversion_forMultipleRemovalChanges_onIdentifiableArray_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: [
                MockStruct(id: 0),
                MockStruct(id: 1),
                MockStruct(id: 2)
            ],
            previous: [
                MockStruct(id: 1)
            ]
        )

        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.count, 1)
    }
    
    func testAppendReversion_forSingleMoveChange_onIdentifiableArray_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: [
                MockStruct(id: 0),
                MockStruct(id: 1),
                MockStruct(id: 2)
            ],
            previous: [
                MockStruct(id: 0),
                MockStruct(id: 2),
                MockStruct(id: 1)
            ]
        )
        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.count, 1)
    }

    func testAppendReversion_forMultipleMoveChanges_onIdentifiableArray_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: [
                MockStruct(id: 0),
                MockStruct(id: 1),
                MockStruct(id: 2),
                MockStruct(id: 3)
            ],
            previous: [
                MockStruct(id: 1),
                MockStruct(id: 0),
                MockStruct(id: 3),
                MockStruct(id: 2)
            ]
        )

        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.count, 2)
    }

    func testAppendReversion_forRemovalChanges_andInsertionChanges_andMoveChanges_onIdentifiableArray_willCreateCorrectReversions() {

            var reverter = DefaultReverter(
                current: [
                    MockStruct(id: 0),
                    MockStruct(id: 1),
                    MockStruct(id: 2),
                    MockStruct(id: 3)
                ],
                previous: [
                    MockStruct(id: 3),
                    MockStruct(id: 2),
                    MockStruct(id: 4)
                ]
            )
        
        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.count, 3)
    }

    func testAppendReversion_forNoChanges_onIdentifiableArray_willCreateZeroReversions() {

        var reverter = DefaultReverter(
            current: [
                MockStruct(id: 0),
                MockStruct(id: 1),
                MockStruct(id: 2)
            ],
            previous: [
                MockStruct(id: 0),
                MockStruct(id: 1),
                MockStruct(id: 2)
            ]
        )

        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.count, 0)
    }
    
    func testAppendReversion_forChildChanges_onIdentifiableArray_willCreateZeroReversions() {

        var reverter = DefaultReverter(
            current: [
                MockStruct(id: 0),
                MockStruct(id: 1, int: 1),
                MockStruct(id: 2)
            ],
            previous: [
                MockStruct(id: 0),
                MockStruct(id: 1, int: 2),
                MockStruct(id: 2)
            ]
        )

        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.count, 1)
    }

    // MARK: - Optional Identifiable array
    func testAppendReversion_forFullInsertionChange_onOptionalIdentifiableArray_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: nil,
            previous: [
                MockStruct(id: 0),
                MockStruct(id: 1),
                MockStruct(id: 2)
            ]
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 1)
    }

    func testAppendReversion_forFullRemovalChange_onOptionalIdentifiableArray_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: [
                MockStruct(id: 0),
                MockStruct(id: 1),
                MockStruct(id: 2)
            ],
            previous: nil
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 1)
    }

    func testAppendReversion_forNoChanges_onOptionalIdentifiableArray_willCreateZeroReversions() {
        
        let value: [MockStruct]? = [
            MockStruct(id: 0),
            MockStruct(id: 1),
            MockStruct(id: 2)
        ]
        let values: [([MockStruct]?, [MockStruct]?)] = [
            (value, value),
            (nil, nil)
        ]

        for (current, previous) in values {
            var reverter = DefaultReverter(
                current: current,
                previous: previous
            )
            
            reverter.appendReversion(at: \.self)
            
            XCTAssertEqual(reverter.count, 0)
        }
    }

    // MARK: - Equatable Dictionary
    func testAppendReversion_forSingleInsertionChange_onEquatableDictionary_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: [
                0 : "0",
                1 : "1",
                2 : "2",
                3 : "3"
            ],
            previous: [
                0 : "0",
                1 : "1",
                2 : "2",
                3 : "3",
                4 : "4"
            ]
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 1)
    }

    func testAppendReversion_forMultipleInsertionChanges_onEquatableDictioanry_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: [
                0 : "0",
                1 : "1",
                2 : "2",
                3 : "3"
            ],
            previous: [
                0 : "0",
                1 : "1",
                2 : "2",
                3 : "3",
                4 : "4",
                5 : "5"
            ]
        )

        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.count, 1)
    }

    func testAppendReversion_forSingleRemovalChange_onEquatableDictionary_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: [
                0 : "0",
                1 : "1",
                2 : "2",
                3 : "3"
            ],
            previous: [
                0 : "0",
                1 : "1",
                3 : "3"
            ]
        )

        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.count, 1)
    }

    func testAppendReversion_forMultipleRemovalChanges_onEquatableDictionary_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: [
                0 : "0",
                1 : "1",
                2 : "2",
                3 : "3"
            ],
            previous: [
                0 : "0",
                3 : "3"
            ]
        )

        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.count, 1)
    }

    func testAppendReversion_forRemovalChanges_andInsertionChanges_onEquatableDictionary_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: [
                0 : "0",
                1 : "1",
                2 : "2",
                3 : "3"
            ],
            previous: [
                2 : "2",
                5 : "5",
                3 : "3",
                1 : "1",
                6 : "6"
            ]
        )

        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.count, 2)
    }

    func testAppendReversion_forNoChanges_onEquatableDictionary_willCreateZeroReversions() {

        var reverter = DefaultReverter(
            current: [
                0 : "0",
                1 : "1",
                2 : "2",
                3 : "3"
            ],
            previous: [
                0 : "0",
                1 : "1",
                2 : "2",
                3 : "3"
            ]
        )

        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.count, 0)
    }
    
    // MARK: - Optional Dictionary
    func testAppendReversion_forFullInsertionChange_onOptionalDictionary_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: nil,
            previous: [
                0 : "0",
                1 : "1",
                2 : "2",
                3 : "3"
            ]
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 1)
    }

    func testAppendReversion_forFullRemovalChange_onOptionalDictionary_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: [
                0 : "0",
                1 : "1",
                2 : "2",
                3 : "3"
            ],
            previous: nil
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 1)
    }

    func testAppendReversion_forNoChanges_onOptionalDictionary_willCreateZeroReversions() {
        
        let value: [Int : String]? = [
            0 : "0",
            1 : "1",
            2 : "2",
            3 : "3"
        ]
        let values: [([Int : String]?, [Int : String]?)] = [
            (value, value),
            (nil, nil)
        ]

        for (current, previous) in values {
            var reverter = DefaultReverter(
                current: current,
                previous: previous
            )
            
            reverter.appendReversion(at: \.self)
            
            XCTAssertEqual(reverter.count, 0)
        }
    }
    
    // MARK: - Identifiable dictionary
    func testAppendReversion_forSingleInsertionChange_onIdentifiableDictionary_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: [
                0 : MockStruct(id: 0),
                1 : MockStruct(id: 1),
                2 : MockStruct(id: 2)
            ],
            previous: [
                0 : MockStruct(id: 0),
                1 : MockStruct(id: 1),
                2 : MockStruct(id: 2),
                3 : MockStruct(id: 3)
            ]
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 1)
    }

    func testAppendReversion_forMultipleInsertionChanges_onIdentifiableDictionary_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: [
                0 : MockStruct(id: 0),
                1 : MockStruct(id: 1),
                2 : MockStruct(id: 2)
            ],
            previous: [
                0 : MockStruct(id: 0),
                1 : MockStruct(id: 1),
                2 : MockStruct(id: 2),
                3 : MockStruct(id: 3),
                4 : MockStruct(id: 4)
            ]
        )
        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.count, 1)
    }

    func testAppendReversion_forSingleRemovalChange_onIdentifiableDictionary_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: [
                0 : MockStruct(id: 0),
                1 : MockStruct(id: 1),
                2 : MockStruct(id: 2)
            ],
            previous: [
                0 : MockStruct(id: 0),
                1 : MockStruct(id: 1)
            ]
        )
        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.count, 1)
    }

    func testAppendReversion_forMultipleRemovalChanges_onIdentifiableDictionary_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: [
                0 : MockStruct(id: 0),
                1 : MockStruct(id: 1),
                2 : MockStruct(id: 2)
            ],
            previous: [
                1 : MockStruct(id: 1)
            ]
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 1)
    }
    
    func testAppendReversion_forSingleMoveChange_onIdentifiableDictionary_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: [
                0 : MockStruct(id: 0),
                1 : MockStruct(id: 1),
                2 : MockStruct(id: 2)
            ],
            previous: [
                0 : MockStruct(id: 0),
                1 : MockStruct(id: 2),
                2 : MockStruct(id: 1)
            ]
        )
        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.count, 2)
    }

    func testAppendReversion_forMultipleMoveChanges_onIdentifiableDictionary_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: [
                0 : MockStruct(id: 0),
                1 : MockStruct(id: 1),
                2 : MockStruct(id: 2),
                3 : MockStruct(id: 3)
            ],
            previous: [
                0 : MockStruct(id: 1),
                1 : MockStruct(id: 0),
                2 : MockStruct(id: 3),
                3 : MockStruct(id: 2)
            ]
        )

        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.count, 4)
    }

    func testAppendReversion_forRemovalChanges_andInsertionChanges_andMoveChanges_onIdentifiableDictionary_willCreateCorrectReversions() {

            var reverter = DefaultReverter(
                current: [
                    0 : MockStruct(id: 0),
                    1 : MockStruct(id: 1),
                    2 : MockStruct(id: 2)
                ],
                previous: [
                    0 : MockStruct(id: 3),
                    1 : MockStruct(id: 2),
                    2 : MockStruct(id: 4)
                ]
            )
        
        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.count, 3)
    }

    func testAppendReversion_forNoChanges_onIdentifiableDictionary_willCreateZeroReversions() {

        var reverter = DefaultReverter(
            current: [
                0 : MockStruct(id: 0),
                1 : MockStruct(id: 1),
                2 : MockStruct(id: 2)
            ],
            previous: [
                0 : MockStruct(id: 0),
                1 : MockStruct(id: 1),
                2 : MockStruct(id: 2)
            ]
        )

        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.count, 0)
    }
    
    func testAppendReversion_forChildChanges_onIdentifiableDictionary_willCreateZeroReversions() {

        var reverter = DefaultReverter(
            current: [
                0 : MockStruct(id: 0),
                1 : MockStruct(id: 1, int: 1),
                2 : MockStruct(id: 2)
            ],
            previous: [
                0 : MockStruct(id: 0),
                1 : MockStruct(id: 1, int: 2),
                2 : MockStruct(id: 2)
            ]
        )

        reverter.appendReversion(at: \.self)

        XCTAssertEqual(reverter.count, 1)
    }

    // MARK: - Optional identifiable dictionary
    func testAppendReversion_forFullInsertionChange_onOptionalIdentifiableDictionary_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: nil,
            previous: [
                0 : MockStruct(id: 0),
                1 : MockStruct(id: 1),
                2 : MockStruct(id: 2)
            ]
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 1)
    }

    func testAppendReversion_forFullRemovalChange_onOptionalIdentifiableDictionary_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: [
                0 : MockStruct(id: 0),
                1 : MockStruct(id: 1),
                2 : MockStruct(id: 2)
            ],
            previous: nil
        )
        
        reverter.appendReversion(at: \.self)
        
        XCTAssertEqual(reverter.count, 1)
    }

    func testAppendReversion_forNoChanges_onOptionalIdentifiableDictionary_willCreateZeroReversions() {
        
        let value: [Int : MockStruct]? = [
            0 : MockStruct(id: 0),
            1 : MockStruct(id: 1),
            2 : MockStruct(id: 2)
        ]
        let values: [([Int : MockStruct]?, [Int : MockStruct]?)] = [
            (value, value),
            (nil, nil)
        ]

        for (current, previous) in values {
            var reverter = DefaultReverter(
                current: current,
                previous: previous
            )
            
            reverter.appendReversion(at: \.self)
            
            XCTAssertEqual(reverter.count, 0)
        }
    }
}
