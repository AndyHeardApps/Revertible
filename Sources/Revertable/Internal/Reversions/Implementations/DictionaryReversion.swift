
struct DictionaryReversion<Root, Key: Hashable, Value: Identifiable> {
    
    // MARK: - Properties
    private let keyPath: WritableKeyPath<Root, [Key : Value]>
    private let action: Action
    
    // MARK: - Initialisers
    init(insert dictionary: [Key : Value]) where Root == [Key : Value] {

        self.keyPath = \.self
        self.action = .insert(dictionary)
    }

    init(remove keys: Set<Key>) where Root == [Key : Value] {

        self.keyPath = \.self
        self.action = .remove(keys)
    }
    
    init(
        move origin: Key,
        to destination: Key
    ) where Root == [Key : Value] {
        
        self.keyPath = \.self
        self.action = .move(origin: origin, destination: destination)
    }
    
    private init(
        keyPath: WritableKeyPath<Root, [Key : Value]>,
        action: Action
    ) {
        
        self.keyPath = keyPath
        self.action = action
    }
}

// MARK: - Value reversion
extension DictionaryReversion: ValueReversion {
    
    typealias Mapped = DictionaryReversion
    
    func revert(_ object: inout Root) {
        
        switch action {
        case let .insert(insertions):
            insert(
                insertions: insertions,
                into: &object[keyPath: keyPath]
            )
            
        case let .remove(keys):
            remove(
                keys: keys,
                from: &object[keyPath: keyPath]
            )
            
        case let .move(origin, destination):
            move(
                from: origin,
                to: destination,
                in: &object[keyPath: keyPath]
            )
        }
    }
    
    func mapped<NewRoot>(to keyPath: WritableKeyPath<NewRoot, Root>) -> DictionaryReversion<NewRoot, Key, Value> {
        
        DictionaryReversion<NewRoot, Key, Value>(
            keyPath: keyPath.appending(path: self.keyPath),
            action: .init(action)
        )
    }
}

// MARK: - Utilities
extension DictionaryReversion {

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
        
        init<OtherRoot>(_ other: DictionaryReversion<OtherRoot, Key, Value>.Action) {
        
            switch other {
            case let .insert(insertions):
                self = .insert(insertions)

            case let .remove(keys):
                self = .remove(keys)
                
            case let .move(origin, destination):
                self = .move(origin: origin, destination: destination)
                
            }
        }
    }
}
