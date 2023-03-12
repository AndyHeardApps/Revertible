
protocol RevertableCollection {
    
    // MARK: - Associated types
    associatedtype Reversion: ValueReversion<Self>
    
    // MARK: - Functions
    func reversions(to previousValue: Self) -> [Reversion]
}
