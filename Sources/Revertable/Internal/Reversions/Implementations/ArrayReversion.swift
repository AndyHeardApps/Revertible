
struct ArrayReversion<Root, Element: Identifiable> {
    
    // MARK: - Properties
    private let keyPath: WritableKeyPath<Root, [Element]>
    private let action: Action
    
    // MARK: - Initialisers
    init(insert elements: Set<Insertion>) where Root == [Element] {

        self.keyPath = \.self
        self.action = .insert(elements)
    }

    init(remove indices: Set<Array<Element>.Index>) where Root == [Element] {

        self.keyPath = \.self
        self.action = .remove(indices)
    }
    
    init(move elementID: Element.ID, to destination: Array<Element>.Index) where Root == [Element] {
        
        self.keyPath = \.self
        self.action = .move(elementID: elementID, destination: destination)
    }
    
    private init(
        keyPath: WritableKeyPath<Root, [Element]>,
        action: Action
    ) {
        
        self.keyPath = keyPath
        self.action = action
    }
}

// MARK: - Value reversion
extension ArrayReversion: ValueReversion {
    
    typealias Mapped = ArrayReversion
        
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
    
    func mapped<NewRoot>(to keyPath: WritableKeyPath<NewRoot, Root>) -> ArrayReversion<NewRoot, Element> {
        
        ArrayReversion<NewRoot, Element>(
            keyPath: keyPath.appending(path: self.keyPath),
            action: .init(action)
        )
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
extension ArrayReversion {
    
    private enum Action {
        
        case insert(Set<Insertion>)
        case remove(Set<Array<Element>.Index>)
        case move(elementID: Element.ID, destination: Array<Element>.Index)
        
        init<OtherRoot>(_ other: ArrayReversion<OtherRoot, Element>.Action) {
        
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
extension ArrayReversion {
    
    struct Insertion {
        
        let index: Array<Element>.Index
        let element: Element
        
        init<OtherRoot>(_ other: ArrayReversion<OtherRoot, Element>.Insertion) {
            
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
