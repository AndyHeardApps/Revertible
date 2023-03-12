
// MARK: - Optional key path
extension Optional {
    
    var setUnsafelyUnwrapped: Wrapped {
        get {
            self.unsafelyUnwrapped
        }
        set {
            self = newValue
        }
    }
}
