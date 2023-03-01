
protocol ReferenceReversion {
    
    // MARK: - Associated types
    associatedtype Root
    
    // MARK: - Functions
    func revert(_ object: Root)
}
