
struct StringReversion<Root> {
    
    // MARK: - Properties
    private let keyPath: WritableKeyPath<Root, String>
    private let action: Action
    
    // MARK: - Initialisers
    init(insert elements: Set<Insertion>) where Root == String {

        self.keyPath = \.self
        self.action = .insert(elements)
    }

    init(remove indedRanges: Set<ClosedRange<String.Index>>) where Root == String {

        self.keyPath = \.self
        self.action = .remove(indedRanges)
    }
        
    private init(
        keyPath: WritableKeyPath<Root, String>,
        action: Action
    ) {
        
        self.keyPath = keyPath
        self.action = action
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
            
        case let .remove(indexRanges):
            remove(
                indexRanges: indexRanges,
                from: &object[keyPath: keyPath]
            )
            
        }
    }
    
    func mapped<NewRoot>(to keyPath: WritableKeyPath<NewRoot, Root>) -> AnyValueReversion<NewRoot> {
        
        StringReversion<NewRoot>(
            keyPath: keyPath.appending(path: self.keyPath),
            action: .init(action)
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
            string.insert(contentsOf: insertion.elements, at: insertion.index)
        }
    }
    
    private func remove(
        indexRanges: Set<ClosedRange<String.Index>>,
        from string: inout String
    ) {
        
        let sortedIndexRanges = indexRanges
            .sorted { $0.upperBound > $1.upperBound }
        
        for indexRange in sortedIndexRanges {
            string.removeSubrange(indexRange)
        }
    }
}

// MARK: - Action
extension StringReversion {
    
    private enum Action {
        
        case insert(Set<Insertion>)
        case remove(Set<ClosedRange<String.Index>>)

        init<OtherRoot>(_ other: StringReversion<OtherRoot>.Action) {
        
            switch other {
            case let .insert(insertions):
                let mappedInsertions = insertions.map { Insertion($0) }
                self = .insert(Set(mappedInsertions))
                      
            case let .remove(indexRanges):
                self = .remove(indexRanges)
                
            }
        }
    }
}

// MARK: - Insertion
extension StringReversion {
    
    struct Insertion {
        
        fileprivate let index: String.Index
        fileprivate let elements: String.SubSequence
        
        init(
            index: String.Index,
            elements: String.SubSequence
        ) {

            self.index = index
            self.elements = elements
        }
        
        fileprivate init<OtherRoot>(_ other: StringReversion<OtherRoot>.Insertion) {
            
            self.index = other.index
            self.elements = other.elements
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
