# Revertible

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FAndyHeardApps%2FRevertible%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/AndyHeardApps/Revertible)
![GitHub License](https://img.shields.io/github/license/andyheardapps/Revertible)
![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/andyheardapps/revertible/build.yml)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FAndyHeardApps%2FRevertible%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/AndyHeardApps/Revertible)

This framework aims to add a low friction way to track changes in state, and allow for simple traversal through state history with `undo()` and `redo()` functions.

## Quick start

### Standard usage

```swift
@Versionable
struct MyState {
    var string = ""
    var int = 0
}

final class MyModel {
    @Versioned var state = MyState()
}

let model = MyModel()
model.state.string = "123"
model.state.int = 42
model.$state.undo() // int == 0, string == "123"
model.$state.undo() // int == 0, string == ""
```
### In `@Observable` types

```swift
@Observable
final class MyModel {

    @ObservationIgnored
    private(set) lazy var controller = VersioningController(
        on: self,
        at: \.state,
        using: _$observationRegistrar
    )

    var state: MyState = .init()
}
```

### In `ObservableObject` types

```swift
final class MyModel: ObservableObject {

    private(set) lazy var controller = VersioningController(
        on: self,
        at: \.state
    )

    @Published var state: Person = .init()
}
```

In this case, the tracked property does not have to be `@Published`, but the controller will only register changes when the `objectWillChange` publisher is triggered.

## Basic usage

The easiest way to use this framework is with the `@Versionable` macro, which can be applied to a `struct` or `enum` declaration:

```swift
@Versionable
struct Account {
    let id: Int
    var name: String
    var imageData: Data
    var accountType: AccountType
}

@Versionable
enum AccountType {
    case anonymous
    case verified(emailAddress: String)
    case admin
}
```

The macro generates a conformance to the `Versionable` protocol, as well as some convenience methods in the case of the type being an `enum`. This can then be used with the `@Versioned` property wrapped:

```swift
final class ViewModel {
    @Versioned var account: Account
}
```

This will track all changed made to `account`, and store them efficiently. The `projectedValue` of the property wrapper gives access to undo and redo functionality and more.

```swift
let viewModel = ViewModel(
    account: Account(
        id: 0,
        name: "",
        imageData: .init(),
        accountType: .anonymous
    )
)

viewModel.account.name = "Johnny"
viewModel.account.accountType = .admin

viewModel.$account.undo() // accountType -> .anonymous
viewModel.$account.undo() // name -> ""
viewModel.$account.redo() // name -> "Johnny"
```

In the above case, every individual change will be stored. This includes every individual change to a string as it is typed out by the user, which is a poor experience when performing an undo action one character at a time. To counter this, the `@Versioned` property wrapper has a `debounceInverval` parameter, which groups modifications made in quick succession together:

```swift
@Versioned(debounceInterval: .milliseconds(300))
var account: Account = ...
```

There are also a couple of `setWithTransaction(_ closure: _)` functions that allow you to make modifications within the closure that are all applied at once and stored as a single change in the history.

Any errors that occur with `@Versioned` properties are stored in the `$value.error` property. To have the `undo()`, `redo()` etc. functions instead throw their errors, used the `@ThrowingVersioned` property wrapped.

That's all you need to do. There are different interfaces available for more in depth use cases, such as directly using `VersioningController`, which drives the `@Versioned` property wrapper. This offers a little more flexibility in cases where you can't directly wrap the property, or want to hold the version history separately.

### `@Observable` and `ObservableObject`

This framework provides convenience initializers for use in `@Observable` and `ObservableObject` types. Unfortunately, the `@Observable` macro doesn't play well with property wrappers, as it synthesizes an underscore prefixed `_propertyName`, which collides with the direct accessor name for property wrappers. Also, as `@Published` is also a property wrapper, it leads to typing issues when attempting to wrap a property with both `@Published` and `@Versioned`. This means we need to manually declare a `VersioningController` on the type, and use it directly.

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

### Scopes

The `VersioningController` also allows you to push and pop scopes, which act as collections of undo and redo actions. A root scope is created by default, and new scopes can be pushed using the `pushNewScope()` function and popped using the `popCurrentScope()` function. The current scope level can be inspected using the `scopeLevel` property, and are `0` indexed. Versions can only be pushed to and used on the current scope, acting as a barrier between different groups of modifications.

For instance if some state is used across several screens, when a child screen is pushed, and a new scope is pushed at the same time, all the modifications made on the child screen are stored in that new scope, and can be abandonded using the `undoAndPopCurrentScope()` function, or squashed into a single change and appended to the previous scope using the `popCurrentScope()` function, depending on whether the user discards or saves changes on that screen.

### Tags

You can also tag a version with some `Hashable` value for future reference using the `func append(_ value: _, tag: _)` function or `func tagCurrentVersion(_ tag: _)` functions. You can then undo or redo to that version by passing the tag to the `func undo(to tag: _)` or `func redo(to tag: _)` functions. You cannot pop a scope this way, and can only revert to a tag within the current scope. To see all tags within a scope, use the `func tags(inScopeLevel scopeLevel: _)` function that returns a tuple of `AnyHashable?` arrays, containing all actions and their tags, even if it's `nil`.

### Error handling

Many of the functions on `VersioningController` can throw errors, which can be cumbersome to handle, especially in a SwiftUI view. Most of the time, we would just wrap the call in a `do - catch` block and assign the error to some observed property. This is boilerplate heavy, and to help reduce the need for such code, the `VersioningController` has a couple of convenience initializers available when the `Root` of the type is a reference type. 

