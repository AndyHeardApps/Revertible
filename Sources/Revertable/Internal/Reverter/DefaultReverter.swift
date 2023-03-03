import Foundation

struct DefaultReverter<Root> {
    
    // MARK: - Properties
    private let current: Root
    private let previous: Root
    private(set) var reversions: [AnyValueReversion<Root>] = []
    
    var isEmpty: Bool {
        reversions.isEmpty
    }
    
    // MARK: - Initialiser
    init(
        current: Root,
        previous: Root
    ) {
        
        self.current = current
        self.previous = previous
    }
}

// MARK: - Reverter
extension DefaultReverter: Reverter {}
    
    // MARK: - Revertable
extension DefaultReverter {
    
    mutating func appendReversion<Value: Revertable>(at keyPath: WritableKeyPath<Root, Value>) {
        
        let currentValue = current[keyPath: keyPath]
        let previousValue = previous[keyPath: keyPath]
        
        var reverter = DefaultReverter<Value>(
            current: currentValue,
            previous: previousValue
        )
        currentValue.addReversions(into: &reverter)
        
        let reversion = MultipleValueReversion(reverter.reversions)
            .mapped(to: keyPath)
        
        if !reverter.reversions.isEmpty {
            reversions.append(reversion)
        }
    }
}

// MARK: - Integers
extension DefaultReverter {
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Int>) {
        appendEquatableReversion(at: keyPath)
    }
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Int64>) {
        appendEquatableReversion(at: keyPath)
    }
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Int32>) {
        appendEquatableReversion(at: keyPath)
    }
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Int16>) {
        appendEquatableReversion(at: keyPath)
    }
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Int8>) {
        appendEquatableReversion(at: keyPath)
    }
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, UInt>) {
        appendEquatableReversion(at: keyPath)
    }
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, UInt64>) {
        appendEquatableReversion(at: keyPath)
    }
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, UInt32>) {
        appendEquatableReversion(at: keyPath)
    }
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, UInt16>) {
        appendEquatableReversion(at: keyPath)
    }
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, UInt8>) {
        appendEquatableReversion(at: keyPath)
    }
}

// MARK: - Floats
extension DefaultReverter {
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Double>) {
        appendEquatableReversion(at: keyPath)
    }
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Float>) {
        appendEquatableReversion(at: keyPath)
    }
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Float16>) {
        appendEquatableReversion(at: keyPath)
    }
}

// MARK: - Date
extension DefaultReverter {
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Date>) {
        appendEquatableReversion(at: keyPath)
    }
}
    
// MARK: - String
extension DefaultReverter {
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, String>) {
        
        let currentValue = current[keyPath: keyPath]
        let previousValue = previous[keyPath: keyPath]
        
        guard currentValue != previousValue else {
            return
        }
        
        let difference = currentValue.difference(from: previousValue)

        var elementsToInsert: [(Int, String.Element)] = []
        var indicesToRemove: [Int] = []

        for change in difference.reversed() {
            switch change {
            case let .remove(offset, element, _):
                elementsToInsert.append((offset, element))
                
            case let .insert(offset, _, _):
                indicesToRemove.append(offset)
                
            }
        }
        
        if !indicesToRemove.isEmpty {
            let rangesToRemove = indicesToRemove.convertToRanges()
            let stringIndices = rangesToRemove
                .map { range in
                    let lowerBound = currentValue.index(currentValue.startIndex, offsetBy: range.lowerBound)
                    let upperBound = currentValue.index(currentValue.startIndex, offsetBy: range.upperBound)
                    return lowerBound...upperBound
                }
            let reversion = StringReversion(remove: Set(stringIndices))
                .mapped(to: keyPath)
            reversions.append(reversion)
        }
        
        if !elementsToInsert.isEmpty {
            let insertionDictionary = Dictionary(uniqueKeysWithValues: elementsToInsert)
            let rangesToInsert = elementsToInsert.map(\.0).convertToRanges()
            let insertions = rangesToInsert.map { range in
                let elements = range.compactMap { insertionDictionary[$0] }
                let startIndex = currentValue.index(currentValue.startIndex, offsetBy: range.lowerBound)

                return StringReversion<String>.Insertion(
                    index: startIndex,
                    elements: Substring(elements)
                )
            }
            let reversion = StringReversion(insert: Set(insertions))
                .mapped(to: keyPath)
            reversions.append(reversion)
        }
    }
}

