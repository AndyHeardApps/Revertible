import Foundation
import Testing
import Revertible

@Suite("Versioned")
struct VersionedTests {

    private struct Mock {
        @Versioned
        var value = MockStruct()
    }

    @Test("Single reversion")
    func singleReversion() throws {

        let mock = Mock()
        let originalValue = mock.value

        #expect(mock.$value.hasUndo == false)
        #expect(mock.$value.hasRedo == false)

        mock.value.string = UUID().uuidString

        #expect(mock.$value.hasUndo == true)
        #expect(mock.$value.hasRedo == false)
        #expect(originalValue != mock.value)

        try mock.$value.undo()

        #expect(mock.$value.hasUndo == false)
        #expect(mock.$value.hasRedo == true)
        #expect(originalValue == mock.value)

        try mock.$value.redo()

        #expect(mock.$value.hasUndo == true)
        #expect(mock.$value.hasRedo == false)
        #expect(originalValue != mock.value)
    }

    @Test("Multiple reversions")
    func multipleReversions() throws {

        let mock = Mock()

        #expect(mock.$value.hasUndo == false)
        #expect(mock.$value.hasRedo == false)

        let previousValue1 = mock.value
        mock.value.string = UUID().uuidString

        let previousValue2 = mock.value
        mock.value.string = UUID().uuidString

        #expect(mock.$value.hasUndo == true)
        #expect(mock.$value.hasRedo == false)
        #expect(previousValue1 != mock.value)
        #expect(previousValue2 != mock.value)

        try mock.$value.undo()

        #expect(mock.$value.hasUndo == true)
        #expect(mock.$value.hasRedo == true)
        #expect(previousValue1 != mock.value)
        #expect(previousValue2 == mock.value)

        try mock.$value.undo()

        #expect(mock.$value.hasUndo == false)
        #expect(mock.$value.hasRedo == true)
        #expect(previousValue1 == mock.value)
        #expect(previousValue2 != mock.value)

        try mock.$value.redo()

        #expect(mock.$value.hasUndo == true)
        #expect(mock.$value.hasRedo == true)
        #expect(previousValue1 != mock.value)
        #expect(previousValue2 == mock.value)

        try mock.$value.redo()

        #expect(mock.$value.hasUndo == true)
        #expect(mock.$value.hasRedo == false)
        #expect(previousValue1 != mock.value)
        #expect(previousValue2 != mock.value)
    }

    @Test("No reversions")
    func noReversions() throws {

        let mock = Mock()
        let originalValue = mock.value

        try mock.$value.undo()
        #expect(originalValue == mock.value)
        try mock.$value.redo()
        #expect(originalValue == mock.value)
    }
}
