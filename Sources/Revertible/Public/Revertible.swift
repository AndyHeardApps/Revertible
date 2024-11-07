
/// Defines an interface for types to be able to produce a ``Reversion`` object, allowing changes to the object to be tracked and stored for later reversion to a prior state.
///
/// Many common types conform to this protocol by default, including collections like `Array`, `Set`, `Dictionary`, `Data` and `String`. The simplest way to conform to this protocol is to instead adopt the ``Versionable`` protocol, which extends ``Revertible/Revertible``.
///
/// A ``Reversion`` can be created by calling the ``Revertible/Revertible/reversion(to:)`` and applied using the ``Reversion/revert(_:)`` functions:
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
public protocol Revertible: Hashable {
        
    /// Creates a ``Reversion`` to the previous version of the object.
    ///
    /// The returned ``Reversion`` will revert the calling object back to the state of the `previous` parameter.
    ///
    /// If the calling object and `previous` parameter are equal, then `nil` is returned.
    /// - Parameter previous: Some other instance or previous version of the calling type that the returned ``Reversion`` will revert the calling object to.
    /// - Returns: A ``Reversion`` that will update the state of the calling instance to `previous`, or `nil` if the two are equal.
    func reversion(to previous: Self) -> Reversion<Self>?
}
