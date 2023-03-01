
protocol ValueReversion {
    
    // MARK: - Associated types
    associatedtype Root
    
    // MARK: - Functions
    func revert(_ object: inout Root)
}
