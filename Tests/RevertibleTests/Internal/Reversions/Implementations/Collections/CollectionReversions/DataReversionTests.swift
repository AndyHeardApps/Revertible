import Testing
import Foundation
@testable import Revertible

@Suite("Data reversion")
struct DataReversionTests {}

// MARK: - Tests
extension DataReversionTests {

    // MARK: Insert
    @Test("Insert reversion with value self key path")
    func insertReversionOnValueSelfKeyPath() {

        var value = Data([0, 1, 2, 3])

        let reversion = DataReversion(
            insert: [
                .init(index: 0, elements: .init(10...10)),
                .init(index: 6, elements: .init(11...12)),
                .init(index: 2, elements: .init(13...13))
            ]
        )

        reversion.revert(&value)

        #expect(value == Data([10, 0, 13, 1, 2, 3, 11, 12]))
    }

    // MARK: Remove
    @Test("Remove reversion with value self key path")
    func removeReversionOnValueSelfKeyPath() {

        var value = Data([0, 1, 2, 3])

        let reversion = DataReversion(
            remove: [
                0...0,
                2...3
            ]
        )

        reversion.revert(&value)

        #expect(value == Data([1]))
    }

    // MARK: Mapped insertion
    @Test("Insert reversion with mapped child key path")
    func insertReversionOnMappedChildKeyPath() {

        var value = MockStruct()

        let reversion = DataReversion(
            insert: [
                .init(index: 0, elements: .init(10...10)),
                .init(index: 6, elements: .init(11...12)),
                .init(index: 2, elements: .init(13...13))
            ]
        )
        .mapped(to: \MockStruct.data)

        reversion.revert(&value)

        #expect(value.data == Data([10, 0, 13, 1, 2, 3, 11, 12]))
    }

    @Test("Insert reversion with mapped reference child key path")
    func insertReversionOnMappedReferenceChildKeyPath() {

        var value = MockClass()

        let reversion = DataReversion(
            insert: [
                .init(index: 0, elements: .init(10...10)),
                .init(index: 6, elements: .init(11...12)),
                .init(index: 2, elements: .init(13...13))
            ]
        )
        .mapped(to: \MockClass.data)

        reversion.revert(&value)

        #expect(value.data == Data([10, 0, 13, 1, 2, 3, 11, 12]))
    }

    // MARK: Mapped removal
    @Test("Remove reversion with mapped child key path")
    func removeReversionOnMappedChildKeyPath() {

        var value = MockStruct()

        let reversion = DataReversion(
            remove: [
                0...0,
                2...3
            ]
        )
        .mapped(to: \MockStruct.data)

        reversion.revert(&value)

        #expect(value.data == Data([1]))
    }

    @Test("Remove reversion with mapped reference child key path")
    func removeReversionOnMappedReferenceChildKeyPath() {

        var value = MockClass()

        let reversion = DataReversion(
            remove: [
                0...0,
                2...3
            ]
        )
        .mapped(to: \MockClass.data)

        reversion.revert(&value)

        #expect(value.data == Data([1]))
    }
}
