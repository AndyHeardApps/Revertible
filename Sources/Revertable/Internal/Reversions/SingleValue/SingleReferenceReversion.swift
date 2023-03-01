
struct SingleReferenceReversion<Root, Value> {
    
    // MARK: - Properties
    private let keyPath: ReferenceWritableKeyPath<Root, Value>
    private let value: Value
    
    // MARK: - Initialiser
    init(
        keyPath: ReferenceWritableKeyPath<Root, Value>,
        value: Value
    ) {
        
        self.keyPath = keyPath
        self.value = value
    }
}

// MARK: - Reference reversion
extension SingleReferenceReversion: ReferenceReversion {
    
    func revert(_ object: Root) {
        
        object[keyPath: keyPath] = value
    }
}
