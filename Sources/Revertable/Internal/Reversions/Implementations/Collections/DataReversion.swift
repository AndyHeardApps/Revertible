import Foundation

struct DataReversion<Root> {
    
    // MARK: - Properties
    private let keyPath: WritableKeyPath<Root, Data>
    private let action: Action
    
    // MARK: - Initialisers
    init(insert elements: Set<Insertion>) where Root == Data {

        self.keyPath = \.self
        self.action = .insert(elements)
    }

    init(remove indices: Set<ClosedRange<Data.Index>>) where Root == Data {

        self.keyPath = \.self
        self.action = .remove(indices)
    }
        
    private init(
        keyPath: WritableKeyPath<Root, Data>,
        action: Action
    ) {
        
        self.keyPath = keyPath
        self.action = action
    }
}

// MARK: - Value reversion
extension DataReversion: ValueReversion {
            
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
        
        DataReversion<NewRoot>(
            keyPath: keyPath.appending(path: self.keyPath),
            action: .init(action)
        )
        .erasedToAnyValueReversion()
    }
}

// MARK: - Utilities
extension DataReversion {
    
    private func insert(
        insertions: Set<Insertion>,
        into data: inout Data
    ) {
        
        let sortedInsertions = insertions
            .sorted { $0.index < $1.index }
        
        for insertion in sortedInsertions {
            data.insert(contentsOf: insertion.elements, at: insertion.index)
        }
    }
    
    private func remove(
        indexRanges: Set<ClosedRange<Data.Index>>,
        from data: inout Data
    ) {
        
        let sortedIndexRanges = indexRanges
            .sorted { $0.upperBound > $1.upperBound }
        
        for indexRange in sortedIndexRanges {
            data.removeSubrange(indexRange)
        }
    }
}

// MARK: - Action
extension DataReversion {
    
    private enum Action {
        
        case insert(Set<Insertion>)
        case remove(Set<ClosedRange<Data.Index>>)
        
        init<OtherRoot>(_ other: DataReversion<OtherRoot>.Action) {
        
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
extension DataReversion {
    
    struct Insertion {
        
        fileprivate let index: Data.Index
        fileprivate let elements: Data.SubSequence
        
        init(
            index: Data.Index,
            elements: Data.SubSequence
        ) {

            self.index = index
            self.elements = elements
        }
        
        fileprivate init<OtherRoot>(_ other: DataReversion<OtherRoot>.Insertion) {
            
            self.index = other.index
            self.elements = other.elements
        }
    }
}

extension DataReversion.Insertion: Hashable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        
        lhs.index == rhs.index
    }

    func hash(into hasher: inout Hasher) {
        
        hasher.combine(index)
    }
}
