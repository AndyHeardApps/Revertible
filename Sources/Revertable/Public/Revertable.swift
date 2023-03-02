
public protocol Revertable {
    
    // MARK: - Functions
    func addReversions(to previous: Self, into reverter: inout some Reverter<Self>)
}
