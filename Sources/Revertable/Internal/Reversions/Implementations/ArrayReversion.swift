
struct ArrayReversion<Element: Identifiable> {
    
    // MARK: - Properties
    private let action: Action
    
    // MARK: - Initialisers
    init(insert elements: Set<Insertion>) {

        self.action = .insert(elements)
    }

    init(remove indices: Set<Array<Element>.Index>) {

        self.action = .remove(indices)
    }
    
    init(move elementID: Element.ID, to destination: Array<Element>.Index) {
        
        self.action = .move(elementID: elementID, destination: destination)
    }
}

// MARK: - Value reversion
extension ArrayReversion: ValueReversion {
    
    func revert(_ array: inout [Element]) {
        
        switch action {
        case let .insert(insertions):
            insert(
                insertions: insertions,
                into: &array
            )
            
        case let .remove(indices):
            remove(
                indices: indices,
                from: &array
            )
            
        case let .move(elementID, destination):
            move(
                elementID: elementID,
                to: destination,
                in: &array
            )
        }
    }
    
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
    }
}

// MARK: - Insertion
extension ArrayReversion {
    
    struct Insertion {
        
        let index: Array<Element>.Index
        let element: Element
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
