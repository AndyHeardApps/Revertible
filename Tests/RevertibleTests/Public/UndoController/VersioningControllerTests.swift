import Foundation
import Testing
import Revertible

@Suite("Versioning controller")
struct VersioningControllerTests {}

// MARK: - Tests
extension VersioningControllerTests {

    @Test("Single Reversion")
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
    
//    @Test
    func versioningController_willUndoAndRedo_multipleRevertibleActions() throws {
//                
//        let versioningController = VersioningController()
//
//        #expect(versioningController.hasUndo == false)
//        #expect(versioningController.hasRedo == false)
//        
//        let previousValue1 = mockStruct!
//        mockStruct.string = UUID().uuidString
//        
//        versioningController.append(changesOn: self, at: \.mockStruct, previousValue: previousValue1)
//
//        let previousValue2 = mockStruct!
//        mockStruct.string = UUID().uuidString
//
//        versioningController.append(changesOn: self, at: \.mockStruct, previousValue: previousValue2)
//        
//        #expect(versioningController.hasUndo == true)
//        #expect(versioningController.hasRedo == false)
//        XCTAssertNotEqual(previousValue1, mockStruct)
//        XCTAssertNotEqual(previousValue2, mockStruct)
//
//        try versioningController.undo()
//        
//        #expect(versioningController.hasUndo == true)
//        #expect(versioningController.hasRedo == true)
//        XCTAssertNotEqual(previousValue1, mockStruct)
//        #expect(previousValue2 == mockStruct)
//        
//        try versioningController.undo()
//        
//        #expect(versioningController.hasUndo == false)
//        #expect(versioningController.hasRedo == true)
//        #expect(previousValue1 == mockStruct)
//        XCTAssertNotEqual(previousValue2, mockStruct)
//
//        try versioningController.redo()
//        
//        #expect(versioningController.hasUndo == true)
//        #expect(versioningController.hasRedo == true)
//        XCTAssertNotEqual(previousValue1, mockStruct)
//        #expect(previousValue2 == mockStruct)
//        
//        try versioningController.redo()
//        
//        #expect(versioningController.hasUndo == true)
//        #expect(versioningController.hasRedo == false)
//        XCTAssertNotEqual(previousValue1, mockStruct)
//        XCTAssertNotEqual(previousValue2, mockStruct)
//    }
//    
//    @Test
    func versioningController_willUndoAndRedo_multipleClosureActions() throws {
//        
//        let versioningController = VersioningController()
//
//        #expect(versioningController.hasUndo == false)
//        #expect(versioningController.hasRedo == false)
//
//        var value = 0
//        
//        versioningController.append(
//            undo: { value = 0 },
//            redo: { value = 1 }
//        )
//        value = 1
//        
//        versioningController.append(
//            undo: { value = 1 },
//            redo: { value = 2 }
//        )
//        value = 2
//        
//        #expect(versioningController.hasUndo == true)
//        #expect(versioningController.hasRedo == false)
//        #expect(value == 2)
//
//        try versioningController.undo()
//        
//        #expect(versioningController.hasUndo == true)
//        #expect(versioningController.hasRedo == true)
//        #expect(value == 1)
//        
//        try versioningController.undo()
//        
//        #expect(versioningController.hasUndo == false)
//        #expect(versioningController.hasRedo == true)
//        #expect(value == 0)
//
//        try versioningController.redo()
//        
//        #expect(versioningController.hasUndo == true)
//        #expect(versioningController.hasRedo == true)
//        #expect(value == 1)
//        
//        try versioningController.redo()
//        
//        #expect(versioningController.hasUndo == true)
//        #expect(versioningController.hasRedo == false)
//        #expect(value == 2)
//    }
//    
//    @Test
    func versioningController_undoAndRedo_willDoNothingWithNoChangesRegistered() throws {
//        
//        let versioningController = VersioningController()
//
//        try versioningController.undo()
//        try versioningController.redo()
//    }
//    
//    @Test
    func versioningController_willWeaklyReferenceRevertibleRoots() throws {
//        
//        class Mock {
//            var value = MockStruct()
//        }
//        
//        var mockClass: Mock? = Mock()
//        weak var weakReference = mockClass
//        
//        XCTAssertNotNil(weakReference)
//        
//        let initialValue = mockClass!.value
//        mockClass?.value.string = UUID().uuidString
//        
//        let versioningController = VersioningController()
//
//        versioningController.append(changesOn: mockClass!, at: \.value, previousValue: initialValue)
//        
//        mockClass = nil
//        #expect(weakReference == nil)
//        
//        try versioningController.undo()
//        try versioningController.redo()
//    }
//    
//    @Test
    func versioningController_willPushAndPopScopesCorrectly() throws {
//        
//        let versioningController = VersioningController()
//
//        #expect(versioningController.hasUndo == false)
//        #expect(versioningController.hasRedo == false)
//        
//        var previousValue = mockStruct!
//        mockStruct.int = 1
//        versioningController.append(changesOn: self, at: \.mockStruct, previousValue: previousValue)
//        
//        #expect(versioningController.hasUndo == true)
//        #expect(versioningController.hasRedo == false)
//        
//        versioningController.pushNewScope()
//        
//        #expect(versioningController.hasUndo == false)
//        #expect(versioningController.hasRedo == false)
//
//        previousValue = mockStruct
//        mockStruct.int = 2
//        versioningController.append(changesOn: self, at: \.mockStruct, previousValue: previousValue)
//
//        #expect(versioningController.hasUndo == true)
//        #expect(versioningController.hasRedo == false)
//
//        previousValue = mockStruct
//        mockStruct.int = 3
//        versioningController.append(changesOn: self, at: \.mockStruct, previousValue: previousValue)
//
//        #expect(versioningController.hasUndo == true)
//        #expect(versioningController.hasRedo == false)
//
//        versioningController.discardCurrentScope()
//        mockStruct.int = 1
//        
//        #expect(versioningController.hasUndo == true)
//        #expect(versioningController.hasRedo == false)
//        
//        try versioningController.undo()
//        
//        #expect(versioningController.hasUndo == false)
//        #expect(versioningController.hasRedo == true)
//        #expect(mockStruct.int == 0)
//    }
}
