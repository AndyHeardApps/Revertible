import Foundation

public protocol Reverter<Root> {
    
    // MARK: - Associated type
    associatedtype Root
    
    // MARK: - Functions
    mutating func appendReversion<Value: Revertable>(at keyPath: WritableKeyPath<Root, Value>)
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Int>)
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Int64>)
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Int32>)
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Int16>)
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Int8>)
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, UInt>)
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, UInt64>)
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, UInt32>)
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, UInt16>)
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, UInt8>)

    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Double>)
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Float>)
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Float16>)

    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Date>)

    mutating func appendReversion(at keyPath: WritableKeyPath<Root, String>)
    
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Data>)
    
    mutating func appendReversion<Element>(at keyPath: WritableKeyPath<Root, Set<Element>>)

    mutating func appendReversion<Element: Equatable>(at keyPath: WritableKeyPath<Root, [Element]>)
    mutating func appendReversion<Element: Identifiable & Revertable>(at keyPath: WritableKeyPath<Root, [Element]>)
    
    mutating func appendReversion<Key, Value: Equatable>(at keyPath: WritableKeyPath<Root, [Key : Value]>)
    mutating func appendReversion<Key, Value: Identifiable & Revertable>(at keyPath: WritableKeyPath<Root, [Key : Value]>)
}
