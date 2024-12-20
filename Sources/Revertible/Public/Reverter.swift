import Foundation

/// A type that allows a number of `KeyPath`s on an instance of the ``Root`` type to be registered for tracking and reversion.
public protocol Reverter<Root> {
    
    // MARK: - Associated type
    associatedtype Root
    
    // MARK: - Functions
    
    /// Indicates whether or not the property at the provided key path is different to the previous value.
    /// - Parameter keyPath: The key path the check for changes.
    /// - Returns: Whether or not the value at the key path has changed.
    func hasChanged<Value: Equatable>(at keyPath: KeyPath<Root, Value>) -> Bool

    /// Registers a `WritableKeyPath` on the type to be overwritten on reversion. This is considerably less efficient than the diffing `appendReversion` functions available and should only be used when necessary, such as when a property is immutable and `\.self` must be used, or when the diffing logic is not needed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendOverwriteReversion<Value: Equatable>(at keyPath: WritableKeyPath<Root, Value>)
    
    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, some Versionable>)

    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, (some Versionable)?>)

    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Bool>)

    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Bool?>)

    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Int>)
    
    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Int64>)
    
    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Int32>)
    
    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Int16>)
    
    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Int8>)
    
    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, UInt>)
    
    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, UInt64>)
    
    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, UInt32>)
    
    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, UInt16>)
    
    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, UInt8>)

    
    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Double>)
    
    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Float>)
    
    #if os(iOS)
    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Float16>)
    #endif
    
    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Date>)

    
    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, String>)
    
    
    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Data>)

    
    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, UUID>)

    
    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Set<some Hashable>>)

    
    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, [some Identifiable & Versionable]>)
    
    
    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, [some Hashable : some Identifiable & Versionable]>)
    
    
    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Int?>)
    
    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Int64?>)
    
    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Int32?>)
    
    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Int16?>)
    
    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Int8?>)
    
    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, UInt?>)
    
    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, UInt64?>)
    
    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, UInt32?>)
    
    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, UInt16?>)
    
    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, UInt8?>)

    
    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Double?>)
    
    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Float?>)
    
    #if os(iOS)
    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Float16?>)
    #endif
    
    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Date?>)
    

    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, UUID?>)

    
    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, String?>)
    
    
    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Data?>)
    
    
    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Set<some Hashable>?>)

    
    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, [some Identifiable & Versionable]?>)


    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, [some Hashable : some Identifiable & Versionable]?>)
}
