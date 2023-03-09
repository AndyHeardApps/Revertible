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
        
        appendReversion(
            to: previousValue,
            from: currentValue,
            at: keyPath
        )
    }
    
    private mutating func appendReversion<Value: Revertable>(
        to previousValue: Value,
        from currentValue: Value,
        at keyPath: WritableKeyPath<Root, Value>
    ) {
        
        var reverter = DefaultReverter<Value>(
            current: currentValue,
            previous: previousValue
        )
        currentValue.addReversions(into: &reverter)
        
        switch reverter.reversions.count {
        case 0:
            return
            
        case 1:
            let reversion = reverter.reversions[0]
                .mapped(to: keyPath)
            reversions.append(reversion)

        default:
            let reversion = MultipleValueReversion(reverter.reversions)
                .mapped(to: keyPath)
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
            
            let reversion = StringReversion(
                remove: Set(stringIndices),
                fromStringAt: keyPath
            )
            .erasedToAnyValueReversion()

            reversions.append(reversion)
        }
        
        if !elementsToInsert.isEmpty {
            let insertionDictionary = Dictionary(uniqueKeysWithValues: elementsToInsert)
            let rangesToInsert = elementsToInsert.map(\.0).convertToRanges()
            let insertions = rangesToInsert.map { range in
                let elements = range.compactMap { insertionDictionary[$0] }
                let startIndex = currentValue.index(currentValue.startIndex, offsetBy: range.lowerBound)
                
                return StringReversion<Root>.Insertion(
                    index: startIndex,
                    elements: Substring(elements)
                )
            }
            
            let reversion = StringReversion(
                insert: Set(insertions),
                inStringAt: keyPath
            )
            .erasedToAnyValueReversion()

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
            
            let reversion = DataReversion(
                remove: Set(rangesToRemove),
                fromDataAt: keyPath
            )
            .erasedToAnyValueReversion()
            
            reversions.append(reversion)
        }
        
        if !elementsToInsert.isEmpty {
            let insertionDictionary = Dictionary(uniqueKeysWithValues: elementsToInsert)
            let rangesToInsert = elementsToInsert.map(\.0).convertToRanges()
            let insertions = rangesToInsert.map { range in
                let elements = range.compactMap { insertionDictionary[$0] }
                
                return DataReversion<Root>.Insertion(
                    index: range.lowerBound,
                    elements: Data.SubSequence(elements)
                )
            }
            
            let reversion = DataReversion(
                insert: Set(insertions),
                inDataAt: keyPath
            )
            .erasedToAnyValueReversion()
            
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
            
            let reversion = SetReversion(
                remove: elementsToRemove,
                fromSetAt: keyPath
            )
            .erasedToAnyValueReversion()
            
            reversions.append(reversion)
        }
        
        if !elementsToInsert.isEmpty {
            
            let reversion = SetReversion(
                insert: elementsToInsert,
                inSetAt: keyPath
            )
            .erasedToAnyValueReversion()
            
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
        var elementsToInsert: Set<ArrayReversion<Root, Element>.Insertion> = []
        
        for change in difference {
            switch change {
            case let .insert(offset, _, _):
                indicesToRemove.insert(offset)
                
            case let .remove(offset, element, _):
                elementsToInsert.insert(.init(index: offset, element: element))
                
            }
        }
        
        if !indicesToRemove.isEmpty {
            
            let reversion = ArrayReversion(
                remove: indicesToRemove,
                fromArrayAt: keyPath
            )
            .erasedToAnyValueReversion()
            
            reversions.append(reversion)
        }
        
        if !elementsToInsert.isEmpty {
            
            let reversion = ArrayReversion(
                insert: elementsToInsert,
                inArrayAt: keyPath
            )
            .erasedToAnyValueReversion()
            
            reversions.append(reversion)
        }
    }
    
    mutating func appendReversion<Element: Identifiable & Revertable>(at keyPath: WritableKeyPath<Root, [Element]>) {
        
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
        var elementsToInsert: Set<IdentifiableArrayReversion<Root, Element>.Insertion> = []
        var indicesOfMovedInPrevious: [Element.ID : Array<Element>.Index] = [:]
        var indicesOfUpdatedInCurrent: [Element.ID : Array<Element>.Index] = [:]
        
        for (index, element) in currentValue.enumerated() {
            if idsToRemove.contains(element.id) {
                indicesToRemove.insert(index)
                
            } else if idsToUpdate.contains(element.id) {
                
                indicesOfUpdatedInCurrent[element.id] = index
                
                if
                    previousValue.count <= index || previousValue[index].id != element.id,
                    let previousIndex = previousValue.firstIndex(where: { $0.id == element.id })
                {
                    indicesOfMovedInPrevious[element.id] = previousIndex
                }
            }
        }
        
        for (index, element) in previousValue.enumerated() where idsToInsert.contains(element.id) {
            elementsToInsert.insert(.init(index: index, element: element))
        }
        
        if !indicesToRemove.isEmpty {
            
            let reversion = IdentifiableArrayReversion(
                remove: indicesToRemove,
                fromArrayAt: keyPath
            )
            .erasedToAnyValueReversion()
            
            reversions.append(reversion)
        }
        
        if !elementsToInsert.isEmpty {
            
            let reversion = IdentifiableArrayReversion(
                insert: elementsToInsert,
                inArrayAt: keyPath
            )
            .erasedToAnyValueReversion()
            
            reversions.append(reversion)
        }
        
        for updatedID in idsToUpdate {
            
            guard let currentValueIndex = indicesOfUpdatedInCurrent[updatedID] else {
                continue
            }
            
            let currentElementValue: Element
            let previousElementValue: Element
            let elementKeyPath: WritableKeyPath<Root, Element>
            
            if let previousValueIndex = indicesOfMovedInPrevious[updatedID] {
                
                let moveReversion = IdentifiableArrayReversion(
                    move: updatedID,
                    to: previousValueIndex,
                    inArrayAt: keyPath
                )
                .erasedToAnyValueReversion()
                
                reversions.append(moveReversion)

                currentElementValue = currentValue[currentValueIndex]
                previousElementValue = previousValue[previousValueIndex]
                elementKeyPath = keyPath.appending(path: \.[previousValueIndex])
                
            } else {
                
                currentElementValue = currentValue[currentValueIndex]
                previousElementValue = previousValue[currentValueIndex]
                elementKeyPath = keyPath.appending(path: \.[currentValueIndex])
                
            }
            
            appendReversion(
                to: previousElementValue,
                from: currentElementValue,
                at: elementKeyPath
            )
        }
    }
}

