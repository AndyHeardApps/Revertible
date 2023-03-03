
protocol ValueReversion<Root> {
    
    // MARK: - Associated types
    associatedtype Root
    
    // MARK: - Functions
    func revert(_ object: inout Root)
    func mapped<NewRoot>(to keyPath: WritableKeyPath<NewRoot, Root>) -> AnyValueReversion<NewRoot>
}