These initializers accept a `WritableKeyPath` to an optional `Error?` property on the root instance. Whenever an error is thrown internally, it is caught and assigned to this property. If the `Root` is an `@Observable` or `ObservableObject` type, then it is notified of the update. When using one of these initializers, the other functions on this type such as `undo()` etc. no longer throw, removing the need to manually handle errors.

## Type conformance

The framework is driven by a few base types that buld upon eachother. This section outlines how they work and how they can be used manually.

### `Revertible`

This protocol defines the basic interface for tracking changes. The conforming type implements the `func reversion(to previous: Self) -> Reversion<Self>?`. The implementation should compare the current value to the provided previous value. If they are the same, then return `nil`, and if they have changes, then some `Reversion` is returned. This is a simplified interface and not directly used that often, instead the `Versionable` protocol is adopted for conformance, and the `Reverter` is used to creating reversions.

This protocol extends `Hashable`, which is used to confirm the `hashValue` of an object before reverting it, and because a lot of logic requires an `Equatable` implementation.

### `Versionable`

This type extends the `Revertible` protocol, by providing a default implementation for `func reversion(to previous: Self) -> Reversion<Self>?` and in its place requires a `func addReversions(into reverter: inout some Reverter<Self>)` implementation. This function provides a `Reverter<Self>` that can stores a previous value and allows key paths to be appended to check for differences. This allows multiple changes to be stored in a single call. The `@Versionable` macro creates an implementation of this, providing all mutable stored properties as key paths.

### `Reversion`

This type contains a single change from one version of a value to another. This single change can contain multiple individual changes along multiple key paths. The `revert(_ object: inout Root) throws` function provides functionality to revert the current version of the value back to the previous version. 

It is important to remember that a `Reversion` can only be applied to the version of the value that was used to make it. For instance, if an account has it's name changed, and a reversion back to the previous name made, and then the name changed again, the created reversion will not work on the current value, as the value has changed since the reversion was created. This is done to prevent `Reversion` objects being applied in the incorrect order and jumbling the state.

```swift
var account = Account(
    id: 0,
    name: "",
    imageData: .init(),
    accountType: .anonymous
)
let original = account
account.name = "Johnny"
let reversion = account.reversion(to: original) // Reversion<Account>
account.name = "Johnny Appleseed"

try reversion.revert(&account) // throws error
```

### `Reverter`

The `Reverter` is a type that allows key paths to be registered and checked for changes. It includes several `func appendReversion(at: _)` functions that accept key paths to basic types, such as Int, Bool, String, Array etc, as well as ones that allow other `Versionable` types to be checked, allowing for deep checks in nested types.

It also provides the `func hasChanged(at: _)` to check for changes before registering them, and `func appendOverwriteReversion(at: _)` that does not perform any diffing, and instead stores a whole value to overwrite the existing value when the reversion is applied. This is less performant, but can be hepful with `enum` types when changing between cases.

### Macros

The macros provided provide a default implementation for `Versionable` for value types, and are not exhaustive, they just intend to avoid boilerplate code where possible.

For a `struct`, every mutable, stored property is added to the generated `func addReversions(into reverter: inout some Reverter<Self>)` function, which is suitable for many models.

For an `enum`, every associated value has a private getter and setter generated, as well as a child `CaseName` `enum` ghosting the parent `enum`, but with no associated values. The `func addReversions(into reverter: inout some Reverter<Self>)` function first checks if the case of the enum has changed, and if so the whole value is overwritten. If the case is the same, and just some of the associated values have changed, then those changes are appended for each key path, much the same as with the `struct` implementation.

For some models, you may wish to ignore individual properties, but not want to have to manually declare `func addReversions(into reverter: inout some Reverter<Self>)` to simply omit one property. The `@VersionableIgnored` macro instructs the `@Versionable` macro to ignore that property when generating the code. This macro can only be applied to `struct` properties, as in an `enum`, individual associated values are required to track `self` at all.

### Manual conformance

To manually conform to the `Versionable` protocol, simply implement the `func addReversions(into reverter: inout some Reverter<Self>)` function yourself:

```swift
struct Account: Versionable {

    let id: Int
    var name: String
    var imageData: Data
    var accountType: AccountType
    
    func addReversions(into reverter: inout some Reverter<Self>) {
        reverter.appendReversion(at: \.name)
        reverter.appendReversion(at: \.imageData)
        reverter.appendReversion(at: \.accountType)
    }
}
```

Note that the `id` property has not been included as it is immutable.

```swift
enum AccountType {

    case anonymous
    case verified(emailAddress: String)
    case admin
    
    func addReversions(into reverter: inout some Reverter<Self>) {
        guard reverter.hasChanged(at: \.caseName) == false else {
            reverter.appendOverwriteReversion(at: \.self)
            return
        }
        reverter.appendReversion(at: \.verified_emailAddress)
    }

    private enum CaseName {
        case anonymous
        case verified
        case admin
    }

    private var caseName: CaseName {
        switch self {
        case .anonymous:
            .anonymous
        case .verified:
            .verified
        case .admin:
            .admin
        }
    }

    private var verified_emailAddress: String? {
        get {
            guard case let .verified(verified_emailAddress) = self else {
                return nil
            }
            return verified_emailAddress
        }
        set {
            guard case .verified = self, let newValue else {
                return
            }
            self = .verified(emailAddress: newValue)
        }
    }
}
```

The enum case requires a lot more boilerplate when including associated values. For a basic enum type, the easiest implementation is:

```swift
enum AccountType {

    case anonymous
    case verified
    case admin
    
    func addReversions(into reverter: inout some Reverter<Self>) {
        reverter.appendOverwriteReversion(at: \.self)
    }
}
```

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
