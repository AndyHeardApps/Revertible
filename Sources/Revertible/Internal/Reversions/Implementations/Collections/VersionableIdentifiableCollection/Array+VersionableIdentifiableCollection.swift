
extension Array: VersionableIdentifiableCollection where Element: Versionable & Identifiable {
    
    func identifiableCollectionReversions(to previousValue: Self) -> [AnyValueReversion<Self>] {
        
        var reversions: [AnyValueReversion<Self>] = []
        
        guard self != previousValue else {
            return reversions
        }
        
        let difference = self.difference(from: previousValue)
        
        var insertions: [Element.ID : (Index, Element)] = [:]
        var removals: [Element.ID : (Index, Element)] = [:]

        for change in difference {
            switch change {
            case let .insert(offset, element, _):
                insertions[element.id] = (offset, element)
                
            case let .remove(offset, element, _):
                removals[element.id] = (offset, element)

            }
        }
        
        let insertedIDs: Set<Element.ID> = Set(insertions.keys)
        let removedIDs: Set<Element.ID> = Set(removals.keys)
        
        let modifiedIDs = removedIDs.intersection(insertedIDs)
        let newIDs = removedIDs.subtracting(insertedIDs)
        let deletedIDs = insertedIDs.subtracting(removedIDs)
                
        if !deletedIDs.isEmpty {
            let indicesToRemove = deletedIDs
                .compactMap { insertions[$0]?.0 }
            
            let reversion = IdentifiableArrayReversion<Self, Element>(remove: Set(indicesToRemove))
                .erasedToAnyValueReversion()
            
            reversions.append(reversion)
        }
        
        if !newIDs.isEmpty {
            let valuesToInsert = newIDs
                .compactMap { removals[$0] }
                .map { IdentifiableArrayReversion<Self, Element>.Insertion(index: $0.0, element: $0.1) }
            
            let reversion = IdentifiableArrayReversion(insert: Set(valuesToInsert))
                .erasedToAnyValueReversion()
            
            reversions.append(reversion)
        }
        
        for modifiedID in modifiedIDs {
            guard
                let (currentIndex, currentElementValue) = insertions[modifiedID],
                let (previousIndex, previousElementValue) = removals[modifiedID]
            else {
                continue
            }
            
            if previousIndex != currentIndex {
                let moveReversion = IdentifiableArrayReversion<Self, Element>(move: modifiedID, to: previousIndex)
                    .erasedToAnyValueReversion()

                reversions.append(moveReversion)
            }
            
            if previousElementValue != currentElementValue {
                var reverter = DefaultReverter(
                    current: currentElementValue,
                    previous: previousElementValue
                )
                currentElementValue.addReversions(into: &reverter)
                
                if let reversion = reverter.erasedToAnyValueReversion()?.mapped(to: \Self.[previousIndex]) {
                    reversions.append(reversion)
                }
            }
        }
        
        return reversions
    }
}
