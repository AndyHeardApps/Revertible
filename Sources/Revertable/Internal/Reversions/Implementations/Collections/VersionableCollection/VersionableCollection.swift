
protocol VersionableCollection {
    
    // MARK: - Associated types
    associatedtype CollectionReversion: ValueReversion<Self>
    
    // MARK: - Functions
    func collectionReversions(to previousValue: Self) -> [CollectionReversion]
}
