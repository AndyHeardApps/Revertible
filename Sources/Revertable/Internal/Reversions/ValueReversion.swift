
protocol ValueReversion<Root> {
    
    // MARK: - Associated types
    associatedtype Root
    associatedtype Mapped: ValueReversion
    
    // MARK: - Functions
    func revert(_ object: inout Root)
    func mapped<NewRoot>(to keyPath: WritableKeyPath<NewRoot, Root>) -> Mapped where Mapped.Root == NewRoot
}
