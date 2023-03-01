import Foundation

// MARK: - Restorable
extension Dictionary: Restorable where Key: Hashable, Value: Restorable & Identifiable {
    
    func restoration(toPrevious previous: [Key : Value]) -> ChangeRestorationCollection<Self>? {
        
        var currentByID: [Value.ID : (Key, Value)] = [:]
        var previousByID: [Value.ID : (Key, Value)] = [:]
        
        for element in self {
            currentByID[element.value.id] = element
        }
        for element in previous {
            previousByID[element.value.id] = element
        }
        
        let currentIDs = Set(currentByID.keys)
        let previousIDs = Set(previousByID.keys)

        let retainedIDs = currentIDs.intersection(previousIDs)
        let insertedIDs = currentIDs.subtracting(previousIDs)
        let removedIDs = previousIDs.subtracting(currentIDs)
        
        var restorations: [any ChangeRestoration<Self>] = []

        if !insertedIDs.isEmpty {
            
            let keysToRemove = insertedIDs
                .compactMap { currentByID[$0]?.0 }
            let removeInsertedElementsRestoration = SingleChangeRestoration<Self, Self>(remove: Set(keysToRemove))
            
            restorations.append(removeInsertedElementsRestoration)
        }

        if !removedIDs.isEmpty {
            
            let elementsToInsert = removedIDs
                .compactMap { previousByID[$0] }
            let insertRemovedElementsRestoration = SingleChangeRestoration<Self, Self>(insert: elementsToInsert)
            
            restorations.append(insertRemovedElementsRestoration)
        }
        
        for retainedID in retainedIDs {
            guard
                let (currentKey, currentElement) = currentByID[retainedID],
                let (previousKey, previousElement) = previousByID[retainedID],
                let restoration = currentElement.restoration(toPrevious: previousElement)?.mapped(to: \Self[previousKey].setUnsafelyUnwrapped)
            else {
                continue
            }

            if previousKey != currentKey {
                let moveToPreviousKeyRestoration = SingleChangeRestoration<Self, Self>(move: (currentKey, previousKey))
                restorations.append(moveToPreviousKeyRestoration)
            }
            
            restorations.append(restoration)
        }
        
        guard !restorations.isEmpty else {
            return nil
        }

        return ChangeRestorationCollection(restorations)
    }
}

// MARK: - Restorable collection
extension Dictionary: RestorableCollection where Key: Hashable, Value: Restorable & Identifiable {
    
    mutating func performInsertRestoration(insertions: [Element]) {

        merge(insertions) { $1 }
    }
    
    mutating func performRemoveRestoration(removals: Set<Key>) {
        
        for removal in removals {
            removeValue(forKey: removal)
        }
    }
}

// MARK: - Restorable ordered collection
extension Dictionary: RestorableOrderedCollection where Key: Hashable, Value: Restorable & Identifiable {
        
    mutating func performMoveRestoration(move: (origin: Key, destination: Key)) {
        
        if let value = self.removeValue(forKey: move.origin) {
            self.updateValue(value, forKey: move.destination)
        }
    }
}

// MARK: - Optional key path
fileprivate extension Optional {
    
    var setUnsafelyUnwrapped: Wrapped {
        get {
            self.unsafelyUnwrapped
        }
        set {
            self = newValue
        }
    }
}