// MARK: - Dictionary
extension DefaultReverter {
    
    mutating func appendReversion<Key, Value: Equatable>(at keyPath: WritableKeyPath<Root, [Key : Value]>) {
        
        let currentValue = current[keyPath: keyPath]
        let previousValue = previous[keyPath: keyPath]
        
        guard currentValue != previousValue else {
            return
        }
        
        let currentKeys = Set(currentValue.map(\.key))
        let previousKeys = Set(previousValue.map(\.key))
        
        let keysToRemove = currentKeys.subtracting(previousKeys)
        let keysToInsert = previousKeys.subtracting(currentKeys)
        let keysToUpdate = currentKeys.intersection(previousKeys)
            .filter { currentValue[$0] != previousValue[$0] }
        
        let elementsToInsert = keysToInsert.union(keysToUpdate)
            .compactMap { key -> (Key, Value)? in
                guard let value = previousValue[key] else {
                    return nil
                }
                
                return (key, value)
            }
        
        if !keysToRemove.isEmpty {
            
            let reversion = DictionaryReversion(
                remove: keysToRemove,
                fromDictionaryAt: keyPath
            )
            .erasedToAnyValueReversion()

            reversions.append(reversion)
        }
        
        if !elementsToInsert.isEmpty {
            
            let reversion = DictionaryReversion(
                insert: Dictionary(uniqueKeysWithValues: elementsToInsert),
                inDictionaryAt: keyPath
            )
            .erasedToAnyValueReversion()
            
            reversions.append(reversion)
        }
    }
    
