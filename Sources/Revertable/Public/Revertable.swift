
// TODO: - Memory checking? See if its smaller to have the reversions or just fully copies of the object?
public protocol Revertable: Hashable {
    
    // MARK: - Functions
    func addReversions(into reverter: inout some Reverter<Self>)
}

extension Revertable {
    
    public func reversion(to previous: Self) -> Reversion<Self>? {
        
        var reverter = DefaultReverter(current: self, previous: previous)
        reverter.appendReversion(at: \.self)
        
        guard !reverter.isEmpty else {
            return nil
        }
        
        let reversion = Reversion(
            root: self,
            reverter: reverter
        )
        
        return reversion
    }
}
