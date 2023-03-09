
struct DictionaryReversion<Root, Key: Hashable, Value: Equatable> {
    
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
    
    private init(
        action: Action,
        keyPath: WritableKeyPath<Root, [Key : Value]>
    ) {
        
        self.action = action
        self.keyPath = keyPath
    }
}

// MARK: - Value reversion
extension DictionaryReversion: ValueReversion {
        
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
            
        }
    }
    
    func mapped<NewRoot>(to keyPath: WritableKeyPath<NewRoot, Root>) -> AnyValueReversion<NewRoot> {
        
        DictionaryReversion<NewRoot, Key, Value>(
            action: .init(action),
            keyPath: keyPath.appending(path: self.keyPath)
        )
        .erasedToAnyValueReversion()
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
}

// MARK: - Action
extension DictionaryReversion {
    
    private enum Action {
        
        case insert([Key : Value])
        case remove(Set<Key>)
        
        init<OtherRoot>(_ other: DictionaryReversion<OtherRoot, Key, Value>.Action) {
        
            switch other {
            case let .insert(insertions):
                self = .insert(insertions)

            case let .remove(keys):
                self = .remove(keys)
                
            }
        }
    }
}
