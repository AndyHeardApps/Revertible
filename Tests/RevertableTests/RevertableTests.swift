import XCTest
import Revertable

final class RevertableTests: XCTestCase {
    
    func testExample() throws {

        var test = Test()
        let original = test
        
        test.string = "defg"
        test.int = 99
        test.data = "defghij".data(using: .utf8)!
        test.equatableArray = [6, 3, 4, 5]
        
        test.identifiableArray.remove(at: 0)
        test.identifiableArray[0].string = "cde"
        test.identifiableArray.append(.init(id: 3))
        test.identifiableArray.append(.init(id: 4))
        test.identifiableArray.append(test.identifiableArray.remove(at: 1))
        
        test.equatableDictionary = [0 : "d", 1 : "b", 3 : "c", 5 : "e"]
        
        test.identifiableDictionary.removeValue(forKey: 1)
        test.identifiableDictionary[0]?.string = "cde"
        test.identifiableDictionary[2] = MockIdentifiable(id: 3)
        test.identifiableDictionary[3] = MockIdentifiable(id: 4)
        test.identifiableDictionary[4] = MockIdentifiable(id: 5)

        let reversion = test.reversion(to: original)
        try reversion?.revert(&test)
        
        XCTAssertEqual(test, original)
    }
}

struct Test: Revertable {
    
    var int = 3
    var string = "abcd"
    var data = "abcdefg".data(using: .utf8)!
    var equatableArray = [1, 2, 3, 4]
    var identifiableArray = [MockIdentifiable(id: 0), MockIdentifiable(id: 1), MockIdentifiable(id: 2)]
    var equatableDictionary = [0 : "a", 1 : "b", 2 : "c"]
    var identifiableDictionary = [0 : MockIdentifiable(id: 0), 1 : MockIdentifiable(id: 1), 2 : MockIdentifiable(id: 2)]
    
    func addReversions(into reverter: inout some Reverter<Test>) {
        
        reverter.appendReversion(at: \.int)
        reverter.appendReversion(at: \.string)
        reverter.appendReversion(at: \.data)
        reverter.appendReversion(at: \.equatableArray)
        reverter.appendReversion(at: \.identifiableArray)
        reverter.appendReversion(at: \.equatableDictionary)
        reverter.appendReversion(at: \.identifiableDictionary)
    }
}

struct MockIdentifiable: Identifiable, Hashable, Revertable {
    
    let id: Int
    var string = "abc"
    
    func addReversions(into reverter: inout some Reverter<Self>) {
        
        reverter.appendReversion(at: \.string)
    }
}
