import Foundation

struct DataReversion<Root> {
    
    // MARK: - Properties
    private let action: Action
    private let keyPath: WritableKeyPath<Root, Data>

    // MARK: - Initialisers
    init(insert elements: Set<Insertion>) where Root == Data {

        self.action = .insert(elements)
        self.keyPath = \.self
    }

    init(remove indices: Set<Data.Index>) where Root == Data {

        self.action = .remove(indices)
        self.keyPath = \.self
    }
        
    private init(
        action: Action,
        keyPath: WritableKeyPath<Root, Data>
    ) {
        
        self.action = action
        self.keyPath = keyPath
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
            
        case let .remove(indices):
            remove(
                indices: indices,
                from: &object[keyPath: keyPath]
            )
            
        }
    }
    
    func mapped<NewRoot>(to keyPath: WritableKeyPath<NewRoot, Root>) -> AnyValueReversion<NewRoot> {
        
        DataReversion<NewRoot>(
            action: .init(action),
            keyPath: keyPath.appending(path: self.keyPath)
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
            data.insert(insertion.element, at: insertion.index)
        }
    }
    
    private func remove(
        indices: Set<Data.Index>,
        from data: inout Data
    ) {
        
        let sortedIndices = indices
            .sorted { $0 > $1 }
        
        for index in sortedIndices {
            data.remove(at: index)
        }
    }
}

// MARK: - Action
extension DataReversion {
    
    private enum Action {
        
        case insert(Set<Insertion>)
        case remove(Set<Data.Index>)
        
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
        fileprivate let element: Data.Element
        
        init(
            index: Data.Index,
            element: Data.Element
        ) {

            self.index = index
            self.element = element
        }
        
        fileprivate init<OtherRoot>(_ other: DataReversion<OtherRoot>.Insertion) {
            
            self.index = other.index
            self.element = other.element
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