// MARK: - Data
extension DefaultReverter {
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Data>) {
     
        let currentValue = current[keyPath: keyPath]
        let previousValue = previous[keyPath: keyPath]
        
        guard currentValue != previousValue else {
            return
        }
        
        let difference = currentValue.difference(from: previousValue)

        var elementsToInsert: [(Int, Data.Element)] = []
        var indicesToRemove: [Int] = []

        for change in difference.reversed() {
            switch change {
            case let .remove(offset, element, _):
                elementsToInsert.append((offset, element))
                
            case let .insert(offset, _, _):
                indicesToRemove.append(offset)
                
            }
        }
        
        if !indicesToRemove.isEmpty {
            let rangesToRemove = indicesToRemove.convertToRanges()
            let reversion = DataReversion(remove: Set(rangesToRemove))
                .mapped(to: keyPath)
            reversions.append(reversion)
        }
        
        if !elementsToInsert.isEmpty {
            let insertionDictionary = Dictionary(uniqueKeysWithValues: elementsToInsert)
            let rangesToInsert = elementsToInsert.map(\.0).convertToRanges()
            let insertions = rangesToInsert.map { range in
                let elements = range.compactMap { insertionDictionary[$0] }

                return DataReversion<Data>.Insertion(
                    index: range.lowerBound,
                    elements: Data.SubSequence(elements)
                )
            }
            let reversion = DataReversion(insert: Set(insertions))
                .mapped(to: keyPath)
            reversions.append(reversion)
        }
    }
}

// MARK: - Set
extension DefaultReverter {
    
    mutating func appendReversion<Element>(at keyPath: WritableKeyPath<Root, Set<Element>>) {
        
        let currentValue = current[keyPath: keyPath]
        let previousValue = previous[keyPath: keyPath]

        guard currentValue != previousValue else {
            return
        }
        
        let elementsToRemove = currentValue.subtracting(previousValue)
        let elementsToInsert = previousValue.subtracting(currentValue)
        
        if !elementsToRemove.isEmpty {
            let reversion = SetReversion(remove: elementsToRemove)
                .mapped(to: keyPath)
            reversions.append(reversion)
        }
        
        if !elementsToInsert.isEmpty {
            let reversion = SetReversion(insert: elementsToInsert)
                .mapped(to: keyPath)
            reversions.append(reversion)
        }
    }
}

// MARK: - Array
extension DefaultReverter {
    
    mutating func appendReversion<Element: Equatable>(at keyPath: WritableKeyPath<Root, [Element]>) {
        
        let currentValue = current[keyPath: keyPath]
        let previousValue = previous[keyPath: keyPath]
        
        guard currentValue != previousValue else {
            return
        }

        let difference = currentValue.difference(from: previousValue)
        
        var indicesToRemove: Set<Array<Element>.Index> = []
        var elementsToInsert: Set<ArrayReversion<[Element], Element>.Insertion> = []
        
        for change in difference {
            switch change {
            case let .insert(offset, _, _):
                indicesToRemove.insert(offset)
                
            case let .remove(offset, element, _):
                elementsToInsert.insert(.init(index: offset, element: element))
                
            }
        }
        
        if !indicesToRemove.isEmpty {
            let reversion = ArrayReversion<[Element], Element>(remove: indicesToRemove)
                .mapped(to: keyPath)
            reversions.append(reversion)
        }
        
        if !elementsToInsert.isEmpty {
            
            let reversion = ArrayReversion(insert: elementsToInsert)
                .mapped(to: keyPath)
            reversions.append(reversion)
        }
    }
    
    mutating func appendReversion<Element: Equatable & Identifiable & Revertable>(at keyPath: WritableKeyPath<Root, [Element]>) {
     
        let currentValue = current[keyPath: keyPath]
        let previousValue = previous[keyPath: keyPath]

        guard currentValue != previousValue else {
            return
        }
        
        let currentIDs = Set(currentValue.map(\.id))
        let previousIDs = Set(previousValue.map(\.id))
        
        let idsToRemove = currentIDs.subtracting(previousIDs)
        let idsToInsert = previousIDs.subtracting(currentIDs)
        let idsToUpdate = currentIDs.intersection(previousIDs)
        
        var indicesToRemove: Set<Array<Element>.Index> = []
        var elementsToInsert: Set<IdentifiableArrayReversion<[Element], Element>.Insertion> = []
        var indicesOfMovedInPrevious: [Element.ID : Array<Element>.Index] = [:]
        var indicesOfUpdatedInCurrent: [Element.ID : Array<Element>.Index] = [:]

        for (index, element) in currentValue.enumerated() {
            if idsToRemove.contains(element.id) {
                indicesToRemove.insert(index)
                
            } else if idsToInsert.contains(element.id) {
                elementsToInsert.insert(.init(index: index, element: element))
                
            } else if idsToUpdate.contains(element.id) {
                
                if
                    previousValue.count > index,
                    previousValue[index].id == element.id
                {
                    indicesOfUpdatedInCurrent[element.id] = index
                    
                } else if let previousIndex = previousValue.firstIndex(where: { $0.id == element.id }) {
                    indicesOfMovedInPrevious[element.id] = previousIndex
                }
            }
        }
                        
        if !indicesToRemove.isEmpty {
            let reversion = IdentifiableArrayReversion<[Element], Element>(remove: indicesToRemove)
                .mapped(to: keyPath)
            reversions.append(reversion)
        }
        
        if !elementsToInsert.isEmpty {

            let reversion = IdentifiableArrayReversion(insert: elementsToInsert)
                .mapped(to: keyPath)
            reversions.append(reversion)
        }
        
        for updatedID in idsToUpdate {
            
            if let previousIndex = indicesOfMovedInPrevious[updatedID] {
                let moveReversion = IdentifiableArrayReversion(move: updatedID, to: previousIndex)
                    .mapped(to: keyPath)
                reversions.append(moveReversion)
                appendReversion(at: keyPath.appending(path: \.[previousIndex]))
            } else if let currentIndex = indicesOfUpdatedInCurrent[updatedID] {
                appendReversion(at: keyPath.appending(path: \.[currentIndex]))
            }
        }
    }
}

