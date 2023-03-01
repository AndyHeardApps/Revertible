
struct DictionaryReversion<Key: Hashable, Value: Identifiable> {
    
    // MARK: - Properties
    private let action: Action
    
    // MARK: - Initialisers
    init(insert dictionary: [Key : Value]) {

        self.action = .insert(dictionary)
    }

    init(remove keys: Set<Key>) {

        self.action = .remove(keys)
    }
    
    init(
        move origin: Key,
        to destination: Key
    ) {
        
        self.action = .move(origin: origin, destination: destination)
    }
}

// MARK: - Value reversion
extension DictionaryReversion: ValueReversion {
    
    func revert(_ dictionary: inout [Key : Value]) {
        
        switch action {
        case let .insert(insertions):
            insert(
                insertions: insertions,
                into: &dictionary
            )
            
        case let .remove(keys):
            remove(
                keys: keys,
                from: &dictionary
            )
            
        case let .move(origin, destination):
            move(
                from: origin,
                to: destination,
                in: &dictionary
            )
        }
    }
    
    private func insert(
        insertions: [Key : Value],
        into dictionary: inout [Key : Value]
    ) {
        
        dictionary.merge(insertions) { $1 }
    }
    
    private func remove(
        keys: Set<Key>,
        from dictionary: inout [Key : Value]
    ) {
        
        for key in keys {
            dictionary.removeValue(forKey: key)
        }
    }
    
    private func move(
        from origin: Key,
        to destination: Key,
        in dictionary: inout [Key : Value]
    ) {
        
        if let value = dictionary.removeValue(forKey: origin) {
            dictionary.updateValue(value, forKey: destination)
        }
    }
}

// MARK: - Action
extension DictionaryReversion {
    
    private enum Action {
        case insert([Key : Value])
        case remove(Set<Key>)
        case move(origin: Key, destination: Key)
    }
}
