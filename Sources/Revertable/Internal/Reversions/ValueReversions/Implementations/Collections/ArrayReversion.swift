
struct ArrayReversion<Root, Element> {
    
    // MARK: - Properties
    private let action: Action
    private let keyPath: WritableKeyPath<Root, [Element]>
    
    // MARK: - Initialisers
    init(
        insert elements: Set<Insertion>,
        inArrayAt keyPath: WritableKeyPath<Root, [Element]>
    ) {

        self.action = .insert(elements)
        self.keyPath = keyPath
    }

    init(
        remove indices: Set<Array<Element>.Index>,
        fromArrayAt keyPath: WritableKeyPath<Root, [Element]>
    ) {

        self.action = .remove(indices)
        self.keyPath = keyPath
    }

    fileprivate init(
        action: Action,
        keyPath: WritableKeyPath<Root, [Element]>
    ) {
        
        self.action = action
        self.keyPath = keyPath
    }
}

// MARK: - Value reversion
extension ArrayReversion: ValueReversion {
            
    func revert(_ object: inout Root) {
        
        switch action {
        case let .insert(insertions):
            insert(
                insertions: insertions,
                into: &object[keyPath: keyPath]
            )
            
        case let .remove(indices):
            remove(
                indices: indices,
                from: &object[keyPath: keyPath]
            )
            
        }
    }
    
    func mapped<NewRoot>(to keyPath: WritableKeyPath<NewRoot, Root>) -> AnyValueReversion<NewRoot> {
        
        ArrayReversion<NewRoot, Element>(
            action: .init(action),
            keyPath: keyPath.appending(path: self.keyPath)
        )
        .erasedToAnyValueReversion()
    }
}

// MARK: - Utilities
extension ArrayReversion {
    
    private func insert(
        insertions: Set<Insertion>,
        into array: inout [Element]
    ) {
        
        let sortedInsertions = insertions
            .sorted { $0.index < $1.index }
        
        for insertion in sortedInsertions {
            array.insert(insertion.element, at: insertion.index)
        }
    }
    
    private func remove(
        indices: Set<Array<Element>.Index>,
        from array: inout [Element]
    ) {
        
        let sortedIndices = indices
            .sorted { $0 > $1 }
        
        for index in sortedIndices {
            array.remove(at: index)
        }
    }
}

// MARK: - Action
extension ArrayReversion {
    
    fileprivate enum Action {
        
        case insert(Set<Insertion>)
        case remove(Set<Array<Element>.Index>)
        
        fileprivate init<OtherRoot>(_ other: ArrayReversion<OtherRoot, Element>.Action) {
        
            switch other {
            case let .insert(insertions):
                let mappedInsertions = insertions.map { Insertion($0) }
                self = .insert(Set(mappedInsertions))

            case let .remove(indices):
                self = .remove(indices)
                
            }
        }
    }
}

// MARK: - Insertion
extension ArrayReversion {
    
    struct Insertion {
        
        fileprivate let index: Array<Element>.Index
        fileprivate let element: Element
        
        init(
            index: Array<Element>.Index,
            element: Element
        ) {
            
            self.index = index
            self.element = element
        }
        
        fileprivate init<OtherRoot>(_ other: ArrayReversion<OtherRoot, Element>.Insertion) {
            
            self.index = other.index
            self.element = other.element
        }
    }
}

extension ArrayReversion.Insertion: Hashable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        
        lhs.index == rhs.index
    }

    func hash(into hasher: inout Hasher) {
        
        hasher.combine(index)
    }
}
