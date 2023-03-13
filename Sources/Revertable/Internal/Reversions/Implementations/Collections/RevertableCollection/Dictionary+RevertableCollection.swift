
extension Dictionary: RevertableCollection where Key: Equatable, Value: Equatable {
    
    func collectionReversions(to previousValue: Self) -> [DictionaryReversion<Self, Key, Value>] {
        
        var reversions: [DictionaryReversion<Self, Key, Value>] = []

        guard self != previousValue else {
            return reversions
        }
        
        let currentKeys = Set(self.map(\.key))
        let previousKeys = Set(previousValue.map(\.key))
        
        let keysToRemove = currentKeys.subtracting(previousKeys)
        let keysToInsert = previousKeys.subtracting(currentKeys)
        let keysToUpdate = currentKeys.intersection(previousKeys)
            .filter { self[$0] != previousValue[$0] }
        
        let elementsToInsert = keysToInsert.union(keysToUpdate)
            .compactMap { key -> (Key, Value)? in
                guard let value = previousValue[key] else {
                    return nil
                }
                
                return (key, value)
            }
        
        if !keysToRemove.isEmpty {
            let reversion = DictionaryReversion<Self, Key, Value>(remove: keysToRemove)
            reversions.append(reversion)
        }
        
        if !elementsToInsert.isEmpty {
            let reversion = DictionaryReversion(insert: Dictionary(uniqueKeysWithValues: elementsToInsert))
            reversions.append(reversion)
        }
        
        return reversions
    }
}
