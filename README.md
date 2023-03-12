# Revertable

Allows some value type to be able to create a `Reversion` object, that will revert any changed properties back to their original values. This allows states to be stored without storing copies of the whole object.

### Example:

Say there is some `User` object:

```swift
struct User {

    var name: String
    var imageData: Data
}
```

Should the user update the `name` property, and you want to be able to store previous versions of the object for use in an `UndoManager` you could either:
- Create a lot of property by property boilerplate code to register changes with the `UndoManager`. This can be hard to maintain and annoying to write.
- Store a version of the object after every change or every few seconds. This would mean creating a duplicate of the potentially large, and unchanged `imageData` property, which is purely wasted memory.

This package aims to provide a lightweight, simple, type-safe and efficient way of storing only the changes on an object, and allowing a single function to restore an object to a previous state.

## Revertable Protocol
The main point of contact with this package is the `Revertable` protocol. This protocol requires that a `addReversions(into:)` be implemented. This function is intended to be very simple to implement, in a similar style to `Codable`.

The `addReversions(into:)` function provides a single `Reverter` parameter. The `Reverter` is specialised to the calling type (i.e. `Reverter<Self>`), and can be used to register the properties to be monitored for changes by passing `KeyPath`s to the assorted `appendReversion(at:)` functions in a type-safe manner.

This protocol extends `Hashable`, which is used to confirm the `hashValue` of an object before reverting it, and because a lot of logic requires an `Equatable` implementation.

The above `User` struct could be made to adopt the `Revertable` protocol in just a few lines:

```swift
struct User: Revertable {

    var name: String
    var imageData: Data

    func addReversions(into reverter: inout some Reverter<User>) {
        
        reverter.appendReversion(at: \.name)
        reverter.appendReversion(at: \.imageData)
    }    
}
```
