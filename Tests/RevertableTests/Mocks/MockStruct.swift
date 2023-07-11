import Foundation
import Revertable

struct MockStruct: Identifiable {
    
    // MARK: - Properties
    let id: Int
    var int: Int
    var string: String
    var data: Data
    var identifiableValueArray: [MockStruct]
    var identifiableReferenceArray: [MockClass]
    var identifiableValueDictionary: [Int : MockStruct]
    var identifiableReferenceDictionary: [Int : MockClass]
    var equatableSet: Set<Int>

    // MARK: - Initialiser
    init(
        id: Int = 0,
        int: Int = 0,
        string: String = "abcd",
        data: Data = Data([0, 1, 2, 3]),
        identifiableValueArray: [MockStruct] = [],
        identifiableReferenceArray: [MockClass] = [],
        identifiableValueDictionary: [Int : MockStruct] = [:],
        identifiableReferenceDictionary: [Int : MockClass] = [:],
        equatableSet: Set<Int> = [0, 1, 2, 3]
    ) {
        
        self.id = id
        self.int = int
        self.string = string
        self.data = data
        self.identifiableValueArray = identifiableValueArray
        self.identifiableReferenceArray = identifiableReferenceArray
        self.identifiableValueDictionary = identifiableValueDictionary
        self.identifiableReferenceDictionary = identifiableReferenceDictionary
        self.equatableSet = equatableSet
    }
}

// MARK: - Versionable
extension MockStruct: Versionable {
    
    func addReversions(into reverter: inout some Reverter<Self>) {
        
        reverter.appendReversion(at: \.int)
        reverter.appendReversion(at: \.string)
        reverter.appendReversion(at: \.data)
        reverter.appendReversion(at: \.identifiableValueArray)
        reverter.appendReversion(at: \.identifiableReferenceArray)
        reverter.appendReversion(at: \.identifiableValueDictionary)
        reverter.appendReversion(at: \.identifiableReferenceDictionary)
        reverter.appendReversion(at: \.equatableSet)
    }
    
    static func == (lhs: MockStruct, rhs: MockStruct) -> Bool {
        
        lhs.id == rhs.id &&
        lhs.int == rhs.int &&
        lhs.string == rhs.string &&
        lhs.data == rhs.data &&
        lhs.identifiableValueArray == rhs.identifiableValueArray &&
        lhs.identifiableReferenceArray == rhs.identifiableReferenceArray &&
        lhs.identifiableValueDictionary == rhs.identifiableValueDictionary &&
        lhs.identifiableReferenceDictionary == rhs.identifiableReferenceDictionary &&
        lhs.equatableSet == rhs.equatableSet
    }
    
    func hash(into hasher: inout Hasher) {

        hasher.combine(id)
        hasher.combine(int)
        hasher.combine(string)
        hasher.combine(data)
        hasher.combine(identifiableValueArray)
        hasher.combine(identifiableReferenceArray)
        hasher.combine(identifiableValueDictionary)
        hasher.combine(identifiableReferenceDictionary)
        hasher.combine(equatableSet)
    }
}
