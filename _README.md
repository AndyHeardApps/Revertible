
## Reasoning

The `UndoManager` in Foundation is cumbersome to use, with a lot of boilerplate involved in adding undo and redo actions. With it being closure based, it can be easy to let a retain cycle slip in, while also possibly retaining full copies of large state data, just in case the undo action is applied.

Consider a situation where a large amount of text has a minor change made. A naive approach would be for the `UndoManager` to hold on to the entirity of the old value, in case it is needed in an undo action. A better approach would be to just track the changes, but this adds more complexity to an already bloated method of tracking changes.

This framework aims to ease those pains, with piecewise storage of only what has changed in a value, and a simple interface with which to push versions of a value onto the version stack. When an updated value is pushed onto the version stack, each property is inspected for changes, recursively, so that only the individual values that have changed are used. These values are then stored alongside their `KeyPath` in a lightweight struct. If no changes have occurred, then nothing happens. These `Reversion` values can then be applied to the updated object to revert it to the previous state.

This method means that individual reversions do not know about the object that created them, resulting in a lower memory footprint and no risk of a memory leak. The `Reversion` type is what drives this framework.

Consider the string scenario above. If the only change was to add a period to the end of a 5000 line document, all that really needs to be stored is where that period was added, and how to undo it. Storing once character alongside a `KeyPath` uses considerably less memory than storing the old and new versions of the string.

The framework has been designed to support basic types such as `Int` and `Bool` out of the box, as well as other common types such as `UUID` and basic collections like `Data`, `String`, `Array` etc. This allows more complex types to be used by combining these basic implementations.

For more information on how the framework operates, check the [Type conformance](#type-conformance) section below.

## `VersioningController`

Other than the `@Versioned` property wrapper, the other way to easily handle version of a value is with the `VersioningController`. Each instance of a `VersioningController` can only manage a single value, so the best practice is to consolidate all of your state into a single type.

There are a few different ways to use the `VersioningController`. They are mostly the same, but there are some points to be aware of.

### Direct tracking

Direct tracking is the simplest implementation, and is used by creating an instance with the `init(_ value: _)` initializer. Use this method when you want to track an entire object at the root level. For instance if you have some state you don't own but still want to track from some other type, such as when state is provided by some third party library or `@Environment`.

Once an instance has been made, versions can be pushed using the `append(_ newValue: _)` function, which will check for any changes and store them in the version stack. Versions are stored in a last in - first out basis. The status of the `VersioningController` can be inspected with the `hasUndo` and `hasRedo` properties, and there are a couple of `undo` and `redo` variations available. One implementation for each function returns the undone / redone value, and the other accepts an `inout` parameter that is updated in place.

This allows you to add and get versions externally. For those enjoying TCA, this is the best way to manage your reducer's `State`.

### Key path tracking

Key path tracking is functionally the same as the direct tracking method, but it accepts a `WritableKeyPath` in the `public init(on root: _, at keyPath: _)` initializer. This allows you to point to just a single property of a value to track, and also provides convenience methods that allow you to push and revert versions using the `Root` value of the key path.

### Reference key path tracking

Reference key path tracking is the same as key path tracking, but when the `Root` type of the key path is a reference type. This allows the `VersioningController` to hold on to a weak reference of the root, and perform `undo()` and `redo()` functions directly on that weak reference. This mode provides a more basic `undo()` and `redo()` functions that don't accept any parameters or return any values, but instead directly modifies the root.

### Tags


### Error handling

Many of the functions on `VersioningController` can throw errors, which can be cumbersome to handle, especially in a SwiftUI view. Most of the time, we would just wrap the call in a `do - catch` block and assign the error to some observed property. This is boilerplate heavy, and to help reduce the need for such code, the `VersioningController` has a couple of convenience initializers available when the `Root` of the type is a reference type. 

These initializers accept a `WritableKeyPath` to an optional `Error?` property on the root instance. Whenever an error is thrown internally, it is caught and assigned to this property. If the `Root` is an `@Observable` or `ObservableObject` type, then it is notified of the update. When using one of these initializers, the other functions on this type such as `undo()` etc. no longer throw, removing the need to manually handle errors.

## Type conformance


### `Revertible`


### `Versionable`


### `Reversion`

### `Reverter`

### Macros

The macros provided provide a default implementation for `Versionable` for value types, and are not exhaustive, they just intend to avoid boilerplate code where possible.

For a `struct`, every mutable, stored property is added to the generated `func addReversions(into reverter: inout some Reverter<Self>)` function, which is suitable for many models.

For an `enum`, every associated value has a private getter and setter generated, as well as a child `CaseName` `enum` ghosting the parent `enum`, but with no associated values. The `func addReversions(into reverter: inout some Reverter<Self>)` function first checks if the case of the enum has changed, and if so the whole value is overwritten. If the case is the same, and just some of the associated values have changed, then those changes are appended for each key path, much the same as with the `struct` implementation.

For some models, you may wish to ignore individual properties, but not want to have to manually declare `func addReversions(into reverter: inout some Reverter<Self>)` to simply omit one property. The `@VersionableIgnored` macro instructs the `@Versionable` macro to ignore that property when generating the code. This macro can only be applied to `struct` properties, as in an `enum`, individual associated values are required to track `self` at all.

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
