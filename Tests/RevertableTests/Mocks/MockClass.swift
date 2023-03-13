import Foundation
import Revertable

final class MockClass: Identifiable {
    
    // MARK: - Properties
    let id: Int
    var int: Int
    var string: String
    var data: Data
    var equatableArray: [Int]
    var identifiableValueArray: [MockStruct]
    var identifiableReferenceArray: [MockClass]
    var equatableDictionary: [Int : String]
    var identifiableValueDictionary: [Int : MockStruct]
    var identifiableReferenceDictionary: [Int : MockClass]
    var equatableSet: Set<Int>

    // MARK: - Initialiser
    init(
        id: Int = 0,
        int: Int = 0,
        string: String = "abcd",
        data: Data = Data([0, 1, 2, 3]),
        equatableArray: [Int] = [0, 1, 2, 3],
        identifiableValueArray: [MockStruct] = [],
        identifiableReferenceArray: [MockClass] = [],
        equatableDictionary: [Int : String] = [0 : "0", 1 : "1", 2 : "2", 3 : "3"],
        identifiableValueDictionary: [Int : MockStruct] = [:],
        identifiableReferenceDictionary: [Int : MockClass] = [:],
        equatableSet: Set<Int> = [0, 1, 2, 3]
    ) {
        
        self.id = id
        self.int = int
        self.string = string
        self.data = data
        self.equatableArray = equatableArray
        self.identifiableValueArray = identifiableValueArray
        self.identifiableReferenceArray = identifiableReferenceArray
        self.equatableDictionary = equatableDictionary
        self.identifiableValueDictionary = identifiableValueDictionary
        self.identifiableReferenceDictionary = identifiableReferenceDictionary
        self.equatableSet = equatableSet
    }
}

// MARK: - Revertable
extension MockClass: Revertable {
    
    func addReversions(into reverter: inout some Reverter<MockClass>) {

        reverter.appendReversion(at: \.int)
        reverter.appendReversion(at: \.string)
        reverter.appendReversion(at: \.data)
        reverter.appendReversion(at: \.equatableArray)
        reverter.appendReversion(at: \.identifiableValueArray)
        reverter.appendReversion(at: \.identifiableReferenceArray)
        reverter.appendReversion(at: \.equatableDictionary)
        reverter.appendReversion(at: \.identifiableValueDictionary)
        reverter.appendReversion(at: \.identifiableReferenceDictionary)
        reverter.appendReversion(at: \.equatableSet)
    }
    
    static func == (lhs: MockClass, rhs: MockClass) -> Bool {
        
        lhs.id == rhs.id &&
        lhs.int == rhs.int &&
        lhs.string == rhs.string &&
        lhs.data == rhs.data &&
        lhs.equatableArray == rhs.equatableArray &&
        lhs.identifiableValueArray == rhs.identifiableValueArray &&
        lhs.identifiableReferenceArray == rhs.identifiableReferenceArray &&
        lhs.equatableDictionary == rhs.equatableDictionary &&
        lhs.identifiableValueDictionary == rhs.identifiableValueDictionary &&
        lhs.identifiableReferenceDictionary == rhs.identifiableReferenceDictionary &&
        lhs.equatableSet == rhs.equatableSet
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(id)
        hasher.combine(int)
        hasher.combine(string)
        hasher.combine(data)
        hasher.combine(equatableArray)
        hasher.combine(identifiableValueArray)
        hasher.combine(identifiableReferenceArray)
        hasher.combine(equatableDictionary)
        hasher.combine(identifiableValueDictionary)
        hasher.combine(identifiableReferenceDictionary)
        hasher.combine(equatableSet)
    }
}

struct User: Revertable {

    var name: String
    var imageData: Data?

    func addReversions(into reverter: inout some Reverter<User>) {
        
        reverter.appendReversion(at: \.name)
        reverter.appendReversion(at: \.imageData)
    }
}
