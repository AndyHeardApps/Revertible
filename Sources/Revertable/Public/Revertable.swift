
public protocol Revertable {
    
    // MARK: - Functions
    func addReversions(to previous: Self, into reverter: some Reverter)
}
