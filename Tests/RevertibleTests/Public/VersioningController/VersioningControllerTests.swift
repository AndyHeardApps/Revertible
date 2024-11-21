import Foundation
import Testing
import Revertible

@Suite("Versioning controller")
struct VersioningControllerTests {}

// MARK: - Tests
extension VersioningControllerTests {

    @Suite("In place")
    struct InPlace {

        @Test("Single reversion")
        func singleReversion() throws {

            var mockStruct = MockStruct()
            let originalValue = mockStruct

            let versioningController = VersioningController(mockStruct)

            #expect(versioningController.hasUndo == false)
            #expect(versioningController.hasRedo == false)

            mockStruct.string = UUID().uuidString

            versioningController.append(mockStruct)

            #expect(versioningController.hasUndo == true)
            #expect(versioningController.hasRedo == false)
            #expect(originalValue != mockStruct)

            mockStruct = try versioningController.undo()

            #expect(versioningController.hasUndo == false)
            #expect(versioningController.hasRedo == true)
            #expect(originalValue == mockStruct)

            mockStruct = try versioningController.redo()

            #expect(versioningController.hasUndo == true)
            #expect(versioningController.hasRedo == false)
            #expect(originalValue != mockStruct)
        }

        @Test("Multiple reversions")
        func multipleReversions() throws {

            var mockStruct = MockStruct()

            let versioningController = VersioningController(mockStruct)

            #expect(versioningController.hasUndo == false)
            #expect(versioningController.hasRedo == false)

            let previousValue1 = mockStruct
            mockStruct.string = UUID().uuidString

            versioningController.append(mockStruct)

            let previousValue2 = mockStruct
            mockStruct.string = UUID().uuidString

            versioningController.append(mockStruct)

            #expect(versioningController.hasUndo == true)
            #expect(versioningController.hasRedo == false)
            #expect(previousValue1 != mockStruct)
            #expect(previousValue2 != mockStruct)

            mockStruct = try versioningController.undo()

            #expect(versioningController.hasUndo == true)
            #expect(versioningController.hasRedo == true)
            #expect(previousValue1 != mockStruct)
            #expect(previousValue2 == mockStruct)

            mockStruct = try versioningController.undo()

            #expect(versioningController.hasUndo == false)
            #expect(versioningController.hasRedo == true)
            #expect(previousValue1 == mockStruct)
            #expect(previousValue2 != mockStruct)

            mockStruct = try versioningController.redo()

            #expect(versioningController.hasUndo == true)
            #expect(versioningController.hasRedo == true)
            #expect(previousValue1 != mockStruct)
            #expect(previousValue2 == mockStruct)

            mockStruct = try versioningController.redo()

            #expect(versioningController.hasUndo == true)
            #expect(versioningController.hasRedo == false)
            #expect(previousValue1 != mockStruct)
            #expect(previousValue2 != mockStruct)
        }

        @Test("No reversions")
        func noReversions() throws {

            var mockStruct = MockStruct()
            let originalValue = mockStruct

            let versioningController = VersioningController(mockStruct)

            mockStruct = try versioningController.undo()
            #expect(mockStruct == originalValue)
            mockStruct = try versioningController.redo()
            #expect(mockStruct == originalValue)
        }
    }
}

extension VersioningControllerTests {
    
    @Suite("Value root value key path")
    struct ValueRootValueKeyPath {

        @Test("Single reversion")
        func singleReversion() throws {

            var mockStruct = MockStruct(identifiableValueArray: [.init()])
            let originalValue = mockStruct

            let versioningController = VersioningController(
                on: mockStruct,
                at: \.identifiableValueArray[0]
            )

            #expect(versioningController.hasUndo == false)
            #expect(versioningController.hasRedo == false)

            mockStruct.identifiableValueArray[0].string = UUID().uuidString

            versioningController.append(mockStruct.identifiableValueArray[0])

            #expect(versioningController.hasUndo == true)
            #expect(versioningController.hasRedo == false)
            #expect(originalValue != mockStruct)

            try versioningController.undo(&mockStruct.identifiableValueArray[0])

            #expect(versioningController.hasUndo == false)
            #expect(versioningController.hasRedo == true)
            #expect(originalValue == mockStruct)

            try versioningController.redo(&mockStruct.identifiableValueArray[0])

            #expect(versioningController.hasUndo == true)
            #expect(versioningController.hasRedo == false)
            #expect(originalValue != mockStruct)
        }

