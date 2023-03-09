
struct SingleValueReversion<Root, Value> {

    // MARK: - Properties
    private let value: Value
    private let keyPath: WritableKeyPath<Root, Value>

    // MARK: - Initialisers
    init(
        value: Value,
        at keyPath: WritableKeyPath<Root, Value>
    ) {
        
        self.value = value
        self.keyPath = keyPath
    }
}

// MARK: - Value reversion
extension SingleValueReversion: ValueReversion {
        
    func revert(_ object: inout Root) {
        
        object[keyPath: keyPath] = value
    }

    func mapped<NewRoot>(to keyPath: WritableKeyPath<NewRoot, Root>) -> AnyValueReversion<NewRoot> {
        
        SingleValueReversion<NewRoot, Value>(
            value: value,
            at: keyPath.appending(path: self.keyPath)
        )
        .erasedToAnyValueReversion()
    }
}
