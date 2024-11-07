import XCTest
import Revertible

final class UndoControllerTests: XCTestCase {
    
    // MARK: - Properties
    private var mockStruct: MockStruct!
}

// MARK: - Setup
extension UndoControllerTests {
    
    override func setUp() {
        super.setUp()
        
        self.mockStruct = .init()
    }
    
    override func tearDown() {
        super.tearDown()
        
        self.mockStruct = nil
    }
}

// MARK: - Tests
extension UndoControllerTests {
    
    func testUndoController_willUndoAndRedo_singleRevertibleAction() throws {
                
        let undoController = UndoController()

        XCTAssertFalse(undoController.hasUndo)
        XCTAssertFalse(undoController.hasRedo)
        
        let previousValue = mockStruct!
        mockStruct.string = UUID().uuidString

        undoController.append(changesOn: self, at: \.mockStruct, previousValue: previousValue)
        
        XCTAssertTrue(undoController.hasUndo)
        XCTAssertFalse(undoController.hasRedo)
        XCTAssertNotEqual(previousValue, mockStruct)
        
        try undoController.undo()
        
        XCTAssertFalse(undoController.hasUndo)
        XCTAssertTrue(undoController.hasRedo)
        XCTAssertEqual(previousValue, mockStruct)
        
        try undoController.redo()
        
        XCTAssertTrue(undoController.hasUndo)
        XCTAssertFalse(undoController.hasRedo)
        XCTAssertNotEqual(previousValue, mockStruct)
    }
    
    func testUndoController_willUndoAndRedo_multipleRevertibleActions() throws {
                
        let undoController = UndoController()

        XCTAssertFalse(undoController.hasUndo)
        XCTAssertFalse(undoController.hasRedo)
        
        let previousValue1 = mockStruct!
        mockStruct.string = UUID().uuidString
        
        undoController.append(changesOn: self, at: \.mockStruct, previousValue: previousValue1)

        let previousValue2 = mockStruct!
        mockStruct.string = UUID().uuidString

        undoController.append(changesOn: self, at: \.mockStruct, previousValue: previousValue2)
        
        XCTAssertTrue(undoController.hasUndo)
        XCTAssertFalse(undoController.hasRedo)
        XCTAssertNotEqual(previousValue1, mockStruct)
        XCTAssertNotEqual(previousValue2, mockStruct)

        try undoController.undo()
        
        XCTAssertTrue(undoController.hasUndo)
        XCTAssertTrue(undoController.hasRedo)
        XCTAssertNotEqual(previousValue1, mockStruct)
        XCTAssertEqual(previousValue2, mockStruct)
        
        try undoController.undo()
        
        XCTAssertFalse(undoController.hasUndo)
        XCTAssertTrue(undoController.hasRedo)
        XCTAssertEqual(previousValue1, mockStruct)
        XCTAssertNotEqual(previousValue2, mockStruct)

        try undoController.redo()
        
        XCTAssertTrue(undoController.hasUndo)
        XCTAssertTrue(undoController.hasRedo)
        XCTAssertNotEqual(previousValue1, mockStruct)
        XCTAssertEqual(previousValue2, mockStruct)
        
        try undoController.redo()
        
        XCTAssertTrue(undoController.hasUndo)
        XCTAssertFalse(undoController.hasRedo)
        XCTAssertNotEqual(previousValue1, mockStruct)
        XCTAssertNotEqual(previousValue2, mockStruct)
    }
    
    func testUndoController_willUndoAndRedo_multipleClosureActions() throws {
        
        let undoController = UndoController()

        XCTAssertFalse(undoController.hasUndo)
        XCTAssertFalse(undoController.hasRedo)

        var value = 0
        
        undoController.append(
            undo: { value = 0 },
            redo: { value = 1 }
        )
        value = 1
        
        undoController.append(
            undo: { value = 1 },
            redo: { value = 2 }
        )
        value = 2
        
        XCTAssertTrue(undoController.hasUndo)
        XCTAssertFalse(undoController.hasRedo)
        XCTAssertEqual(value, 2)

        try undoController.undo()
        
        XCTAssertTrue(undoController.hasUndo)
        XCTAssertTrue(undoController.hasRedo)
        XCTAssertEqual(value, 1)
        
        try undoController.undo()
        
        XCTAssertFalse(undoController.hasUndo)
        XCTAssertTrue(undoController.hasRedo)
        XCTAssertEqual(value, 0)

        try undoController.redo()
        
        XCTAssertTrue(undoController.hasUndo)
        XCTAssertTrue(undoController.hasRedo)
        XCTAssertEqual(value, 1)
        
        try undoController.redo()
        
        XCTAssertTrue(undoController.hasUndo)
        XCTAssertFalse(undoController.hasRedo)
        XCTAssertEqual(value, 2)
    }
    
    func testUndoController_undoAndRedo_willDoNothingWithNoChangesRegistered() throws {
        
        let undoController = UndoController()

        try undoController.undo()
        try undoController.redo()
    }
    
    func testUndoController_willWeaklyReferenceRevertibleRoots() throws {
        
        class Mock {
            var value = MockStruct()
        }
        
        var mockClass: Mock? = Mock()
        weak var weakReference = mockClass
        
        XCTAssertNotNil(weakReference)
        
        let initialValue = mockClass!.value
        mockClass?.value.string = UUID().uuidString
        
        let undoController = UndoController()

        undoController.append(changesOn: mockClass!, at: \.value, previousValue: initialValue)
        
        mockClass = nil
        XCTAssertNil(weakReference)
        
        try undoController.undo()
        try undoController.redo()
    }
    
    func testUndoController_willPushAndPopScopesCorrectly() throws {
        
        let undoController = UndoController()

        XCTAssertFalse(undoController.hasUndo)
        XCTAssertFalse(undoController.hasRedo)
        
        var previousValue = mockStruct!
        mockStruct.int = 1
        undoController.append(changesOn: self, at: \.mockStruct, previousValue: previousValue)
        
        XCTAssertTrue(undoController.hasUndo)
        XCTAssertFalse(undoController.hasRedo)
        
        undoController.pushNewScope()
        
        XCTAssertFalse(undoController.hasUndo)
        XCTAssertFalse(undoController.hasRedo)

        previousValue = mockStruct
        mockStruct.int = 2
        undoController.append(changesOn: self, at: \.mockStruct, previousValue: previousValue)

        XCTAssertTrue(undoController.hasUndo)
        XCTAssertFalse(undoController.hasRedo)

        previousValue = mockStruct
        mockStruct.int = 3
        undoController.append(changesOn: self, at: \.mockStruct, previousValue: previousValue)

        XCTAssertTrue(undoController.hasUndo)
        XCTAssertFalse(undoController.hasRedo)

        undoController.discardCurrentScope()
        mockStruct.int = 1
        
        XCTAssertTrue(undoController.hasUndo)
        XCTAssertFalse(undoController.hasRedo)
        
        try undoController.undo()
        
        XCTAssertFalse(undoController.hasUndo)
        XCTAssertTrue(undoController.hasRedo)
        XCTAssertEqual(mockStruct.int, 0)
    }
}
