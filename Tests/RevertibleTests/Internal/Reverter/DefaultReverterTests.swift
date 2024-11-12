import Foundation
import Testing
@testable import Revertible

@Suite("Default reverter")
struct DefaultReverterTests {}

// MARK: - Tests
extension DefaultReverterTests {
    
    // MARK: - Int
    @Test("Append reversion for Int changes")
    func appendReversionForIntChanges() {
        
        var reverter = DefaultReverter(
            current: Int(1),
            previous: Int(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        #expect(reverter.count == 1)
    }
    
    @Test("Append reversion for no Int changes")
    func appendReversionForNoIntChanges() {
        
        var reverter = DefaultReverter(
            current: Int(0),
            previous: Int(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        #expect(reverter.count == 0)
    }
    
    // MARK: - Optional Int
    @Test("Append reversion for Optional Int changes")
    func appendReversionForOptionalIntChanges() {
        
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
            
            #expect(reverter.count == 1)
        }
    }
    
    @Test("Append reversion for no Optional Int changes")
    func appendReversionForNoOptionalIntChanges() {
        
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
            
            #expect(reverter.count == 0)
        }
    }
    
    // MARK: - Int64
    @Test("Append reversion for Int64 changes")
    func appendReversionForInt64Changes() {
        
        var reverter = DefaultReverter(
            current: Int64(1),
            previous: Int64(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        #expect(reverter.count == 1)
    }
    
    @Test("Append reversion for no Int64 changes")
    func appendReversionForNoInt64Changes() {
        
        var reverter = DefaultReverter(
            current: Int64(0),
            previous: Int64(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        #expect(reverter.count == 0)
    }
    
    // MARK: - Optional Int64
    @Test("Append reversion for Optional Int64 changes")
    func appendReversionForOptionalInt64Changes() {
        
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
            
            #expect(reverter.count == 1)
        }
    }
    
    @Test("Append reversion for no Optional Int64 changes")
    func appendReversionForNoOptionalInt64Changes() {
        
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
            
            #expect(reverter.count == 0)
        }
    }

    // MARK: - Int32
    @Test("Append reversion for Int32 changes")
    func appendReversionForInt32Changes() {
        
        var reverter = DefaultReverter(
            current: Int32(1),
            previous: Int32(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        #expect(reverter.count == 1)
    }
    
    @Test("Append reversion for no Int32 changes")
    func appendReversionForNoInt32Changes() {
        
        var reverter = DefaultReverter(
            current: Int32(0),
            previous: Int32(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        #expect(reverter.count == 0)
    }
    
    // MARK: - Optional Int32
    @Test("Append reversion for Optional Int32 changes")
    func appendReversionForOptionalInt32Changes() {
        
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
            
            #expect(reverter.count == 1)
        }
    }
    
    @Test("Append reversion for no Optional Int32 changes")
    func appendReversionForNoOptionalInt32Changes() {
        
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
            
            #expect(reverter.count == 0)
        }
    }

    // MARK: - Int16
    @Test("Append reversion for Int16 changes")
    func appendReversionForInt16Changes() {
        
        var reverter = DefaultReverter(
            current: Int16(1),
            previous: Int16(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        #expect(reverter.count == 1)
    }
    
    @Test("Append reversion for no Int16 changes")
    func appendReversionForNoInt16Changes() {
        
        var reverter = DefaultReverter(
            current: Int16(0),
            previous: Int16(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        #expect(reverter.count == 0)
    }
    
    // MARK: - Optional Int16
    @Test("Append reversion for Optional Int16 changes")
    func appendReversionForOptionalInt16Changes() {
        
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
            
            #expect(reverter.count == 1)
        }
    }
    
    @Test("Append reversion for no Optional Int16 changes")
    func appendReversionForNoOptionalInt16Changes() {
        
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
            
            #expect(reverter.count == 0)
        }
    }
    
    // MARK: - Int8
    @Test("Append reversion for Int8 changes")
    func appendReversionForInt8Changes() {
        
        var reverter = DefaultReverter(
            current: Int8(1),
            previous: Int8(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        #expect(reverter.count == 1)
    }
    
    @Test("Append reversion for no Int8 changes")
    func appendReversionForNoInt8Changes() {
        
        var reverter = DefaultReverter(
            current: Int8(0),
            previous: Int8(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        #expect(reverter.count == 0)
    }
    
    // MARK: - Optional Int8
    @Test("Append reversion for Optional Int8 changes")
    func appendReversionForOptionalInt8Changes() {
        
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
            
            #expect(reverter.count == 1)
        }
    }
    
    @Test("Append reversion for no Optional Int8 changes")
    func appendReversionForNoOptionalInt8Changes() {
        
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
            
            #expect(reverter.count == 0)
        }
    }
    
    // MARK: - UInt
    @Test("Append reversion for UInt changes")
    func appendReversionForUIntChanges() {
        
        var reverter = DefaultReverter(
            current: UInt(1),
            previous: UInt(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        #expect(reverter.count == 1)
    }
    
    @Test("Append reversion for no UInt changes")
    func appendReversionForNoUIntChanges() {
        
        var reverter = DefaultReverter(
            current: UInt(0),
            previous: UInt(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        #expect(reverter.count == 0)
    }
    
    // MARK: - Optional UInt
    @Test("Append reversion for Optional UInt changes")
    func appendReversionForOptionalUIntChanges() {
        
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
            
            #expect(reverter.count == 1)
        }
    }
    
    @Test("Append reversion for no Optional UInt changes")
    func appendReversionForNoOptionalUIntChanges() {
        
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
            
            #expect(reverter.count == 0)
        }
    }
    
    // MARK: - UInt64
    @Test("Append reversion for UInt64 changes")
    func appendReversionForUInt64Changes() {
        
        var reverter = DefaultReverter(
            current: UInt64(1),
            previous: UInt64(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        #expect(reverter.count == 1)
    }
    
    @Test("Append reversion for no UInt64 changes")
    func appendReversionForNoUInt64Changes() {
        
        var reverter = DefaultReverter(
            current: UInt64(0),
            previous: UInt64(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        #expect(reverter.count == 0)
    }
    
    // MARK: - Optional UInt64
    @Test("Append reversion for Optional UInt64 changes")
    func appendReversionForOptionalUInt64Changes() {
        
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
            
            #expect(reverter.count == 1)
        }
    }
    
    @Test("Append reversion for no Optional UInt64 changes")
    func appendReversionForNoOptionalUInt64Changes() {
        
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
            
            #expect(reverter.count == 0)
        }
    }
    
    // MARK: - UInt32
    @Test("Append reversion for UInt32 changes")
    func appendReversionForUInt32Changes() {
        
        var reverter = DefaultReverter(
            current: UInt32(1),
            previous: UInt32(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        #expect(reverter.count == 1)
    }
    
    @Test("Append reversion for no UInt32 changes")
    func appendReversionForNoUInt32Changes() {
        
        var reverter = DefaultReverter(
            current: UInt32(0),
            previous: UInt32(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        #expect(reverter.count == 0)
    }
    
    // MARK: - Optional UInt32
    @Test("Append reversion for Optional UInt32 changes")
    func appendReversionForOptionalUInt32Changes() {
        
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
            
            #expect(reverter.count == 1)
        }
    }
    
    @Test("Append reversion for no Optional UInt32 changes")
    func appendReversionForNoOptionalUInt32Changes() {
        
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
            
            #expect(reverter.count == 0)
        }
    }
    
    // MARK: - UInt16
    @Test("Append reversion for UInt16 changes")
    func appendReversionForUInt16Changes() {
        
        var reverter = DefaultReverter(
            current: UInt16(1),
            previous: UInt16(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        #expect(reverter.count == 1)
    }
    
    @Test("Append reversion for no UInt16 changes")
    func appendReversionForNoUInt16Changes() {
        
        var reverter = DefaultReverter(
            current: UInt16(0),
            previous: UInt16(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        #expect(reverter.count == 0)
    }
    
    // MARK: - Optional UInt16
    @Test("Append reversion for Optional UInt16 changes")
    func appendReversionForOptionalUInt16Changes() {
        
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
            
            #expect(reverter.count == 1)
        }
    }
    
    @Test("Append reversion for no Optional UInt16 changes")
    func appendReversionForNoOptionalUInt16Changes() {
        
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
            
            #expect(reverter.count == 0)
        }
    }

    
    // MARK: - UInt8
    @Test("Append reversion for UInt8 changes")
    func appendReversionForUInt8Changes() {
        
        var reverter = DefaultReverter(
            current: UInt8(1),
            previous: UInt8(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        #expect(reverter.count == 1)
    }
    
    @Test("Append reversion for no UInt8 changes")
    func appendReversionForNoUInt8Changes() {
        
        var reverter = DefaultReverter(
            current: UInt8(0),
            previous: UInt8(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        #expect(reverter.count == 0)
    }
    
    // MARK: - Optional UInt8
    @Test("Append reversion for Optional UInt8 changes")
    func appendReversionForOptionalUInt8Changes() {
        
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
            
            #expect(reverter.count == 1)
        }
    }
    
    @Test("Append reversion for no Optional UInt8 changes")
    func appendReversionForNoOptionalUInt8Changes() {
        
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
            
            #expect(reverter.count == 0)
        }
    }
    
    // MARK: - Double
    @Test("Append reversion for Double changes")
    func appendReversionForDoubleChanges() {
        
        var reverter = DefaultReverter(
            current: Double(1),
            previous: Double(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        #expect(reverter.count == 1)
    }
    
    @Test("Append reversion for no Double changes")
    func appendReversionForNoDoubleChanges() {
        
        var reverter = DefaultReverter(
            current: Double(0),
            previous: Double(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        #expect(reverter.count == 0)
    }
    
    // MARK: - Optional Double
    @Test("Append reversion for Optional Double changes")
    func appendReversionForOptionalDoubleChanges() {
        
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
            
            #expect(reverter.count == 1)
        }
    }
    
    @Test("Append reversion for no Optional Double changes")
    func appendReversionForNoOptionalDoubleChanges() {
        
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
            
            #expect(reverter.count == 0)
        }
    }

    // MARK: - Float
    @Test("Append reversion for Float changes")
    func appendReversionForFloatChanges() {
        
        var reverter = DefaultReverter(
            current: Float(1),
            previous: Float(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        #expect(reverter.count == 1)
    }
    
    @Test("Append reversion for no Float changes")
    func appendReversionForNoFloatChanges() {
        
        var reverter = DefaultReverter(
            current: Float(0),
            previous: Float(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        #expect(reverter.count == 0)
    }
    
    // MARK: - Optional Float
    @Test("Append reversion for Optional Float changes")
    func appendReversionForOptionalFloatChanges() {
        
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
            
            #expect(reverter.count == 1)
        }
    }
    
    @Test("Append reversion for no Optional Float changes")
    func appendReversionForNoOptionalFloatChanges() {
        
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
            
            #expect(reverter.count == 0)
        }
    }

    #if os(iOS)
    // MARK: - Float16
    @Test("Append reversion for Float16 changes")
    func appendReversionForFloat16Changes() {
        
        var reverter = DefaultReverter(
            current: Float16(1),
            previous: Float16(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        #expect(reverter.count == 1)
    }
    
    @Test("Append reversion for no Float16 changes")
    func appendReversionForNoFloat16Changes() {
        
        var reverter = DefaultReverter(
            current: Float16(0),
            previous: Float16(0)
        )
        
        reverter.appendReversion(at: \.self)
        
        #expect(reverter.count == 0)
    }
    
    // MARK: - Optional Float16
    @Test("Append reversion for Optional Float16 changes")
    func appendReversionForOptionalFloat16Changes() {
        
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
            
            #expect(reverter.count == 1)
        }
    }
    
    @Test("Append reversion for no Optional Float16 changes")
    func appendReversionForNoOptionalFloat16Changes() {
        
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
            
            #expect(reverter.count == 0)
        }
    }
    #endif
    
    // MARK: - Date
    @Test("Append reversion for Date changes")
    func appendReversionForDateChanges() {
        
        var reverter = DefaultReverter(
            current: Date(timeIntervalSinceReferenceDate: 0),
            previous: Date(timeIntervalSinceReferenceDate: 1)
        )
        
        reverter.appendReversion(at: \.self)
        
        #expect(reverter.count == 1)
    }
    
    @Test("Append reversion for no Date changes")
    func appendReversionForNoDateChanges() {
        
        var reverter = DefaultReverter(
            current: Date(timeIntervalSinceReferenceDate: 0),
            previous: Date(timeIntervalSinceReferenceDate: 0)
        )
        
        reverter.appendReversion(at: \.self)
        
        #expect(reverter.count == 0)
    }
    
    // MARK: - Optional Date
    @Test("Append reversion for Optional Date changes")
    func appendReversionForOptionalDateChanges() {
        
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
            
            #expect(reverter.count == 1)
        }
    }
    
    @Test("Append reversion for no Optional Date changes")
    func appendReversionForNoOptionalDateChanges() {
        
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
            
            #expect(reverter.count == 0)
        }
    }
    
    // MARK: - UUID
    @Test("Append reversion for UUID changes")
    func appendReversionForUUIDChanges() {
        
        var reverter = DefaultReverter(
            current: UUID(),
            previous: UUID()
        )
        
        reverter.appendReversion(at: \.self)
        
        #expect(reverter.count == 1)
    }
    
    @Test("Append reversion for no UUID changes")
    func appendReversionForNoUUIDChanges() {
        
        let value = UUID()
        var reverter = DefaultReverter(
            current: value,
            previous: value
        )
        
        reverter.appendReversion(at: \.self)
        
        #expect(reverter.count == 0)
    }
    
    // MARK: - Optional Date
    @Test("Append reversion for Optional UUID changes")
    func appendReversionForOptionalUUIDChanges() {
        
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
            
            #expect(reverter.count == 1)
        }
    }
    
    @Test("Append reversion for no Optional UUID changes")
    func appendReversionForNoOptionalUUIDChanges() {
        
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
            
            #expect(reverter.count == 0)
        }
    }

    // MARK: - String
    @Test
    func AppendReversion_forSingleInsertionChange_onString_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: "abc",
            previous: "abcde"
        )
        
        reverter.appendReversion(at: \.self)
        
        #expect(reverter.count == 1)
    }

    @Test
    func AppendReversion_forMultipleInsertionChanges_onString_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: "abc",
            previous: "a12bcd"
        )
        
        reverter.appendReversion(at: \.self)
        
        #expect(reverter.count == 1)
    }

    @Test
    func AppendReversion_forSingleRemovalChange_onString_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: "abc",
            previous: "c"
        )
        
        reverter.appendReversion(at: \.self)
        
        #expect(reverter.count == 1)
    }
    
    @Test
    func AppendReversion_forMultipleRemovalChanges_onString_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: "abc",
            previous: "b"
        )
        
        reverter.appendReversion(at: \.self)
        
        #expect(reverter.count == 1)
    }

    @Test
    func AppendReversion_forRemovalChanges_andInsertionChanges_onString_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: "abc",
            previous: "11b22"
        )
        
        reverter.appendReversion(at: \.self)
        
        #expect(reverter.count == 2)
    }

    @Test("Append reversion for no String changes")
    func appendReversionForNoStringChanges() {
        
        var reverter = DefaultReverter(
            current: "abc",
            previous: "abc"
        )
        
        reverter.appendReversion(at: \.self)
        
        #expect(reverter.count == 0)
    }

    // MARK: - Optional String
    @Test
    func AppendReversion_forFullInsertionChange_onOptionalString_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: nil,
            previous: "abc"
        )
        
        reverter.appendReversion(at: \.self)
        
        #expect(reverter.count == 1)
    }

    @Test
    func AppendReversion_forFullRemovalChange_onOptionalString_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: "abc",
            previous: nil
        )
        
        reverter.appendReversion(at: \.self)
        
        #expect(reverter.count == 1)
    }

    @Test("Append reversion for no Optional String changes")
    func appendReversionForNoOptionalStringChanges() {
        
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
            
            #expect(reverter.count == 0)
        }
    }

    // MARK: - Data
    @Test
    func AppendReversion_forSingleInsertionChange_onData_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: Data([0, 1, 2, 3]),
            previous: Data([0, 1, 2, 3, 4])
        )
        
        reverter.appendReversion(at: \.self)
        
        #expect(reverter.count == 1)
    }

    @Test
    func AppendReversion_forMultipleInsertionChanges_onData_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: Data([0, 1, 2, 3]),
            previous: Data([0, 5, 1, 2, 3, 4, 4])
        )

        reverter.appendReversion(at: \.self)

        #expect(reverter.count == 1)
    }

    @Test
    func AppendReversion_forSingleRemovalChange_onData_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: Data([0, 1, 2, 3]),
            previous: Data([0, 1, 3])
        )

