
protocol RevertableIdentifiableCollection {
    
    // MARK: - Associated types
    associatedtype IdentifiableCollectionReversion: ValueReversion<Self>
    
    // MARK: - Functions
    func identifiableCollectionReversions(to previousValue: Self) -> [IdentifiableCollectionReversion]
}
