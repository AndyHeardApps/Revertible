
struct IdentifiableDictionaryReversion<Root, Key: Hashable, Value: Identifiable> {
    
    // MARK: - Properties
    private let action: Action
    private let keyPath: WritableKeyPath<Root, [Key : Value]>

    // MARK: - Initialisers
    init(
        insert dictionary: [Key : Value],
        inDictionaryAt keyPath: WritableKeyPath<Root, [Key : Value]>
    ) {

        self.action = .insert(dictionary)
        self.keyPath = keyPath
    }

    init(
        remove keys: Set<Key>,
        fromDictionaryAt keyPath: WritableKeyPath<Root, [Key : Value]>
    ) {
        
        self.action = .remove(keys)
        self.keyPath = keyPath
    }
    
    init(
        move origin: Key,
        to destination: Key,
        inDictionaryAt keyPath: WritableKeyPath<Root, [Key : Value]>
    ) {
        
        self.action = .move(origin: origin, destination: destination)
        self.keyPath = keyPath
    }
    
    private init(
        action: Action,
        keyPath: WritableKeyPath<Root, [Key : Value]>
    ) {
        
        self.action = action
        self.keyPath = keyPath
    }
}

// MARK: - Value reversion
extension IdentifiableDictionaryReversion: ValueReversion {
        
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
    
    func mapped<NewRoot>(to keyPath: WritableKeyPath<NewRoot, Root>) -> AnyValueReversion<NewRoot> {
        
        IdentifiableDictionaryReversion<NewRoot, Key, Value>(
            action: .init(action),
            keyPath: keyPath.appending(path: self.keyPath)
        )
        .erasedToAnyValueReversion()
    }
}

// MARK: - Utilities
extension IdentifiableDictionaryReversion {

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
extension IdentifiableDictionaryReversion {
    
    private enum Action {
        
        case insert([Key : Value])
        case remove(Set<Key>)
        case move(origin: Key, destination: Key)
        
        init<OtherRoot>(_ other: IdentifiableDictionaryReversion<OtherRoot, Key, Value>.Action) {
        
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
