# Revertible

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

## Versionable Protocol
The main point of contact with this package is the `Versionable` protocol. This protocol requires that `addReversions(into:)` be implemented. This function is intended to be very simple to implement, in a similar style to `Codable`.

The `addReversions(into:)` function provides a single `Reverter` parameter. The `Reverter` is specialised to the calling type (i.e. `Reverter<Self>`), and can be used to register the properties to be monitored for changes by passing `KeyPath`s to the assorted `appendReversion(at:)` functions in a type-safe manner.

This protocol extends `Hashable`, which is used to confirm the `hashValue` of an object before reverting it, and because a lot of logic requires an `Equatable` implementation.

The above `User` struct could be made to adopt the `Versionable` protocol in just a few lines:

```swift
struct User: Versionable {

    var name: String
    var imageData: Data

    func addReversions(into reverter: inout some Reverter<User>) {
        
        reverter.appendReversion(at: \.name)
        reverter.appendReversion(at: \.imageData)
    }    
}
```

And a reversion can be made in a single line:

```swift
var user = User(name: "", imageData: .init())
let original = user
user.name = "Johnny"
let reversion = user.reversion(to: original) // Reversion<User>
```

If no changes are made, then the `reversion(to:)` function returns `nil`.

```swift
let user = User(name: "", imageData: .init())
let reversion = user.reversion(to: user) // nil
```

In order to apply a `Reversion`, use the `revert(_:)` function on the changed version of the object used to create the reversion:

```swift
var user = User(name: "", imageData: .init())
let original = user
user.name = "Johnny"
let reversion = user.reversion(to: original) // Reversion<User>

print(user.name) // "Johnny"
try reversion.revert(&user)
print(user.name) // ""
```

Attempting to revert a version of the object that wasn't used to create the reversion will throw an error:

```swift
var user = User(name: "", imageData: .init())
let original = user
user.name = "Johnny"
let reversion = user.reversion(to: original) // Reversion<User>
user.name = "Johnny Appleseed"

try reversion.revert(&user) // throws error
```

Instead a new reversion needs to be made, either from the latest version, back to the original, or by using two reversions, and applying them from newest to oldest.

```swift
var user = User(name: "", imageData: .init())
let original = user
user.name = "Johnny"
let reversion1 = user.reversion(to: original) // Reversion<User>
user.name = "Johnny Appleseed"
let reversion2 = user.reversion(to: original) // Reversion<User>

print(user.name) // "Johnny Appleseed"
try reversion2.revert(&user)
print(user.name) // ""
```

```swift
var user = User(name: "", imageData: .init())
let original = user
user.name = "Johnny"
let reversion1 = user.reversion(to: original) // Reversion<User>
user.name = "Johnny Appleseed"
let reversion2 = user.reversion(to: original) // Reversion<User>

print(user.name) // "Johnny Appleseed"
try reversion2.revert(&user)
print(user.name) // "Johnny"
try reversion1.revert(&user)
print(user.name) // ""
```

This way, reversions can be stored in a stack and applied as needed.

## `UndoController`
The `UndoController` is a class to help manage reversions.

It has actions registered against it either as closures, or by providing some `Versionable` value. These are sorted into stacks and applied on a last in first out basis. When an action is undone, it is automatically converted to a redo action.
