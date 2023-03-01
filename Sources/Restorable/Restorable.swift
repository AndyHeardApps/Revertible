import Foundation

protocol Restorable {
    
    // MARK: - Associated types
    associatedtype Restoration: ChangeRestoration<Self>
    
    // MARK: - Functions
    @RestorationBuilder
    func restoration(toPrevious previous: Self) -> Restoration?
}

// MARK: - Mapped restoration
extension Restorable {
    
    func restoration<Value: Restorable>(
        withPrevious previous: Self,
        at keyPath: WritableKeyPath<Self, Value>
    ) -> (any ChangeRestoration<Self>)? {

        let oldValue = previous[keyPath: keyPath]
        let currentValue = self[keyPath: keyPath]

        let restoration = currentValue.restoration(toPrevious: oldValue)
        let mappedRestoration = restoration?.mapped(to: keyPath)

        return mappedRestoration
    }
}

struct TestID: Identifiable, Hashable, Restorable {
    
    let id = UUID()
    var int = 99
    
    func restoration(toPrevious previous: TestID) -> (some ChangeRestoration<Self>)? {
        
        restoration(withPrevious: previous, at: \.int)
    }
}




struct Test: Hashable, Restorable, Identifiable {
    
    let id = UUID()
    var int = 9
    var double = 2.2
    var string = "One"
    var array = [TestID(), TestID(), TestID()]
    var set = Set([TestID(), TestID(), TestID()])
    var dictionary = [1 : TestID(), 2 : TestID(), 3 : TestID()]
    
    func restoration(toPrevious previous: Test) -> (some ChangeRestoration<Self>)? {
        
        restoration(withPrevious: previous, at: \.int)
        restoration(withPrevious: previous, at: \.double)
        restoration(withPrevious: previous, at: \.string)
        restoration(withPrevious: previous, at: \.array)
        restoration(withPrevious: previous, at: \.set)
        restoration(withPrevious: previous, at: \.dictionary)
    }
}







extension Test {
    
    mutating func alter() {
        
        int = 32
        double += 99
        string = string.uppercased()
        
        array.move(fromOffsets: IndexSet(integer: 0), toOffset: 3)
        array.remove(at: 0)
        array.append(TestID(int: 28365))
        array.append(TestID(int: 25))
        array.remove(at: 0)
        
        set.removeFirst()
        set.insert(TestID(int: 62))
        set.insert(TestID(int: 11))
        set.removeFirst()

        dictionary[4] = TestID(int: 0)
        dictionary[3]?.int = 77
        let moved = dictionary.removeValue(forKey: 3)
        dictionary[32] = moved
        dictionary[1] = TestID(int: 565)
        dictionary[2] = nil
        dictionary[9] = TestID(int: 0)
    }
}

struct SuperTest: Equatable, Restorable {
    
    var basic = Test()
    var array = [Test(), Test()]
    var set = Set([Test(), Test()])
    var dictionary = [1 : Test(), 2 : Test()]
    
    
    func restoration(toPrevious previous: SuperTest) -> (some ChangeRestoration<Self>)? {
        
        restoration(withPrevious: previous, at: \.basic)
        restoration(withPrevious: previous, at: \.array)
        restoration(withPrevious: previous, at: \.set)
        restoration(withPrevious: previous, at: \.dictionary)
    }
    
    mutating func alter() {
        
        basic.alter()
        array[0].alter()
        var a = set.removeFirst()
        a.alter()
        set.insert(a)
        dictionary[1]?.alter()
    }
}

func testDiff() {
    
    var test = SuperTest()
    let original = test
    test.alter()
    
    let restoration = test.restoration(toPrevious: original)
    restoration?.restore(&test)

    assert(test == original)
    print(test)
}