// MARK: - Dictionary
extension DefaultReverter {

    mutating func appendReversion<Key, Value: Identifiable & Revertable>(at keyPath: WritableKeyPath<Root, [Key : Value]>) {
//
//        var currentByID: [Value.ID : (Key, Value)] = [:]
//        var previousByID: [Value.ID : (Key, Value)] = [:]
//
//        for element in self {
//            currentByID[element.value.id] = element
//        }
//        for element in previous {
//            previousByID[element.value.id] = element
//        }
//
//        let currentIDs = Set(currentByID.keys)
//        let previousIDs = Set(previousByID.keys)
//
//        let retainedIDs = currentIDs.intersection(previousIDs)
//        let insertedIDs = currentIDs.subtracting(previousIDs)
//        let removedIDs = previousIDs.subtracting(currentIDs)
//
//        var restorations: [any ChangeRestoration<Self>] = []
//
//        if !insertedIDs.isEmpty {
//
//            let keysToRemove = insertedIDs
//                .compactMap { currentByID[$0]?.0 }
//            let removeInsertedElementsRestoration = SingleChangeRestoration<Self, Self>(remove: Set(keysToRemove))
//
//            restorations.append(removeInsertedElementsRestoration)
//        }
//
//        if !removedIDs.isEmpty {
//
//            let elementsToInsert = removedIDs
//                .compactMap { previousByID[$0] }
//            let insertRemovedElementsRestoration = SingleChangeRestoration<Self, Self>(insert: elementsToInsert)
//
//            restorations.append(insertRemovedElementsRestoration)
//        }
//
//        for retainedID in retainedIDs {
//            guard
//                let (currentKey, currentElement) = currentByID[retainedID],
//                let (previousKey, previousElement) = previousByID[retainedID],
//                let restoration = currentElement.restoration(toPrevious: previousElement)?.mapped(to: \Self[previousKey].setUnsafelyUnwrapped)
//            else {
//                continue
//            }
//
//            if previousKey != currentKey {
//                let moveToPreviousKeyRestoration = SingleChangeRestoration<Self, Self>(move: (currentKey, previousKey))
//                restorations.append(moveToPreviousKeyRestoration)
//            }
//
//            restorations.append(restoration)
//        }
//
//        guard !restorations.isEmpty else {
//            return nil
//        }
//
//        return ChangeRestorationCollection(restorations)
    }
}

// MARK: - Equatable default reversion
extension DefaultReverter {
    
    private mutating func appendEquatableReversion<Value: Equatable>(at keyPath: WritableKeyPath<Root, Value>) {
        
        let currentValue = current[keyPath: keyPath]
        let previousValue = previous[keyPath: keyPath]
        
        guard currentValue != previousValue else {
            return
        }
        
        let reversion = SingleValueReversion(value: previousValue)
            .mapped(to: keyPath)

        reversions.append(reversion)
    }
}

// MARK: - Array to range
extension Array where Element: BinaryInteger {
    
    func convertToRanges() -> [ClosedRange<Element>] {
        
        var ranges: [ClosedRange<Element>] = []
        var range: ClosedRange<Element>?
        
        for element in self {
            if let currentRange = range {
                switch element {
                case currentRange.lowerBound-1:
                    range = element...currentRange.upperBound

                case currentRange.upperBound+1:
                    range = currentRange.lowerBound...element

                default:
                    ranges.append(currentRange)
                    range = element...element

                }
            } else {
                range = element...element
            }
        }
        
        if let currentRange = range {
            ranges.append(currentRange)
        }
        
        return ranges
    }
}
