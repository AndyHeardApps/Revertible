/// Provides a simplified interface for conforming a type to the ``Revertable`` protocol, by registering which keypaths are to be monitored for changes.
///
/// The adopting type must implement the ``Versionable/addReversions(into:)`` function and register the properties that will have changes tracked and stored in the ``Reversion`` produced by the ``Revertable/Revertable/reversion(to:)`` function.
///
/// For example:
///
/// ```swift
/// struct Person: Versionable {
///
///     var name: String
///     var age: Int
///
///     func addReversions(into reverter: inout some Reverter<Self>) {
///
///         reverter.appendReversion(at: \.name)
///         reverter.appendReversion(at: \.age)
///     }
/// }
/// ```
public protocol Versionable: Revertable {
    
    // MARK: - Functions
    
    /// Adds reversions to the ``Reverter`` via using the assorted ``Reverter/appendReversion(at:)-2k3an`` functions and passing `KeyPath`s for each revertable property.
    /// - Parameter reverter: The ``Reverter`` to be used to provide reversion information about the type.
    ///
    /// - NOTE: Swift autocomplete will sometimes auto-insert / auto-complete this function with an unspecialised ``Reverter``:
    ///
    /// ```swift
    /// func addReversions(into reverter: inout some Reverter)
    /// ```
    ///
    /// Instead the ``Reverter`` should be declared as `Reverter<Self>`:
    ///
    /// ```swift
    /// func addReversions(into reverter: inout some Reverter<Self>)
    /// ```
    func addReversions(into reverter: inout some Reverter<Self>)
}

// MARK: - Default revertable implementation
extension Versionable {
    
    public func reversion(to previous: Self) -> Reversion<Self>? {
        
        var reverter = DefaultReverter(current: self, previous: previous)
        reverter.appendReversion(at: \.self)
        
        guard let reverterReversion = reverter.erasedToAnyValueReversion() else {
            return nil
        }
        
        let reversion = Reversion(
            root: self,
            reversion: reverterReversion
        )
        
        return reversion
    }
}
