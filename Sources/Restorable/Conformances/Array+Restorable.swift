import SwiftUI

// MARK: - Restorable
extension Array: Restorable where Element: Restorable & Equatable & Identifiable {
    
    func restoration(toPrevious previous: Array<Element>) -> ChangeRestorationCollection<Self>? {
        
        guard self != previous else {
            return nil
        }
        
        let difference = self.difference(from: previous)

        var insertions: [Element.ID : (Int, Element)] = [:]
        var removals: [Element.ID : (Int, Element)] = [:]

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
        
        let modifiedIDs = insertedIDs.intersection(removedIDs)
        let actuallyInsertedIDs = insertedIDs.subtracting(removedIDs)
        let actuallyRemovedIDs = removedIDs.subtracting(insertedIDs)
        
        var restorations: [any ChangeRestoration<Self>] = []
        
        if !actuallyInsertedIDs.isEmpty {
            let indicesToRemove = actuallyInsertedIDs
                .compactMap { insertions[$0]?.0 }
            
            let removeInsertedElementsRestoration = SingleChangeRestoration<Self, Self>(remove: .init(indicesToRemove))
            
            restorations.append(removeInsertedElementsRestoration)
        }
        
        if !actuallyRemovedIDs.isEmpty {
            let valuesToInsert = actuallyRemovedIDs
                .compactMap { removals[$0] }
            
            let insertRemovedElementsRestoration = SingleChangeRestoration<Self, Self>(insert: valuesToInsert)
            
            restorations.append(insertRemovedElementsRestoration)
        }
        
        for modifiedID in modifiedIDs {
            guard
                let (currentIndex, currentElement) = insertions[modifiedID],
                let (previousIndex, previousElement) = removals[modifiedID],
                let restoration = currentElement.restoration(toPrevious: previousElement)?.mapped(to: \Self.[previousIndex])
            else {
                continue
            }
            
            if previousIndex != currentIndex {
                let moveToPreviousIndexRestoration = SingleChangeRestoration<Self, Self>(move: (modifiedID, previousIndex))
                restorations.append(moveToPreviousIndexRestoration)
            }
            
            restorations.append(restoration)
        }
        
        return ChangeRestorationCollection(restorations)
    }
}

// MARK: - Restorable collection
extension Array: RestorableCollection where Element: Restorable & Equatable & Identifiable {    
    
    mutating func performInsertRestoration(insertions: [(Index, Element)]) {

        let sortedValues = insertions.sorted { lhs, rhs in
            lhs.0 < rhs.0
        }
        for (index, element) in sortedValues {
            insert(element, at: index)
        }
    }

    mutating func performRemoveRestoration(removals: IndexSet) {
        
        remove(atOffsets: removals)
    }
}

// MARK: - Restorable ordered collection
extension Array: RestorableOrderedCollection where Element: Restorable & Equatable & Identifiable {
        
    mutating func performMoveRestoration(move: (elementID: Element.ID, destination: Int)) {
        
        guard let index = firstIndex(where: { $0.id == move.elementID }) else {
            return
        }
        
        self.move(fromOffsets: IndexSet(integer: index), toOffset: move.destination)
    }
}
