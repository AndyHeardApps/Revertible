import Foundation

struct DefaultReverter<Root> {
    
    // MARK: - Properties
    private let current: Root
    private let previous: Root
    private var reversions: [AnyValueReversion<Root>] = []
    var count: Int {
        reversions.count
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

// MARK: - Any value reversion conversion
extension DefaultReverter {
    
    func erasedToAnyValueReversion() -> AnyValueReversion<Root>? {
        
        switch reversions.count {
        case 0:
            return nil
            
        case 1:
            return reversions[0]
            
        default:
            return MultipleValueReversion(reversions)
                .erasedToAnyValueReversion()

        }
    }
}

// MARK: - Reverter
extension DefaultReverter: Reverter {}

// MARK: - Revertable
extension DefaultReverter {
    
    mutating func appendOverwriteReversion<Value>(at keyPath: WritableKeyPath<Root, Value>) {
        
        let previousValue = previous[keyPath: keyPath]

        let reversion = SingleValueReversion(value: previousValue).mapped(to: keyPath)
        
        reversions.append(reversion)
    }
    
    mutating func appendReversion<Value: Revertable>(at keyPath: WritableKeyPath<Root, Value>) {
        
        let currentValue = current[keyPath: keyPath]
        let previousValue = previous[keyPath: keyPath]
        
        var reverter = DefaultReverter<Value>(
            current: currentValue,
            previous: previousValue
        )
        currentValue.addReversions(into: &reverter)
        
        guard let reversion = reverter.erasedToAnyValueReversion()?.mapped(to: keyPath) else {
            return
        }
        
        reversions.append(reversion)
    }
    
    mutating func appendReversion<Value: Revertable>(at keyPath: WritableKeyPath<Root, Value?>) {
        
        let currentValue = current[keyPath: keyPath]
        let previousValue = previous[keyPath: keyPath]
                
        switch (currentValue, previousValue) {
        case (.none, .some), (.some, .none), (.none, .none):
            appendEquatableReversion(at: keyPath)
            
        case let (.some(currentValue), .some(previousValue)):
            
            var reverter = DefaultReverter<Value>(
                current: currentValue,
                previous: previousValue
            )
            currentValue.addReversions(into: &reverter)

            guard let reversion = reverter.erasedToAnyValueReversion()?.mapped(to: keyPath.appending(path: \.setUnsafelyUnwrapped)) else {
                return
            }
            
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
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Int?>) {
        appendEquatableReversion(at: keyPath)
    }
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Int64?>) {
        appendEquatableReversion(at: keyPath)
    }
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Int32?>) {
        appendEquatableReversion(at: keyPath)
    }
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Int16?>) {
        appendEquatableReversion(at: keyPath)
    }
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Int8?>) {
        appendEquatableReversion(at: keyPath)
    }
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, UInt?>) {
        appendEquatableReversion(at: keyPath)
    }
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, UInt64?>) {
        appendEquatableReversion(at: keyPath)
    }
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, UInt32?>) {
        appendEquatableReversion(at: keyPath)
    }
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, UInt16?>) {
        appendEquatableReversion(at: keyPath)
    }
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, UInt8?>) {
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
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Double?>) {
        appendEquatableReversion(at: keyPath)
    }
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Float?>) {
        appendEquatableReversion(at: keyPath)
    }
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Float16?>) {
        appendEquatableReversion(at: keyPath)
    }
}

// MARK: - Date
extension DefaultReverter {
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Date>) {
        appendEquatableReversion(at: keyPath)
    }
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Date?>) {
        appendEquatableReversion(at: keyPath)
    }
}

// MARK: - UUID
extension DefaultReverter {
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, UUID>) {
        appendEquatableReversion(at: keyPath)
    }
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, UUID?>) {
        appendEquatableReversion(at: keyPath)
    }
}

// MARK: - String
extension DefaultReverter {
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, String>) {
        appendCollectionReversion(at: keyPath)
    }
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, String?>) {
        appendCollectionReversion(at: keyPath)
    }
}

// MARK: - Data
extension DefaultReverter {
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Data>) {
        appendCollectionReversion(at: keyPath)
    }
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Data?>) {
        appendCollectionReversion(at: keyPath)
    }
}

