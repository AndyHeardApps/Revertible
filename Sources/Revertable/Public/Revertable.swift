/// Allows a type to register and track changes between two instances, allowing for reversion from one state to another.
///
/// A type must implement the ``addReversions(into:)`` function and register the properties that will have changes tracked and reversions stored in the ``Reversion`` produced by the ``reversion(to:)`` function.
///
/// For example:
///
/// ```swift
/// struct Person: Revertable {
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
///
/// A ``Reversion`` can then be created and applied:
///
/// ```swift
/// var person = Person(name: "Nick", age: 10)
/// let originalPerson = person
/// person.age = 12
/// let reversion = person.reversion(to: originalPerson)
///
/// print(person.age) // 12
/// reversion?.revert(&person)
/// print(person.age) // 10
/// ```
///
/// While it's intended that this protocol be used on value types, it can be used on `class` types too, as long as the properties are delcared as `var`.
public protocol Revertable: Hashable {
    
    // MARK: - Functions
    
    /// Adds reversions to the ``Reverter`` via using the assorted ``Reverter/appendReversion(at:)-48y9u`` functions and passing `KeyPath`s for each revertable property.
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

extension Revertable {
    
    /// Creates a ``Reversion`` to a the previous version of the object.
    ///
    /// The returned ``Reversion`` will revert the calling object back to the state of the `previous` parameter.
    ///
    /// If the calling object and `previous` parameter are equal, then `nil` is returned.
    /// - Parameter previous: Some other instance or previous version of the calling type that the returned ``Reversion`` will revert the calling object to.
    /// - Returns: A ``Reversion`` that will update the state of the calling instance to `previous`, or `nil` if the two are equal.
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