        @Test("Multiple reversions")
        func multipleReversions() throws {

            var mockStruct = MockStruct(identifiableValueArray: [.init()])

            let versioningController = VersioningController(
                on: mockStruct,
                at: \.identifiableValueArray[0]
            )

            #expect(versioningController.hasUndo == false)
            #expect(versioningController.hasRedo == false)

            let previousValue1 = mockStruct
            mockStruct.identifiableValueArray[0].string = UUID().uuidString

            versioningController.append(mockStruct.identifiableValueArray[0])

            let previousValue2 = mockStruct
            mockStruct.identifiableValueArray[0].string = UUID().uuidString

            versioningController.append(mockStruct.identifiableValueArray[0])

            #expect(versioningController.hasUndo == true)
            #expect(versioningController.hasRedo == false)
            #expect(previousValue1 != mockStruct)
            #expect(previousValue2 != mockStruct)

            try versioningController.undo(&mockStruct.identifiableValueArray[0])

            #expect(versioningController.hasUndo == true)
            #expect(versioningController.hasRedo == true)
            #expect(previousValue1 != mockStruct)
            #expect(previousValue2 == mockStruct)

            try versioningController.undo(&mockStruct.identifiableValueArray[0])

            #expect(versioningController.hasUndo == false)
            #expect(versioningController.hasRedo == true)
            #expect(previousValue1 == mockStruct)
            #expect(previousValue2 != mockStruct)

            try versioningController.redo(&mockStruct.identifiableValueArray[0])

            #expect(versioningController.hasUndo == true)
            #expect(versioningController.hasRedo == true)
            #expect(previousValue1 != mockStruct)
            #expect(previousValue2 == mockStruct)

            try versioningController.redo(&mockStruct.identifiableValueArray[0])

            #expect(versioningController.hasUndo == true)
            #expect(versioningController.hasRedo == false)
            #expect(previousValue1 != mockStruct)
            #expect(previousValue2 != mockStruct)
        }

        @Test("No reversions")
        func noReversions() throws {

            var mockStruct = MockStruct(identifiableValueArray: [.init()])
            let originalValue = mockStruct

            let versioningController = VersioningController(
                on: mockStruct,
                at: \.identifiableValueArray[0]
            )

            mockStruct.identifiableValueArray[0] = try versioningController.undo()
            #expect(mockStruct == originalValue)
            mockStruct.identifiableValueArray[0] = try versioningController.redo()
            #expect(mockStruct == originalValue)
        }
    }
}

extension VersioningControllerTests {

    @Suite("Reference root value key path")
    struct ReferenceRootValueKeyPath {

        @Test("Single reversion")
        func singleReversion() throws {

            let mockClass = MockClass(identifiableValueArray: [.init()])
            let originalValue = mockClass.identifiableValueArray[0]

            let versioningController = VersioningController(
                on: mockClass,
                at: \.identifiableValueArray[0]
            )

            #expect(versioningController.hasUndo == false)
            #expect(versioningController.hasRedo == false)

            mockClass.identifiableValueArray[0].string = UUID().uuidString

            versioningController.append(root: mockClass)

            #expect(versioningController.hasUndo == true)
            #expect(versioningController.hasRedo == false)
            #expect(originalValue != mockClass.identifiableValueArray[0])

            try versioningController.undo()

            #expect(versioningController.hasUndo == false)
            #expect(versioningController.hasRedo == true)
            #expect(originalValue == mockClass.identifiableValueArray[0])

            try versioningController.redo()

            #expect(versioningController.hasUndo == true)
            #expect(versioningController.hasRedo == false)
            #expect(originalValue != mockClass.identifiableValueArray[0])
        }

        @Test("Multiple reversions")
        func multipleReversions() throws {

            let mockClass = MockClass(identifiableValueArray: [.init()])

            let versioningController = VersioningController(
                on: mockClass,
                at: \.identifiableValueArray[0]
            )

            #expect(versioningController.hasUndo == false)
            #expect(versioningController.hasRedo == false)

            let previousValue1 = mockClass.identifiableValueArray[0]
            mockClass.identifiableValueArray[0].string = UUID().uuidString

            versioningController.append(mockClass.identifiableValueArray[0])

            let previousValue2 = mockClass.identifiableValueArray[0]
            mockClass.identifiableValueArray[0].string = UUID().uuidString

            versioningController.append(root: mockClass)

            #expect(versioningController.hasUndo == true)
            #expect(versioningController.hasRedo == false)
            #expect(previousValue1 != mockClass.identifiableValueArray[0])
            #expect(previousValue2 != mockClass.identifiableValueArray[0])

            try versioningController.undo()

            #expect(versioningController.hasUndo == true)
            #expect(versioningController.hasRedo == true)
            #expect(previousValue1 != mockClass.identifiableValueArray[0])
            #expect(previousValue2 == mockClass.identifiableValueArray[0])

            try versioningController.undo()

            #expect(versioningController.hasUndo == false)
            #expect(versioningController.hasRedo == true)
            #expect(previousValue1 == mockClass.identifiableValueArray[0])
            #expect(previousValue2 != mockClass.identifiableValueArray[0])

            try versioningController.redo()

            #expect(versioningController.hasUndo == true)
            #expect(versioningController.hasRedo == true)
            #expect(previousValue1 != mockClass.identifiableValueArray[0])
            #expect(previousValue2 == mockClass.identifiableValueArray[0])

            try versioningController.redo(&mockClass.identifiableValueArray[0])

            #expect(versioningController.hasUndo == true)
            #expect(versioningController.hasRedo == false)
            #expect(previousValue1 != mockClass.identifiableValueArray[0])
            #expect(previousValue2 != mockClass.identifiableValueArray[0])
        }

