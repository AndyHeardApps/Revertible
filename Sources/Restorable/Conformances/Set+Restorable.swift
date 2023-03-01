import Foundation

// MARK: - Restorable
extension Set: Restorable where Element: Restorable & Identifiable {
    
    func restoration(toPrevious previous: Set<Element>) -> ChangeRestorationCollection<Self>? {
        
        guard self != previous else {
            return nil
        }
        
        let insertedElements = self.subtracting(previous)
        let removedElements = previous.subtracting(self)
        
        var restorations: [any ChangeRestoration<Self>] = []

        if !insertedElements.isEmpty {
            let removeInsertedElementsRestoration = SingleChangeRestoration<Self, Self>(remove: insertedElements)
            restorations.append(removeInsertedElementsRestoration)
        }
        
        if !removedElements.isEmpty {
            let insertRemovedElementsRestoration = SingleChangeRestoration<Self, Self>(insert: removedElements)
            restorations.append(insertRemovedElementsRestoration)
        }
        
        return ChangeRestorationCollection(restorations)
    }
}

// MARK: - Restorable collection
extension Set: RestorableCollection where Element: Restorable & Identifiable {
        
    mutating func performInsertRestoration(insertions: Self) {
     
        self.formUnion(insertions)
    }
    
    mutating func performRemoveRestoration(removals: Self) {
        
        self.subtract(removals)
    }
}
