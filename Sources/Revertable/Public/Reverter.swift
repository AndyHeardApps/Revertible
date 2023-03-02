
public protocol Reverter<Root> {
    
    // MARK: - Associated type
    associatedtype Root
    
    // MARK: - Functions
    mutating func appendReversion<Value: Revertable>(at keyPath: WritableKeyPath<Root, Value>)
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Int>)
}
