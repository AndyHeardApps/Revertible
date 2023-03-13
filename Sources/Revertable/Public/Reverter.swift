import Foundation

/// A type that allows a number of `KeyPath`s on an instance of the ``Root`` type to be registered for tracking and reversion.
public protocol Reverter<Root> {
    
    // MARK: - Associated type
    associatedtype Root
    
    // MARK: - Functions
    
    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, some Revertable>)
    
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
    
    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Float16>)

    
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
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, [some Equatable]>)
    
    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, [some Identifiable & Revertable]>)
    
    
    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, [some Hashable : some Equatable]>)
    
    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, [some Hashable : some Identifiable & Revertable]>)
    
    
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
    
    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, Float16?>)

    
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
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, [some Equatable]?>)
    
    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, [some Identifiable & Revertable]?>)


    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, [some Hashable : some Equatable]?>)

    /// Registers a `WritableKeyPath` on the type to be reverted if it has changed.
    /// - Parameter keyPath: The `WritableKeyPath` pointing towards the property to be reverted.
    mutating func appendReversion(at keyPath: WritableKeyPath<Root, [some Hashable : some Identifiable & Revertable]?>)
}
