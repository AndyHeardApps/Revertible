
public protocol Reverter {
    
    // MARK: - Functions
    func appendReversion<Value: Revertable>(
        to previous: Value,
        at keyPath: WritableKeyPath<Self, Value>
    )
    
    func appendReversion<Element: Revertable>(
        to previous: Set<Element>,
        at keyPath: WritableKeyPath<Self, Set<Element>>
    )
    
    func appendReversion<Element: Revertable>(
        to previous: [Element],
        at keyPath: WritableKeyPath<Self, [Element]>
    )
    
    func appendReversion<Key: Hashable, Value: Revertable>(
        to previous: [Key : Value],
        at keyPath: WritableKeyPath<Self, [Key : Value]>
    )
}
