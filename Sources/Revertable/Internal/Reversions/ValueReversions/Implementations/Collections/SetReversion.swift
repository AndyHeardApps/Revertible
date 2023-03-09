
struct SetReversion<Root, Element: Hashable> {
    
    // MARK: - Properties
    private let action: Action
    private let keyPath: WritableKeyPath<Root, Set<Element>>

    // MARK: - Initialisers
    init(
        insert elements: Set<Element>,
        inSetAt keyPath: WritableKeyPath<Root, Set<Element>>
    ) {
        
        self.action = .insert(elements)
        self.keyPath = keyPath
    }
    
    init(
        remove elements: Set<Element>,
        fromSetAt keyPath: WritableKeyPath<Root, Set<Element>>
    ) {
        
        self.action = .remove(elements)
        self.keyPath = keyPath
    }
    
    private init(
        action: Action,
        keyPath: WritableKeyPath<Root, Set<Element>>
    ) {
        
        self.action = action
        self.keyPath = keyPath
    }
}

// MARK: - Value reversion
extension SetReversion: ValueReversion {
        
    func revert(_ object: inout Root) {
        
        switch action {
        case let .insert(elements):
            object[keyPath: keyPath].formUnion(elements)
            
        case let .remove(elements):
            object[keyPath: keyPath].subtract(elements)

        }
    }
    
    func mapped<NewRoot>(to keyPath: WritableKeyPath<NewRoot, Root>) -> AnyValueReversion<NewRoot> {
        
        SetReversion<NewRoot, Element>(
            action: .init(action),
            keyPath: keyPath.appending(path: self.keyPath)
        )
        .erasedToAnyValueReversion()
    }
}

// MARK: - Action
extension SetReversion {
    
    private enum Action {
        
        case insert(Set<Element>)
        case remove(Set<Element>)
        
        fileprivate init<OtherRoot>(_ other: SetReversion<OtherRoot, Element>.Action) {
        
            switch other {
            case let .insert(elements):
                self = .insert(elements)

            case let .remove(elements):
                self = .remove(elements)
                
            }
        }
    }
}
