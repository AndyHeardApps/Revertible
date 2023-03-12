
struct StringReversion<Root> {
    
    // MARK: - Properties
    private let action: Action
    private let keyPath: WritableKeyPath<Root, String>

    // MARK: - Initialisers
    init(insert elements: Set<Insertion>) where Root == String {

        self.action = .insert(elements)
        self.keyPath = \.self
    }

    init(remove indices: Set<String.Index>) where Root == String {

        self.action = .remove(indices)
        self.keyPath = \.self
    }
        
    private init(
        action: Action,
        keyPath: WritableKeyPath<Root, String>
    ) {
        
        self.action = action
        self.keyPath = keyPath
    }
}

// MARK: - Value reversion
extension StringReversion: ValueReversion {
            
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
        
        StringReversion<NewRoot>(
            action: .init(action),
            keyPath: keyPath.appending(path: self.keyPath)
        )
        .erasedToAnyValueReversion()
    }
}

// MARK: - Utilities
extension StringReversion {
    
    private func insert(
        insertions: Set<Insertion>,
        into string: inout String
    ) {
        
        let sortedInsertions = insertions
            .sorted { $0.index < $1.index }
        
        for insertion in sortedInsertions {
            string.insert(insertion.element, at: insertion.index)
        }
    }
    
    private func remove(
        indices: Set<String.Index>,
        from string: inout String
    ) {
        
        let sortedIndices = indices
            .sorted { $0 > $1 }
        
        for index in sortedIndices {
            string.remove(at: index)
        }
    }
}

// MARK: - Action
extension StringReversion {
    
    private enum Action {
        
        case insert(Set<Insertion>)
        case remove(Set<String.Index>)

        init<OtherRoot>(_ other: StringReversion<OtherRoot>.Action) {
        
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
extension StringReversion {
    
    struct Insertion {
        
        fileprivate let index: String.Index
        fileprivate let element: String.Element
        
        init(
            index: String.Index,
            element: String.Element
        ) {

            self.index = index
            self.element = element
        }
        
        fileprivate init<OtherRoot>(_ other: StringReversion<OtherRoot>.Insertion) {
            
            self.index = other.index
            self.element = other.element
        }
    }
}

extension StringReversion.Insertion: Hashable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        
        lhs.index == rhs.index
    }

    func hash(into hasher: inout Hasher) {
        
        hasher.combine(index)
    }
}