// MARK: - Set
extension DefaultReverter {
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Set<some Hashable>>) {
        appendCollectionReversion(at: keyPath)
    }
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Set<some Hashable>?>) {
        appendCollectionReversion(at: keyPath)
    }
}

// MARK: - Array
extension DefaultReverter {
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, [some Equatable]>) {
        appendCollectionReversion(at: keyPath)
    }
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, [some Identifiable & Revertable]>) {
        appendIdentifiableCollectionReversion(at: keyPath)
    }
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, [some Equatable]?>) {
        appendCollectionReversion(at: keyPath)
    }
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, [some Identifiable & Revertable]?>) {
        appendIdentifiableCollectionReversion(at: keyPath)
    }
}

// MARK: - Dictionary
extension DefaultReverter {
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, [some Hashable : some Equatable]>) {
        appendCollectionReversion(at: keyPath)
    }
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, [some Hashable : some Identifiable & Revertable]>) {
        appendIdentifiableCollectionReversion(at: keyPath)
    }
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, [some Hashable : some Equatable]?>) {
        appendCollectionReversion(at: keyPath)
    }
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, [some Hashable : some Identifiable & Revertable]?>) {
        appendIdentifiableCollectionReversion(at: keyPath)
    }
}

// MARK: - Reversion mapping and appending
extension DefaultReverter {
    
    private mutating func appendMappedReversions<Value>(
        _ reversions: [some ValueReversion<Value>],
        at keyPath: WritableKeyPath<Root, Value>
    ) {
        
        guard !reversions.isEmpty else {
            return
        }
        
        let mappedReversions = reversions
            .map { $0.mapped(to: keyPath) }
        
        self.reversions.append(contentsOf: mappedReversions)
    }
}

// MARK: - Equatable reversions
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

// MARK: - Revertable collection reversions
extension DefaultReverter {
    
    mutating func appendCollectionReversion(at keyPath: WritableKeyPath<Root, some RevertableCollection>) {
        
        let currentValue = current[keyPath: keyPath]
        let previousValue = previous[keyPath: keyPath]
        
        let reversions = currentValue.collectionReversions(to: previousValue)
        appendMappedReversions(reversions, at: keyPath)
    }
    
    mutating func appendCollectionReversion(at keyPath: WritableKeyPath<Root, (some RevertableCollection & Equatable)?>) {
        
        let currentValue = current[keyPath: keyPath]
        let previousValue = previous[keyPath: keyPath]
        
        guard currentValue != previousValue else {
            return
        }

        switch (currentValue, previousValue) {
        case (.none, .some), (.some, .none), (.none, .none):
            appendEquatableReversion(at: keyPath)
            
        case let (.some(currentValue), .some(previousValue)):
            let reversions = currentValue.collectionReversions(to: previousValue)
            appendMappedReversions(reversions, at: keyPath.appending(path: \.setUnsafelyUnwrapped))

        }
    }
}

// MARK: - Revertable identifiable collection reversions
extension DefaultReverter {
    
    mutating func appendIdentifiableCollectionReversion(at keyPath: WritableKeyPath<Root, some RevertableIdentifiableCollection>) {
        
        let currentValue = current[keyPath: keyPath]
        let previousValue = previous[keyPath: keyPath]
        
        let reversions = currentValue.identifiableCollectionReversions(to: previousValue)
        appendMappedReversions(reversions, at: keyPath)
    }
    
    mutating func appendIdentifiableCollectionReversion(at keyPath: WritableKeyPath<Root, (some RevertableIdentifiableCollection & Equatable)?>) {
        
        let currentValue = current[keyPath: keyPath]
        let previousValue = previous[keyPath: keyPath]
        
        guard currentValue != previousValue else {
            return
        }

        switch (currentValue, previousValue) {
        case (.none, .some), (.some, .none), (.none, .none):
            appendEquatableReversion(at: keyPath)
            
        case let (.some(currentValue), .some(previousValue)):
            let reversions = currentValue.identifiableCollectionReversions(to: previousValue)
            appendMappedReversions(reversions, at: keyPath.appending(path: \.setUnsafelyUnwrapped))

        }
    }
}
