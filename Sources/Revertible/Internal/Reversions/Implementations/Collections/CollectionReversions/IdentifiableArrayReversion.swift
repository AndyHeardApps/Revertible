
struct IdentifiableArrayReversion<Root, Element: Identifiable> {
    
    // MARK: - Properties
    private let action: Action
    private let keyPath: WritableKeyPath<Root, [Element]>
    
    // MARK: - Initialisers
    init(insert elements: Set<Insertion>) where Root == [Element] {

        self.action = .insert(elements)
        self.keyPath = \.self
    }

    init(remove indices: Set<Array<Element>.Index>) where Root == [Element] {

        self.action = .remove(indices)
        self.keyPath = \.self
    }
    
    init(
        move elementID: Element.ID,
        to destination: Array<Element>.Index
    ) where Root == [Element] {
        
        self.action = .move(elementID: elementID, destination: destination)
        self.keyPath = \.self
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
extension IdentifiableArrayReversion: ValueReversion {
            
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
            
        case let .move(elementID, destination):
            move(
                elementID: elementID,
                to: destination,
                in: &object[keyPath: keyPath]
            )
        }
    }
    
    func mapped<NewRoot>(to keyPath: WritableKeyPath<NewRoot, Root>) -> AnyValueReversion<NewRoot> {
        
        IdentifiableArrayReversion<NewRoot, Element>(
            action: .init(action),
            keyPath: keyPath.appending(path: self.keyPath)
        )
        .erasedToAnyValueReversion()
    }
}

// MARK: - Utilities
extension IdentifiableArrayReversion {
    
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
    
    private func move(
        elementID: Element.ID,
        to destination: Array<Element>.Index,
        in array: inout [Element]
    ) {
        
        guard let elementIndex = array.firstIndex(where: { $0.id == elementID}) else {
            return
        }
        
        let element = array.remove(at: elementIndex)
        array.insert(element, at: destination)
    }
}

// MARK: - Action
extension IdentifiableArrayReversion {
    
    fileprivate enum Action {
        
        case insert(Set<Insertion>)
        case remove(Set<Array<Element>.Index>)
        case move(elementID: Element.ID, destination: Array<Element>.Index)
        
        fileprivate init<OtherRoot>(_ other: IdentifiableArrayReversion<OtherRoot, Element>.Action) {
        
            switch other {
            case let .insert(insertions):
                let mappedInsertions = insertions.map { Insertion($0) }
                self = .insert(Set(mappedInsertions))

            case let .remove(indices):
                self = .remove(indices)
                
            case let .move(elementID, destination):
                self = .move(elementID: elementID, destination: destination)
                
            }
        }
    }
}

// MARK: - Insertion
extension IdentifiableArrayReversion {
    
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
        
        fileprivate init<OtherRoot>(_ other: IdentifiableArrayReversion<OtherRoot, Element>.Insertion) {
            
            self.index = other.index
            self.element = other.element
        }
    }
}

extension IdentifiableArrayReversion.Insertion: Hashable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        
        lhs.index == rhs.index
    }

    func hash(into hasher: inout Hasher) {
        
        hasher.combine(index)
    }
}
