# Revertible

This framework aims to add a low friction method to track changes in state, and allow for simple traversal through state history with `undo()` and `redo()` functions.

## Basic usage

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

try viewModel.$account.undo() // accountType -> .anonymous
try viewModel.$account.undo() // name -> ""
try viewModel.$account.redo() // name -> "Johnny"
```

In the above case, every individual change will be stored. This includes every individual change to a string as it is typed out by the user, which is a poor experience when performing an undo action one character at a time. To counter this, the `@Versioned` property wrapper has a `debounceInverval` parameter, which groups modifications made in quick succession together:

```swift
@Versioned(debounceInterval: .milliseconds(300)) var account: Account = ...
```

That's all you need to do. There are different interfaces available for more in depth use cases, such as using `VersioningController`, which drives the `@Versioned` property wrapper, directly. This offers a little more flexibility in cases where you can't directly wrap the property, or want to hold the version history separately.

## Reasoning

The `UndoManager` in Foundation is cumbersome to use, with a lot of boilerplate involved in adding undo and redo actions. With it being closure based, it can easy to let a retain cycle slip in, while also possibly retaining full copies of large state data, just in case the undo action is applied.

Consider a situation where a large amount of text has a minor change made. A naive approach would be for the `UndoManager` to hold on to the entirity of the old value, in case it is needed in an undo action. A better approach would be to just track the changes, but this adds more complexity to an already bloated method of tracking changes.

This framework aims to ease those pains, with piecewise storage of only what has changed in a value, and a simple interface with which to push versions of a value onto the version stack. When an updated value is pushed onto the version stack, each property is inspected for changes, recursively, so that only the individual values that have changed are used. These values are then stored alongside their `KeyPath` in a lightweight struct. If no changes have occurred, then nothing happens. These `Reversion` values can then be applied to the updated object to revert it to the previous state.

This method means that individual reversions do not know about the object that created them, resulting in a lower memory footprint and no risk of a memory leak. The `Reversion` type is what drives this framework.

Consider the string scenario above. If the only change was to add a period to the end of a 5000 line document, all that really needs to be stored is where that period was added, and how to undo it. Storing once character alongside a `KeyPath` uses considerably less memory than storing the old and new versions of the string.

The framework has been designed to support basic types such as `Int` and `Bool` out of the box, as well as other common types such as `UUID` and basic collections like `Data`, `String`, `Array` etc. This allows more complex types to be used by combining these basic implementations.

For more information on how the framework operates, check the [Type conformance](#type-conformance) section below.

## `VersioningController`

Other than the `@Versioned` property wrapper, the other way to easily handle version of a value is with the `VersioningController`. Each instance of a `VersioningController` can only manage a single value, so the best practice is to consolidate all of your state into a single type.

There are a few different ways to use the `VersioningController`. They are mostly the same, but there are some points to be aware of.

### Direct tracking

Direct tracking is the simplest implementation, and is used by creating an instance with the `init(_ value: _)` initializer. Use this method when you want to track an entire object at the top level. For instance if you have some state you don't own but still want to track from some other type. 

Once an instance has been made, versions can be pushed using the `append(_ newValue: _)` function, which will check for any changes and store them in the version stack. Versions are stored in a last in - first out basis. The status of the `VersioningController` can be inspected with the `hasUndo` and `hasRedo` properties, and there are a couple of `undo` and `redo` variations available. One implementation for each function provides the undone / redone in the return value, and the other accepts an `inout` parameter that is update in place.

This allows you to add an get versions externally. For those enjoying TCA, this is the best way to manage your reducer's `State`.

### Key path tracking

Key path tracking is functionally the same as the direct tracking method, but it accepts a `WritableKeyPath` in the `public init(on root: _, at keyPath: _)` initializer. This allows you to point to just a single property of a value to track, and also provides convenience methods that allow you to push versions by passing the `Root` type of the key path.

### Reference key path tracking

## Type conformance

### `Revertible`

### `Versionable`

### `Reversion`

### `Reverter`

### Macros

### Manual conformance

### Manual reversion handling
