
struct SingleValueReversion<Root, Value> {

    // MARK: - Properties
    private let keyPath: WritableKeyPath<Root, Value>
    private let value: Value
    
    // MARK: - Initialiser
    init(
        keyPath: WritableKeyPath<Root, Value>,
        value: Value
    ) {
        
        self.keyPath = keyPath
        self.value = value
    }
}

// MARK: - Value reversion
extension SingleValueReversion: ValueReversion {
    
    func revert(_ object: inout Root) {
        
        object[keyPath: keyPath] = value
    }
}