        reverter.appendReversion(at: \.self)

        #expect(reverter.count == 1)
    }

    @Test
    func AppendReversion_forMultipleRemovalChanges_onData_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: Data([0, 1, 2, 3]),
            previous: Data([0, 2])
        )

        reverter.appendReversion(at: \.self)

        #expect(reverter.count == 1)
    }

    @Test
    func AppendReversion_forRemovalChanges_andInsertionChanges_onData_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: Data([0, 1, 2, 3]),
            previous: Data([2, 5, 3, 1, 1])
        )

        reverter.appendReversion(at: \.self)

        #expect(reverter.count == 2)
    }

    @Test("Append reversion for no Data changes")
    func appendReversionForNoDataChanges() {

        var reverter = DefaultReverter(
            current: Data([0, 1, 2, 3]),
            previous: Data([0, 1, 2, 3])
        )

        reverter.appendReversion(at: \.self)

        #expect(reverter.count == 0)
    }
    
    // MARK: - Optional Data
    @Test
    func AppendReversion_forFullInsertionChange_onOptionalData_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: nil,
            previous: Data([0, 1, 2, 3])
        )
        
        reverter.appendReversion(at: \.self)
        
        #expect(reverter.count == 1)
    }

    @Test
    func AppendReversion_forFullRemovalChange_onOptionalData_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: Data([0, 1, 2, 3]),
            previous: nil
        )
        
        reverter.appendReversion(at: \.self)
        
        #expect(reverter.count == 1)
    }

    @Test("Append reversion for no Optional Data changes")
    func appendReversionForNoOptionalDataChanges() {
        
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
            
            #expect(reverter.count == 0)
        }
    }
    
    // MARK: - Set
    @Test
    func AppendReversion_forSingleInsertionChange_onSet_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: Set([0, 1, 2, 3]),
            previous: Set([0, 1, 2, 3, 4])
        )
        
        reverter.appendReversion(at: \.self)
        
        #expect(reverter.count == 1)
    }

    @Test
    func AppendReversion_forMultipleInsertionChanges_onSet_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: Set([0, 1, 2, 3]),
            previous: Set([0, 5, 1, 2, 3, 4, 4])
        )

        reverter.appendReversion(at: \.self)

        #expect(reverter.count == 1)
    }

    @Test
    func AppendReversion_forSingleRemovalChange_onSet_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: Set([0, 1, 2, 3]),
            previous: Set([0, 1, 3])
        )

        reverter.appendReversion(at: \.self)

        #expect(reverter.count == 1)
    }

    @Test
    func AppendReversion_forMultipleRemovalChanges_onSet_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: Set([0, 1, 2, 3]),
            previous: Set([0, 2])
        )

        reverter.appendReversion(at: \.self)

        #expect(reverter.count == 1)
    }

    @Test
    func AppendReversion_forRemovalChanges_andInsertionChanges_onSet_willCreateCorrectReversions() {

        var reverter = DefaultReverter(
            current: Set([0, 1, 2, 3]),
            previous: Set([2, 5, 3, 1, 1])
        )

        reverter.appendReversion(at: \.self)

        #expect(reverter.count == 2)
    }

    @Test("Append reversion for no Set changes")
    func appendReversionForNoSetChanges() {

        var reverter = DefaultReverter(
            current: Set([0, 1, 2, 3]),
            previous: Set([0, 1, 2, 3])
        )

        reverter.appendReversion(at: \.self)

        #expect(reverter.count == 0)
    }
    
    // MARK: - Optional Set
    @Test
    func AppendReversion_forFullInsertionChange_onOptionalSet_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: nil,
            previous: Set([0, 1, 2, 3])
        )
        
        reverter.appendReversion(at: \.self)
        
        #expect(reverter.count == 1)
    }

    @Test
    func AppendReversion_forFullRemovalChange_onOptionalSet_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: Set([0, 1, 2, 3]),
            previous: nil
        )
        
        reverter.appendReversion(at: \.self)
        
        #expect(reverter.count == 1)
    }

    @Test("Append reversion for no Optional Set changes")
    func appendReversionForNoOptionalSetChanges() {
        
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
            
            #expect(reverter.count == 0)
        }
    }

    // MARK: - Identifiable array
    @Test
    func AppendReversion_forSingleInsertionChange_onIdentifiableArray_willCreateCorrectReversions() {
        
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
        
        #expect(reverter.count == 1)
    }

    @Test
    func AppendReversion_forMultipleInsertionChanges_onIdentifiableArray_willCreateCorrectReversions() {

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

        #expect(reverter.count == 1)
    }

    @Test
    func AppendReversion_forSingleRemovalChange_onIdentifiableArray_willCreateCorrectReversions() {

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

        #expect(reverter.count == 1)
    }

    @Test
    func AppendReversion_forMultipleRemovalChanges_onIdentifiableArray_willCreateCorrectReversions() {

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

        #expect(reverter.count == 1)
    }
    
    @Test
    func AppendReversion_forSingleMoveChange_onIdentifiableArray_willCreateCorrectReversions() {

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

        #expect(reverter.count == 1)
    }

    @Test
    func AppendReversion_forMultipleMoveChanges_onIdentifiableArray_willCreateCorrectReversions() {

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

        #expect(reverter.count == 2)
    }

    @Test
    func AppendReversion_forRemovalChanges_andInsertionChanges_andMoveChanges_onIdentifiableArray_willCreateCorrectReversions() {

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

        #expect(reverter.count == 3)
    }

    @Test("Append reversion for no IdentifiableArray changes")
    func appendReversionForNoIdentifiableArrayChanges() {

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

        #expect(reverter.count == 0)
    }
    
    @Test
    func AppendReversion_forChildChanges_onIdentifiableArray_willCreateZeroReversions() {

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

        #expect(reverter.count == 1)
    }

    // MARK: - Optional Identifiable array
    @Test
    func AppendReversion_forFullInsertionChange_onOptionalIdentifiableArray_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: nil,
            previous: [
                MockStruct(id: 0),
                MockStruct(id: 1),
                MockStruct(id: 2)
            ]
        )
        
        reverter.appendReversion(at: \.self)
        
        #expect(reverter.count == 1)
    }

    @Test
    func AppendReversion_forFullRemovalChange_onOptionalIdentifiableArray_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: [
                MockStruct(id: 0),
                MockStruct(id: 1),
                MockStruct(id: 2)
            ],
            previous: nil
        )
        
        reverter.appendReversion(at: \.self)
        
        #expect(reverter.count == 1)
    }

    @Test("Append reversion for no Optional IdentifiableArray changes")
    func appendReversionForNoOptionalIdentifiableArrayChanges() {
        
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
            
            #expect(reverter.count == 0)
        }
    }

    // MARK: - Identifiable dictionary
    @Test
    func AppendReversion_forSingleInsertionChange_onIdentifiableDictionary_willCreateCorrectReversions() {
        
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
        
        #expect(reverter.count == 1)
    }

    @Test
    func AppendReversion_forMultipleInsertionChanges_onIdentifiableDictionary_willCreateCorrectReversions() {

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

        #expect(reverter.count == 1)
    }

    @Test
    func AppendReversion_forSingleRemovalChange_onIdentifiableDictionary_willCreateCorrectReversions() {

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

        #expect(reverter.count == 1)
    }

    @Test
    func AppendReversion_forMultipleRemovalChanges_onIdentifiableDictionary_willCreateCorrectReversions() {
        
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
        
        #expect(reverter.count == 1)
    }
    
    @Test
    func AppendReversion_forSingleMoveChange_onIdentifiableDictionary_willCreateCorrectReversions() {

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

        #expect(reverter.count == 2)
    }

    @Test
    func AppendReversion_forMultipleMoveChanges_onIdentifiableDictionary_willCreateCorrectReversions() {

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

        #expect(reverter.count == 4)
    }

    @Test
    func AppendReversion_forRemovalChanges_andInsertionChanges_andMoveChanges_onIdentifiableDictionary_willCreateCorrectReversions() {

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

        #expect(reverter.count == 3)
    }

    @Test("Append reversion for no IdentifiableDictionary changes")
    func appendReversionForNoIdentifiableDictionaryChanges() {

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

        #expect(reverter.count == 0)
    }
    
    @Test
    func AppendReversion_forChildChanges_onIdentifiableDictionary_willCreateZeroReversions() {

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

        #expect(reverter.count == 1)
    }

    // MARK: - Optional identifiable dictionary
    @Test
    func AppendReversion_forFullInsertionChange_onOptionalIdentifiableDictionary_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: nil,
            previous: [
                0 : MockStruct(id: 0),
                1 : MockStruct(id: 1),
                2 : MockStruct(id: 2)
            ]
        )
        
        reverter.appendReversion(at: \.self)
        
        #expect(reverter.count == 1)
    }

    @Test
    func AppendReversion_forFullRemovalChange_onOptionalIdentifiableDictionary_willCreateCorrectReversions() {
        
        var reverter = DefaultReverter(
            current: [
                0 : MockStruct(id: 0),
                1 : MockStruct(id: 1),
                2 : MockStruct(id: 2)
            ],
            previous: nil
        )
        
        reverter.appendReversion(at: \.self)
        
        #expect(reverter.count == 1)
    }

    @Test("Append reversion for no Optional IdentifiableDictionary changes")
    func appendReversionForNoOptionalIdentifiableDictionaryChanges() {
        
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
            
            #expect(reverter.count == 0)
        }
    }
}
