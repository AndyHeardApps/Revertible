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
    
//    func testversioningController_willUndoAndRedo_multipleRevertibleActions() throws {
//                
//        let versioningController = VersioningController()
//
//        XCTAssertFalse(versioningController.hasUndo)
//        XCTAssertFalse(versioningController.hasRedo)
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
//        XCTAssertTrue(versioningController.hasUndo)
//        XCTAssertFalse(versioningController.hasRedo)
//        XCTAssertNotEqual(previousValue1, mockStruct)
//        XCTAssertNotEqual(previousValue2, mockStruct)
//
//        try versioningController.undo()
//        
//        XCTAssertTrue(versioningController.hasUndo)
//        XCTAssertTrue(versioningController.hasRedo)
//        XCTAssertNotEqual(previousValue1, mockStruct)
//        XCTAssertEqual(previousValue2, mockStruct)
//        
//        try versioningController.undo()
//        
//        XCTAssertFalse(versioningController.hasUndo)
//        XCTAssertTrue(versioningController.hasRedo)
//        XCTAssertEqual(previousValue1, mockStruct)
//        XCTAssertNotEqual(previousValue2, mockStruct)
//
//        try versioningController.redo()
//        
//        XCTAssertTrue(versioningController.hasUndo)
//        XCTAssertTrue(versioningController.hasRedo)
//        XCTAssertNotEqual(previousValue1, mockStruct)
//        XCTAssertEqual(previousValue2, mockStruct)
//        
//        try versioningController.redo()
//        
//        XCTAssertTrue(versioningController.hasUndo)
//        XCTAssertFalse(versioningController.hasRedo)
//        XCTAssertNotEqual(previousValue1, mockStruct)
//        XCTAssertNotEqual(previousValue2, mockStruct)
//    }
//    
//    func testversioningController_willUndoAndRedo_multipleClosureActions() throws {
//        
//        let versioningController = VersioningController()
//
//        XCTAssertFalse(versioningController.hasUndo)
//        XCTAssertFalse(versioningController.hasRedo)
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
//        XCTAssertTrue(versioningController.hasUndo)
//        XCTAssertFalse(versioningController.hasRedo)
//        XCTAssertEqual(value, 2)
//
//        try versioningController.undo()
//        
//        XCTAssertTrue(versioningController.hasUndo)
//        XCTAssertTrue(versioningController.hasRedo)
//        XCTAssertEqual(value, 1)
//        
//        try versioningController.undo()
//        
//        XCTAssertFalse(versioningController.hasUndo)
//        XCTAssertTrue(versioningController.hasRedo)
//        XCTAssertEqual(value, 0)
//
//        try versioningController.redo()
//        
//        XCTAssertTrue(versioningController.hasUndo)
//        XCTAssertTrue(versioningController.hasRedo)
//        XCTAssertEqual(value, 1)
//        
//        try versioningController.redo()
//        
//        XCTAssertTrue(versioningController.hasUndo)
//        XCTAssertFalse(versioningController.hasRedo)
//        XCTAssertEqual(value, 2)
//    }
//    
//    func testversioningController_undoAndRedo_willDoNothingWithNoChangesRegistered() throws {
//        
//        let versioningController = VersioningController()
//
//        try versioningController.undo()
//        try versioningController.redo()
//    }
//    
//    func testversioningController_willWeaklyReferenceRevertibleRoots() throws {
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
//        XCTAssertNil(weakReference)
//        
//        try versioningController.undo()
//        try versioningController.redo()
//    }
//    
//    func testversioningController_willPushAndPopScopesCorrectly() throws {
//        
//        let versioningController = VersioningController()
//
//        XCTAssertFalse(versioningController.hasUndo)
//        XCTAssertFalse(versioningController.hasRedo)
//        
//        var previousValue = mockStruct!
//        mockStruct.int = 1
//        versioningController.append(changesOn: self, at: \.mockStruct, previousValue: previousValue)
//        
//        XCTAssertTrue(versioningController.hasUndo)
//        XCTAssertFalse(versioningController.hasRedo)
//        
//        versioningController.pushNewScope()
//        
//        XCTAssertFalse(versioningController.hasUndo)
//        XCTAssertFalse(versioningController.hasRedo)
//
//        previousValue = mockStruct
//        mockStruct.int = 2
//        versioningController.append(changesOn: self, at: \.mockStruct, previousValue: previousValue)
//
//        XCTAssertTrue(versioningController.hasUndo)
//        XCTAssertFalse(versioningController.hasRedo)
//
//        previousValue = mockStruct
//        mockStruct.int = 3
//        versioningController.append(changesOn: self, at: \.mockStruct, previousValue: previousValue)
//
//        XCTAssertTrue(versioningController.hasUndo)
//        XCTAssertFalse(versioningController.hasRedo)
//
//        versioningController.discardCurrentScope()
//        mockStruct.int = 1
//        
//        XCTAssertTrue(versioningController.hasUndo)
//        XCTAssertFalse(versioningController.hasRedo)
//        
//        try versioningController.undo()
//        
//        XCTAssertFalse(versioningController.hasUndo)
//        XCTAssertTrue(versioningController.hasRedo)
//        XCTAssertEqual(mockStruct.int, 0)
//    }
}
