
struct SetReversion<Element: Hashable> {
    
    // MARK: - Properties
    private let action: Action
    
    // MARK: - Initialisers
    init(insert elements: Set<Element>) {
        
        self.action = .insert(elements)
    }
    
    init(remove elements: Set<Element>) {
        
        self.action = .remove(elements)
    }
}

// MARK: - Value reversion
extension SetReversion: ValueReversion {
    
    func revert(_ object: inout Set<Element>) {
        
        switch action {
        case let .insert(elements):
            object.formUnion(elements)
            
        case let .remove(elements):
            object.subtract(elements)

        }
    }
}

// MARK: - Action
extension SetReversion {
    
    private enum Action {
        case insert(Set<Element>)
        case remove(Set<Element>)
    }
}