    mutating func appendReversion<Key, Value: Identifiable & Revertable>(at keyPath: WritableKeyPath<Root, [Key : Value]>) {
        
        let currentValue = current[keyPath: keyPath]
        let previousValue = previous[keyPath: keyPath]
        
        guard currentValue != previousValue else {
            return
        }
        
        let currentIDs = Set(currentValue.map(\.value.id))
        let previousIDs = Set(previousValue.map(\.value.id))
        
        let idsToRemove = currentIDs.subtracting(previousIDs)
        let idsToInsert = previousIDs.subtracting(currentIDs)
        let idsToUpdate = currentIDs.intersection(previousIDs)
        
        var keysToRemove: Set<Key> = []
        var elementsToInsert: [Key : Value] = [:]
        var keysOfMovedInPrevious: [Value.ID : Key] = [:]
        var keysOfUpdatedInCurrent: [Value.ID : Key] = [:]
        
        for (key, value) in currentValue {
            if idsToRemove.contains(value.id) {
                keysToRemove.insert(key)
                
            } else if idsToUpdate.contains(value.id) {
                
                keysOfUpdatedInCurrent[value.id] = key
                
                if
                    previousValue[key]?.id != value.id,
                    let previousKey = previousValue.first(where: { $0.value.id == value.id })?.key
                {
                    keysOfMovedInPrevious[value.id] = previousKey
                }
            }
        }
        
        for (key, value) in previousValue where idsToInsert.contains(value.id) {
            elementsToInsert[key] = value
        }
        
        if !keysToRemove.isEmpty {
            
            let reversion = IdentifiableDictionaryReversion(
                remove: keysToRemove,
                fromDictionaryAt: keyPath
            )
            .erasedToAnyValueReversion()
            
            reversions.append(reversion)
        }
        
        if !elementsToInsert.isEmpty {
            
            let reversion = IdentifiableDictionaryReversion(
                insert: elementsToInsert,
                inDictionaryAt: keyPath
            )
            .erasedToAnyValueReversion()
            
            reversions.append(reversion)
        }
        
        for updatedID in idsToUpdate {
            
            guard let currentValueKey = keysOfUpdatedInCurrent[updatedID] else {
                continue
            }
            
            let currentElementValue: Value
            let previousElementValue: Value
            let elementKeyPath: WritableKeyPath<Root, Value>
            
            if let previousValueKey = keysOfMovedInPrevious[updatedID] {
                
                let moveReversion = IdentifiableDictionaryReversion(
                    move: currentValueKey,
                    to: previousValueKey,
                    inDictionaryAt: keyPath
                )
                .erasedToAnyValueReversion()
                
                reversions.append(moveReversion)

                currentElementValue = currentValue[currentValueKey]!
                previousElementValue = previousValue[previousValueKey]!
                elementKeyPath = keyPath.appending(path: \.[previousValueKey].setUnsafelyUnwrapped)
                
            } else {
                
                currentElementValue = currentValue[currentValueKey]!
                previousElementValue = previousValue[currentValueKey]!
                elementKeyPath = keyPath.appending(path: \.[currentValueKey].setUnsafelyUnwrapped)
                
            }
            
            appendReversion(
                to: previousElementValue,
                from: currentElementValue,
                at: elementKeyPath
            )
        }
    }
}

// MARK: - Equatable default reversions
extension DefaultReverter {
    
    private mutating func appendEquatableReversion<Value: Equatable>(at keyPath: WritableKeyPath<Root, Value>) {
        
        let currentValue = current[keyPath: keyPath]
        let previousValue = previous[keyPath: keyPath]
        
        guard currentValue != previousValue else {
            return
        }
        
        let reversion = SingleValueReversion(
            value: previousValue,
            at: keyPath
        )
        .erasedToAnyValueReversion()
        
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
