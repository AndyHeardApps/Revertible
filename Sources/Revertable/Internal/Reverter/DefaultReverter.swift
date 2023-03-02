
struct DefaultReverter<Root> {
    
    // MARK: - Properties
    private let current: Root
    private let previous: Root
    private var reversions: [any ValueReversion<Root>] = []
    
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
extension DefaultReverter: Reverter {
    
    mutating func appendReversion<Value: Revertable>(at keyPath: WritableKeyPath<Root, Value>) {
        
        let currentValue = current[keyPath: keyPath]
        let previousValue = previous[keyPath: keyPath]
        
        var reversion = DefaultReverter<Value>(
            current: currentValue,
            previous: previousValue
        )
        currentValue.addReversions(to: previousValue, into: &reversion)
        
    }
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Int>) {
        
        let currentValue = current[keyPath: keyPath]
        let previousValue = previous[keyPath: keyPath]
        
        guard currentValue != previousValue else {
            return
        }
        
        let reversion = SingleValueReversion(value: previousValue).mapped(to: keyPath)
        reversions.append(reversion)
    }
}