        @Test("No reversions")
        func noReversions() throws {

            let mockClass = MockClass(identifiableValueArray: [.init()])
            let originalValue = mockClass.identifiableValueArray[0]

            let versioningController = VersioningController(
                on: mockClass,
                at: \.identifiableValueArray[0]
            )

            mockClass.identifiableValueArray[0] = try versioningController.undo()
            #expect(originalValue == mockClass.identifiableValueArray[0])
            mockClass.identifiableValueArray[0] = try versioningController.redo()
            #expect(originalValue == mockClass.identifiableValueArray[0])
        }

        @Test("Weakly references root")
        func weaklyReferencesRoot() throws {

            class Mock: @unchecked Sendable {
                var value = MockStruct()
            }

            var mockClass: Mock? = Mock()
            weak var weakReference = mockClass

            #expect(weakReference != nil)

            mockClass?.value.string = UUID().uuidString

            let versioningController = VersioningController(
                on: mockClass!,
                at: \.value
            )

            versioningController.append(root: mockClass!)

            mockClass = nil
            #expect(weakReference == nil)

            try versioningController.undo()
            try versioningController.redo()
        }
    }

    @Test("Push and pop scopes")
    func pushAndPopScopes() throws {

        var mockStruct = MockStruct()
        let versioningController = VersioningController(mockStruct)

        #expect(versioningController.hasUndo == false)
        #expect(versioningController.hasRedo == false)

        mockStruct.int = 1
        versioningController.append(mockStruct)

        #expect(versioningController.hasUndo == true)
        #expect(versioningController.hasRedo == false)

        versioningController.pushNewScope()

        #expect(versioningController.hasUndo == false)
        #expect(versioningController.hasRedo == false)

        mockStruct.int = 2
        versioningController.append(mockStruct)

        #expect(versioningController.hasUndo == true)
        #expect(versioningController.hasRedo == false)

        mockStruct.int = 3
        versioningController.append(mockStruct)

        #expect(versioningController.hasUndo == true)
        #expect(versioningController.hasRedo == false)

        mockStruct = try versioningController.undoAndPopCurrentScope()

        #expect(versioningController.hasUndo == true)
        #expect(versioningController.hasRedo == false)

        mockStruct = try versioningController.undo()

        #expect(versioningController.hasUndo == false)
        #expect(versioningController.hasRedo == true)
        #expect(mockStruct.int == 0)

        mockStruct.int = 2

        versioningController.append(mockStruct)
        versioningController.pushNewScope()
        mockStruct.int = 3
        versioningController.append(mockStruct)
        mockStruct.string = "123"
        versioningController.append(mockStruct)

        try versioningController.popCurrentScope()

        #expect(versioningController.hasUndo == true)
        #expect(versioningController.hasRedo == false)
        #expect(mockStruct.int == 3)
        #expect(mockStruct.string == "123")

        try versioningController.undo(&mockStruct)
        #expect(versioningController.hasUndo == true)
        #expect(versioningController.hasRedo == true)
        #expect(mockStruct.int == 2)
        #expect(mockStruct.string == "abcd")
    }

