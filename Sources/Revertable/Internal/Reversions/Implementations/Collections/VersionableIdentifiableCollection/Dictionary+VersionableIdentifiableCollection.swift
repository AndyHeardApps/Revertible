
extension Dictionary: VersionableIdentifiableCollection where Value: Identifiable & Versionable {
    
    func identifiableCollectionReversions(to previousValue: Self) -> [AnyValueReversion<Self>] {
        
        var reversions: [AnyValueReversion<Self>] = []
        
        guard self != previousValue else {
            return reversions
        }

        var currentByID: [Value.ID : (Key, Value)] = [:]
        var previousByID: [Value.ID : (Key, Value)] = [:]
        
        for element in self {
            currentByID[element.value.id] = element
        }
        for element in previousValue {
            previousByID[element.value.id] = element
        }
        
        let currentIDs = Set(currentByID.keys)
        let previousIDs = Set(previousByID.keys)

        let retainedIDs = currentIDs.intersection(previousIDs)
        let insertedIDs = currentIDs.subtracting(previousIDs)
        let removedIDs = previousIDs.subtracting(currentIDs)
        
        if !insertedIDs.isEmpty {
            
            let keysToRemove = insertedIDs
                .compactMap { currentByID[$0]?.0 }
            let reversion = IdentifiableDictionaryReversion<Self, Key, Value>(remove: Set(keysToRemove))
                .erasedToAnyValueReversion()
            
            reversions.append(reversion)
        }

        if !removedIDs.isEmpty {
            
            let elementsToInsert = removedIDs
                .compactMap { previousByID[$0] }
            let reversion = IdentifiableDictionaryReversion(insert: Dictionary(uniqueKeysWithValues: elementsToInsert))
                .erasedToAnyValueReversion()
            
            reversions.append(reversion)
        }
        
        for retainedID in retainedIDs {
            guard
                let (currentKey, currentElementValue) = currentByID[retainedID],
                let (previousKey, previousElementValue) = previousByID[retainedID]
            else {
                continue
            }

            if previousKey != currentKey {
                let moveReversion = IdentifiableDictionaryReversion<Self, Key, Value>(move: currentKey, to: previousKey)
                    .erasedToAnyValueReversion()
                reversions.append(moveReversion)
            }
            
            if previousElementValue != currentElementValue {
                var reverter = DefaultReverter(
                    current: currentElementValue,
                    previous: previousElementValue
                )
                currentElementValue.addReversions(into: &reverter)
                
                if let reversion = reverter.erasedToAnyValueReversion()?.mapped(to: \Self.[previousKey].setUnsafelyUnwrapped) {
                    reversions.append(reversion)
                }
            }
        }
        
        return reversions
    }
}
