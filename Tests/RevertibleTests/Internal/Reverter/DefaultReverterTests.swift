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
    @Test("Append reversion for Single Insertion Change on String")
    func appendReversionForSingleInsertionChangeOnString() {

        var reverter = DefaultReverter(
            current: "abc",
            previous: "abcde"
        )

        reverter.appendReversion(at: \.self)

        #expect(reverter.count == 1)
    }

    @Test("Append reversion for Multiple Insertion Changes on String")
    func appendReversionForMultipleInsertionChangesOnString() {

        var reverter = DefaultReverter(
            current: "abc",
            previous: "a12bcd"
        )

        reverter.appendReversion(at: \.self)

        #expect(reverter.count == 1)
    }

    @Test("Append reversion for Single Removal Change on String")
    func appendReversionForSingleRemovalChangeOnString() {

        var reverter = DefaultReverter(
            current: "abc",
            previous: "c"
        )

        reverter.appendReversion(at: \.self)

        #expect(reverter.count == 1)
    }

    @Test("Append reversion for Multiple Removal Changes on String")
    func appendReversionForMultipleRemovalChangesOnString() {

        var reverter = DefaultReverter(
            current: "abc",
            previous: "b"
        )

        reverter.appendReversion(at: \.self)

        #expect(reverter.count == 1)
    }

    @Test("Append reversion for Removal Changes and Insertion Changes on String")
    func appendReversionForRemovalChangesAndInsertionChangesOnString() {

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
    @Test("Append reversion for Full Insertion Change on Optional String")
    func appendReversionForFullInsertionChangeOnOptionalString() {

        var reverter = DefaultReverter(
            current: nil,
            previous: "abc"
        )

        reverter.appendReversion(at: \.self)

        #expect(reverter.count == 1)
    }

    @Test("Append reversion for Full Removal Change on Optional String")
    func appendReversionForFullRemovalChangeOnOptionalString() {

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
    @Test("Append reversion for Single Insertion Change on Data")
    func appendReversionForSingleInsertionChangeOnData() {

        var reverter = DefaultReverter(
            current: Data([0, 1, 2, 3]),
            previous: Data([0, 1, 2, 3, 4])
        )

        reverter.appendReversion(at: \.self)

        #expect(reverter.count == 1)
    }

    @Test("Append reversion for Multiple Insertion Changes on Data")
    func appendReversionForMultipleInsertionChangesOnData() {

        var reverter = DefaultReverter(
            current: Data([0, 1, 2, 3]),
            previous: Data([0, 5, 1, 2, 3, 4, 4])
        )

        reverter.appendReversion(at: \.self)

        #expect(reverter.count == 1)
    }

    @Test("Append reversion for Single Removal Change on Data")
    func appendReversionForSingleRemovalChangeOnData() {

        var reverter = DefaultReverter(
            current: Data([0, 1, 2, 3]),
            previous: Data([0, 1, 3])
        )

        reverter.appendReversion(at: \.self)

        #expect(reverter.count == 1)
    }

    @Test("Append reversion for Multiple Removal Changes on Data")
    func appendReversionForMultipleRemovalChangesOnData() {

        var reverter = DefaultReverter(
            current: Data([0, 1, 2, 3]),
            previous: Data([0, 2])
        )

        reverter.appendReversion(at: \.self)

        #expect(reverter.count == 1)
    }

    @Test("Append reversion for Removal Changes and Insertion Changes on Data")
    func appendReversionForRemovalChangesAndInsertionChangesOnData() {

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
    @Test("Append reversion for Full Insertion Change on Optional Data")
    func appendReversionForFullInsertionChangeOnOptionalData() {

        var reverter = DefaultReverter(
            current: nil,
            previous: Data([0, 1, 2, 3])
        )

        reverter.appendReversion(at: \.self)

        #expect(reverter.count == 1)
    }

    @Test("Append reversion for Full Removal Change on Optional Data")
    func appendReversionForFullRemovalChangeOnOptionalData() {

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
    @Test("Append reversion for Single Insertion Change on Set")
    func appendReversionForSingleInsertionChangeOnSet() {

        var reverter = DefaultReverter(
            current: Set([0, 1, 2, 3]),
            previous: Set([0, 1, 2, 3, 4])
        )

        reverter.appendReversion(at: \.self)

        #expect(reverter.count == 1)
    }

    @Test("Append reversion for Multiple Insertion Changes on Set")
    func appendReversionForMultipleInsertionChangesOnSet() {

        var reverter = DefaultReverter(
            current: Set([0, 1, 2, 3]),
            previous: Set([0, 5, 1, 2, 3, 4, 4])
        )

        reverter.appendReversion(at: \.self)

        #expect(reverter.count == 1)
    }

    @Test("Append reversion for Single Removal Change on Set")
    func appendReversionForSingleRemovalChangeOnSet() {

        var reverter = DefaultReverter(
            current: Set([0, 1, 2, 3]),
            previous: Set([0, 1, 3])
        )

        reverter.appendReversion(at: \.self)

        #expect(reverter.count == 1)
    }

    @Test("Append reversion for Multiple Removal Changes on Set")
    func appendReversionForMultipleRemovalChangesOnSet() {

        var reverter = DefaultReverter(
            current: Set([0, 1, 2, 3]),
            previous: Set([0, 2])
        )

        reverter.appendReversion(at: \.self)

        #expect(reverter.count == 1)
    }

    @Test("Append reversion for Removal Changes and Insertion Changes on Set")
    func appendReversionForRemovalChangesAndInsertionChangesOnSet() {

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
    @Test("Append reversion for Full Insertion Change on Optional Set")
    func appendReversionForFullInsertionChangeOnOptionalSet() {

        var reverter = DefaultReverter(
            current: nil,
            previous: Set([0, 1, 2, 3])
        )

        reverter.appendReversion(at: \.self)

        #expect(reverter.count == 1)
    }

    @Test("Append reversion for Full Removal Change on Optional Set")
    func appendReversionForFullRemovalChangeOnOptionalSet() {

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
    @Test("Append reversion for Single Insertion Change on Identifiable Array")
    func appendReversionForSingleInsertionChangeOnIdentifiableArray() {

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

    @Test("Append reversion for Multiple Insertion Changes on Identifiable Array")
    func appendReversionForMultipleInsertionChangesOnIdentifiableArray() {

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

    @Test("Append reversion for Single Removal Change on Identifiable Array")
    func appendReversionForSingleRemovalChangeOnIdentifiableArray() {

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

    @Test("Append reversion for Multiple Removal Changes on Identifiable Array")
    func appendReversionForMultipleRemovalChangesOnIdentifiableArray() {

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

    @Test("Append reversion for Single Move Change on Identifiable Array")
    func appendReversionForSingleMoveChangeOnIdentifiableArray() {

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

    @Test("Append reversion for Full Move Changes on Identifiable Array")
    func appendReversionForMultipleMoveChangesOnIdentifiableArray() {

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

    @Test("Append reversion for Removal Changes and Insertion Changes and Move Changes on Identifiable Array")
    func appendReversionForRemovalChangesAndInsertionChangesAndMoveChangesOnIdentifiableArray() {

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

    @Test("Append reversion for no Identifiable Array changes")
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

    @Test("Append reversion for child changes on Identifiable Array")
    func AppendReversionForChildChangesOnIdentifiableArray() {

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
    @Test("Append reversion for Full Insertion Change on Optional Identifiable Array")
    func appendReversionForFullInsertionChangeOnOptionalIdentifiableArray() {

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

    @Test("Append reversion for Full Removal Change on Optional Identifiable Array")
    func appendReversionForFullRemovalChangeOnOptionalIdentifiableArray() {

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

    @Test("Append reversion for no Optional Identifiable Array changes")
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
    @Test("Append reversion for Single Insertion Change on Identifiable Dictionary")
    func appendReversionForSingleInsertionChangeOnIdentifiableDictionary() {

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

    @Test("Append reversion for Multiple Insertion Changes on Identifiable Dictionary")
    func appendReversionForMultipleInsertionChangesOnIdentifiableDictionary() {

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

    @Test("Append reversion for Single Removal Change on Identifiable Dictionary")
    func appendReversionForSingleRemovalChangeOnIdentifiableDictionary() {

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

    @Test("Append reversion for Multiple Removal Changes on Identifiable Dictionary")
    func appendReversionForMultipleRemovalChangesOnIdentifiableDictionary() {

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

    @Test("Append reversion for Single Move Change on Identifiable Dictionary")
    func appendReversionForSingleMoveChangeOnIdentifiableDictionary() {

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

    @Test("Append reversion for Full Move Changes on Identifiable Dictionary")
    func appendReversionForMultipleMoveChangesOnIdentifiableDictionary() {

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

    @Test("Append reversion for Removal Changes and Insertion Changes and Move Changes on Identifiable Dictionary")
    func appendReversionForRemovalChangesAndInsertionChangesAndMoveChangesOnIdentifiableDictionary() {

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

    @Test("Append reversion for no Identifiable Dictionary changes")
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

    @Test("Append reversion for child changes on Identifiable Dictionary")
    func AppendReversionForChildChangesOnIdentifiableDictionary() {

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
    @Test("Append reversion for Full Insertion Change on Optional Identifiable Dictionary")
    func appendReversionForFullInsertionChangeOnOptionalIdentifiableDictionary() {

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

    @Test("Append reversion for Full Removal Change on Optional Identifiable Dictionary")
    func appendReversionForFullRemovalChangeOnOptionalIdentifiableDictionary() {

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

    @Test("Append reversion for no Optional Identifiable Dictionary changes")
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
