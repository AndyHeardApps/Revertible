
struct SetReversion<Root, Element: Hashable> {
    
    // MARK: - Properties
    private let keyPath: WritableKeyPath<Root, Set<Element>>
    private let action: Action
    
    // MARK: - Initialisers
    init(insert elements: Set<Element>) where Root == Set<Element> {
        
        self.keyPath = \.self
        self.action = .insert(elements)
    }
    
    init(remove elements: Set<Element>) where Root == Set<Element> {
        
        self.keyPath = \.self
        self.action = .remove(elements)
    }
    
    private init(
        keyPath: WritableKeyPath<Root, Set<Element>>,
        action: Action
    ) {
        
        self.keyPath = keyPath
        self.action = action
    }

}

// MARK: - Value reversion
extension SetReversion: ValueReversion {
    
    typealias Mapped = SetReversion
    
    func revert(_ object: inout Root) {
        
        switch action {
        case let .insert(elements):
            object[keyPath: keyPath].formUnion(elements)
            
        case let .remove(elements):
            object[keyPath: keyPath].subtract(elements)

        }
    }
    
    func mapped<NewRoot>(to keyPath: WritableKeyPath<NewRoot, Root>) -> SetReversion<NewRoot, Element> {
        
        SetReversion<NewRoot, Element>(
            keyPath: keyPath.appending(path: self.keyPath),
            action: .init(action)
        )
    }
}

// MARK: - Action
extension SetReversion {
    
    private enum Action {
        
        case insert(Set<Element>)
        case remove(Set<Element>)
        
        init<OtherRoot>(_ other: SetReversion<OtherRoot, Element>.Action) {
        
            switch other {
            case let .insert(elements):
                self = .insert(elements)

            case let .remove(elements):
                self = .remove(elements)
                
            }
        }
    }
}
