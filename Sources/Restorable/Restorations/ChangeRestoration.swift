protocol ChangeRestoration<Root> {
    
    // MARK: - Associated types
    associatedtype Root
    
    // MARK: - Functions
    func restore(_ object: inout Root)
    func mapped<NewRoot>(to keyPath: WritableKeyPath<NewRoot, Root>) -> any ChangeRestoration<NewRoot>
}
