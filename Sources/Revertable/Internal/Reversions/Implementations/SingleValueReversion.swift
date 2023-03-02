
struct SingleValueReversion<Root, Value> {

    // MARK: - Properties
    private let keyPath: WritableKeyPath<Root, Value>
    private let value: Value
    
    // MARK: - Initialisers
    init(value: Value) where Root == Value {
        
        self.keyPath = \.self
        self.value = value
    }
    
    private init(
        keyPath: WritableKeyPath<Root, Value>,
        value: Value
    ) {
        
        self.keyPath = keyPath
        self.value = value
    }
}

// MARK: - Value reversion
extension SingleValueReversion: ValueReversion {
    
    typealias Mapped = SingleValueReversion
    
    func revert(_ object: inout Root) {
        
        object[keyPath: keyPath] = value
    }

    func mapped<NewRoot>(to keyPath: WritableKeyPath<NewRoot, Root>) -> SingleValueReversion<NewRoot, Value> {
        
        SingleValueReversion<NewRoot, Value>(
            keyPath: keyPath.appending(path: self.keyPath),
            value: value
        )
    }
}