    @Test("Tags")
    func tags() throws {

        enum Tag {
            case initial
            case modified
            case final
        }

        var mockStruct = MockStruct()
        let versioningController = VersioningController(mockStruct)
        versioningController.tagCurrentVersion(Tag.initial)

        mockStruct.int = 3
        mockStruct.string = "123"
        versioningController.append(mockStruct)

        mockStruct.int = 5
        mockStruct.string = "12345"
        versioningController.append(mockStruct, tag: Tag.modified)

        mockStruct.int = 9
        mockStruct.string = "123456789"
        versioningController.append(mockStruct)

        mockStruct.int = 10
        mockStruct.string = "1234567890"
        versioningController.append(mockStruct)
        versioningController.tagCurrentVersion(Tag.final)

        #expect(versioningController.hasUndo == true)
        #expect(versioningController.hasRedo == false)
        #expect(mockStruct.int == 10)
        #expect(mockStruct.string == "1234567890")

        try versioningController.undo(&mockStruct)
        #expect(versioningController.hasUndo == true)
        #expect(versioningController.hasRedo == true)
        #expect(mockStruct.int == 9)
        #expect(mockStruct.string == "123456789")

        mockStruct = try versioningController.undo(to: Tag.modified)
        #expect(versioningController.hasUndo == true)
        #expect(versioningController.hasRedo == true)
        #expect(mockStruct.int == 5)
        #expect(mockStruct.string == "12345")

        try versioningController.undo(&mockStruct, to: Tag.initial)
        #expect(versioningController.hasUndo == false)
        #expect(versioningController.hasRedo == true)
        #expect(mockStruct.int == 0)
        #expect(mockStruct.string == "abcd")

        mockStruct = try versioningController.redo(to: Tag.modified)
        #expect(versioningController.hasUndo == true)
        #expect(versioningController.hasRedo == true)
        #expect(mockStruct.int == 5)
        #expect(mockStruct.string == "12345")

        try versioningController.redo(&mockStruct, to: 0)
        #expect(versioningController.hasUndo == true)
        #expect(versioningController.hasRedo == true)
        #expect(mockStruct.int == 5)
        #expect(mockStruct.string == "12345")

        try versioningController.undo(&mockStruct, to: 1)
        #expect(versioningController.hasUndo == true)
        #expect(versioningController.hasRedo == true)
        #expect(mockStruct.int == 5)
        #expect(mockStruct.string == "12345")

        versioningController.pushNewScope()
        mockStruct.int = 9
        mockStruct.string = "123456789"
        versioningController.append(mockStruct)

        mockStruct.int = 10
        mockStruct.string = "1234567890"
        versioningController.append(mockStruct)
        versioningController.tagCurrentVersion(Tag.final)

        mockStruct = try versioningController.undo(to: Tag.modified)
        #expect(versioningController.hasUndo == false)
        #expect(versioningController.hasRedo == true)
        #expect(mockStruct.int == 5)
        #expect(mockStruct.string == "12345")

        mockStruct = try versioningController.redo(to: Tag.final)
        #expect(versioningController.hasUndo == true)
        #expect(versioningController.hasRedo == false)
        #expect(mockStruct.int == 10)
        #expect(mockStruct.string == "1234567890")

        try versioningController.popCurrentScope()

        #expect(versioningController.hasUndo == true)
        #expect(versioningController.hasRedo == false)
    }

    @Test("Inspect tags")
    func inspectTags() throws {

        enum Tag {
            case initial
            case modified
            case final
        }

        var mockStruct = MockStruct()
        let versioningController = VersioningController(mockStruct)
        versioningController.tagCurrentVersion(Tag.initial)

        #expect(try #require(versioningController.tags(inScopeLevel: versioningController.scopeLevel)) == ([Tag.initial], []))

        mockStruct.int = 5
        versioningController.append(mockStruct)

        mockStruct.string = "12345"
        versioningController.append(mockStruct, tag: Tag.modified)

        #expect(try #require(versioningController.tags(inScopeLevel: versioningController.scopeLevel)) == ([Tag.initial, nil, Tag.modified], []))

        mockStruct.int = 7
        versioningController.append(mockStruct)

        mockStruct.string = "1234567"
        versioningController.append(mockStruct, tag: Tag.modified)

        #expect(try #require(versioningController.tags(inScopeLevel: versioningController.scopeLevel)) == ([Tag.initial, nil, nil, nil, Tag.modified], []))

        mockStruct.int = 9
        versioningController.append(mockStruct)
        versioningController.tagCurrentVersion(Tag.final)

        mockStruct = try versioningController.undo(to: Tag.modified)
        #expect(try #require(versioningController.tags(inScopeLevel: versioningController.scopeLevel)) == ([Tag.initial, nil, nil, nil, Tag.modified], [Tag.final]))
    }

    @Test("Observable deallocates")
    func observableDeallocates() {

        var model: ObservableModel? = ObservableModel()
        weak var controller = model?.controller
        model?.mockStruct.int = 5

        #expect(controller != nil)
        model = nil
        #expect(controller == nil)
    }

    @Observable
    fileprivate final class ObservableModel: @unchecked Sendable {

        @ObservationIgnored
        private(set) lazy var controller: VersioningController<ObservableModel, MockStruct>? = .init(
            on: self,
            at: \.mockStruct,
            using: _$observationRegistrar
        )

        var mockStruct = MockStruct()
    }

    @Test("Observable object deallocates")
    func observableObjectDeallocates() {

        var model: ObservableObjectModel? = ObservableObjectModel()
        weak var controller = model?.controller
        model?.mockStruct.int = 5

        #expect(controller != nil)
        model = nil
        #expect(controller == nil)
    }

    fileprivate final class ObservableObjectModel: ObservableObject, @unchecked Sendable {

        private(set) lazy var controller: VersioningController<ObservableObjectModel, MockStruct>? = .init(
            on: self,
            at: \.mockStruct
        )

        @Published var mockStruct = MockStruct()
    }
}
