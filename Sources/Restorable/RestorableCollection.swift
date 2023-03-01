import Foundation

protocol RestorableCollection: Restorable {
    
    // MARK: - Associated types
    associatedtype InsertedElements
    associatedtype RemovedElements

    // MARK: - Functions
    mutating func performInsertRestoration(insertions: InsertedElements)
    mutating func performRemoveRestoration(removals: RemovedElements)
}

protocol RestorableOrderedCollection: RestorableCollection {
    
    // MARK: - Associated types
    associatedtype MovedElement

    // MARK: - Functions
    mutating func performMoveRestoration(move: MovedElement)
}
