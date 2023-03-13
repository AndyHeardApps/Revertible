@testable import Revertable

final class MockValueReversion<Root> {
    
    // MARK: - Properties
    private(set) var revertedObject: Root?
    private(set) var mappedCalled = false
}

// MARK: - Value reversion
extension MockValueReversion: ValueReversion {
    
    func revert(_ object: inout Root) {
        
        revertedObject = object
    }
    
    func mapped<NewRoot>(to keyPath: WritableKeyPath<NewRoot, Root>) -> AnyValueReversion<NewRoot> {
        
        mappedCalled = true
        return MockValueReversion<NewRoot>()
            .erasedToAnyValueReversion()
    }
}
