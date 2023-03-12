
extension Optional: Revertable where Wrapped: Revertable {
    
    public func addReversions(into reverter: inout some Reverter<Self>) {
        
        reverter.appendReversion(at: \.self)
    }
}
