
## Reasoning

The `UndoManager` in Foundation is cumbersome to use, with a lot of boilerplate involved in adding undo and redo actions. With it being closure based, it can be easy to let a retain cycle slip in, while also possibly retaining full copies of large state data, just in case the undo action is applied.

Consider a situation where a large nested model has a minor change made. A naive approach would be for the `UndoManager` to hold on to the entirity of the old value, in case it is needed in an undo action. A better approach would be to just track what has changed and where, but this adds more complexity to an already bloated method of tracking changes.

This framework aims to ease those pains, with piecewise storage of only what has changed in a value, and a simple interface with which to push versions of a value onto the version stack. When an updated value is pushed onto the version stack, each property is inspected for changes, recursively, so that only the individual values that have changed are used. These values are then stored alongside their `KeyPath` in a lightweight struct. If no changes have occurred, then nothing happens. These `Reversion` values can then be applied to the updated object to revert it to the previous state.

This method means that individual reversions do not know about the object that created them, resulting in a lower memory footprint and no risk of a memory leak. The `Reversion` type is what drives this framework.

The framework has been designed to support basic types such as `Int` and `Bool` out of the box, as well as other common types such as `UUID` and basic collections like `Data`, `String`, `Array` etc. This allows more complex types to be used by combining these basic implementations.

### Macros

### Manual conformance

### Manual reversion handling

Reversions can be created and managed manually. Suppose we have the `User` struct below:

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

A reversion can be made in a single line:

```swift
var user = User(name: "", imageData: .init())
let original = user
user.name = "Johnny"
let reversion = user.reversion(to: original) // Reversion<User>
```

If no changes are made, then the `reversion(to:)` function returns nil.

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

# License
This project is licensed under the terms of the MIT license.
