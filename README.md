# Revertible

[![](https://img.shields.io/badge/swift-6-orange.svg)](https://developer.apple.com/swift)
[![License](https://img.shields.io/github/license/AndyHeardApps/Revertible.svg)](https://github.com/AndyHeardApps/Revertible/blob/develop/License)
![CI Status](https://github.com/AndyHeardApps/Revertible/actions/workflows/build.yml/badge.svg?branch=main)
![Platforms](https://img.shields.io/badge/iOS_%7C_macOS_%7C_watchOS_%7C_tvOS_%7C_visionOS-%23f5e7d3?label=Platforms)

This library aims to add a low friction way to track changes in state, and allow for simple navigation through state history with `undo()` and `redo()` functions. It is compatible with SwiftUI, UIKit, Observable and Combine, with drop in support for your views and models.

* [Basic usage](#basic-usage)
* [Installation](#installation)
* [Why not `UndoManager`?](#why-not-undomanager)
* [Additional features](#additional-features)
    * [Scopes](#scopes)
    * [Tags](#tags)
    * [Error handling](#error-handling)
    * [Modification debouncing](#modification-debouncing)
* [Deep dive](#deep-dive)
	* [Making a type revertible](#making-a-type-revertible)
        * [`Revertible ` protocol](#revertible-protocol)
        * [`Versionable` protocol](#versionable-protocol)
        * [`@Versionable` macro](#versionable-macro)
	* [Using a revertible type](#using-a-revertible-type)
        * [`Reversion`](#reversion)
        * [`VersioningController`](#versioningcontroller)
            * [Direct tracking](#direct-tracking)
            * [Key path tracking](#key-path-tracking)
            * [Reference key path tracking](#reference-key-path-tracking)
                * [`@Observable` and `ObservableObject` types](#observable-and-observableobject-types)
            * [Scope details](#scope-details)
            * [Tag details](#tag-details)
            * [Error handling details](#error-handling-details)
            * [Debouncing details](#debouncing-details)
        * [`@Versioned ` property wrapper](#versioned-property-wrapper)
        * [`@Versioning` macro](#versioning-macro)
* [License](#license)

## Basic Usage

Consider the following model, that demonstrates recursive nesting, an enum with associated values and a collection:

```swift
struct Activity: Identifiable {

    let id: UUID
    var title: String
    var priority: Priority
    var childActivities: [Activity]

    enum Priority {
        case low
        case medium(dueDate: Date?)
        case high(dueDate: Date, reason: String)
    }
}
```

In order to make this type versionable, meaning it is able to track changes, simply annotate the types with the `@Versionable` macro:

```swift
@Versionable
struct Activity: Identifiable {

    let id: UUID
    var title: String
    var priority: Priority
    var childActivities: [Activity]

    @Versionable
    enum Priority {
        case low
        case medium(dueDate: Date?)
        case high(dueDate: Date, reason: String)
    }
}
```

This macro needs to be applied to the declaration of all custom types you wish to track changes on, including nested types. It can be applied to `struct` and `enum` types, and will synthesize code that registers all mutable properties to be tracked.

There will be cases when there are properties you don't wish to track or apply undo / redo actions to, such as an `lastUpdated` property. In this instance, allowing the library to overwrite and undo updates to the property breaks the contract implied by the property's name. The `@VersionableIgnored` macro instructs the library not to track changes on a property:

```swift
@VersionableIgnored
var lastUpdated: Date
```

To actually track changes made to a `Versionable` type, create a model containing an instance of the type, an annotate it with the `@Versioning` macro:

```swift
@Versioning
struct Model {
    var activity: Activity = .mock
}
```

This will synthesize tracking code for each variable property, and can be used on any `class`, `struct`, `enum` or `actor` type.

To perform version tracking actions, access the projected value of the property being tracked:

```swift
let model = Model(
    activity: Activity(
        id: .init(),
        title: "Title",
        priority: .low,
        childActivities: []
    )
)
model.activity.title = "New title"
model.activity.priority = .high(dueDate: .now, reason: "Important reason")
model.activity.childActivities.append(.mock)
model.$activity.undo() // model.activity.childActivities -> []
model.$activity.undo() // model.activity.priority -> .low
model.$activity.undo() // model.activity.title -> "Title"
model.$activity.redo() // model.activity.title -> "New title"
```

Changes can be tracked and applied through `enum` cases, collections, computed properties etc. For instance:

```swift
model.activity.childActivities[0].childActivities[1].priority.reason += " - updated"
```

Assuming we've made a `reason` computed property on the `Priority`, this will construct a key path to the individual change on the child activity, enabling efficient tracking and reversion of the change.

**NOTE: The tracking code synthesized by the macro depends on the model declaration. For `@Observable` and `ObservableObject` declarations the version tracking interface is available at `_$activity`. This is due to naming collisions with property wrappers. For more information see the [`@Versionable`](#versionable-macro) section.**

In the case that the model is `@Observable` or an `ObservableObject`, the macro will also create code that triggers view updates in SwiftUI automatically when needed.

In most cases, you don't want to have version tracking for all properties on a model. The `@Versioning` macro allows you to specify any number of properties to track. By default, if no properties are specified, then all are tracked.

```swift
@Versioning("activity")
struct Model {
    var activity: Activity = .mock
    var notTracked: Activity = .mock
}

model.$notTracked // Value of type 'Model' has no member '$notTracked'
```

Unfortunately, macros can't make use of `KeyPath` types for the type it is attached to, so the properties to be tracked must be provided as strings for now.

That's all that needs to be done to get started with state tracking, however there are more methods available to the tracking interface, as well as other ways to use this library should the above code not fit your purpose.

## Installation

Swift Package Manager is the best way to include this library in your project. To do so, add a dependency pointing to [https://github.com/andyheardapps/Revertible.git](https://github.com/andyheardapps/Revertible.git) and be sure to add it as a dependency to your target of choice.

Alternatively you may download the source and include it directly in your project.

## Why not `UndoManager`?

The `UndoManager` in Foundation is cumbersome to use, with a lot of boilerplate involved in adding undo and redo actions. With it being closure based, it can be easy to let a retain cycle slip in, while also possibly retaining full copies of large state data, just in case the undo action is applied.

Consider a situation where a large nested model has a minor change made. A naive approach would be for the `UndoManager` to hold on to the entirety of the old value, in case it is needed in an undo action. A better approach would be to just track what has changed and where, but this adds more complexity to an already bloated method of tracking changes.

This framework aims to ease those pains, with piecewise storage of only what has changed in a value, and a simple interface with which to push versions of a value onto the version stack. When an updated value is pushed onto the version stack, each property is inspected for changes, recursively, so that only the individual values that have changed are used. These values are then stored alongside their `KeyPath` in a lightweight struct. If no changes have occurred, then nothing happens. These `Reversion` values can then be applied to the updated object to revert it to the previous state.

This method means that individual reversions do not know about the object that created them, resulting in a lower memory footprint and no risk of a memory leak. The `Reversion` type is what drives this framework.

The framework has been designed to support basic types such as `Int` and `Bool` out of the box, as well as other common types such as `UUID` and basic collections like `Data`, `String`, `Array` etc. This allows more complex types to be used by combining these basic implementations.

## Additional features

There are other features wrapped into the version tracking interface available through the projected value. In addition to the standard `undo()` and `redo()` functions, there are the `hasUndo` and `hasRedo` properties that indicate whether or not versioning actions are available.

The `setWithTransaction(_:)` functions allow multiple changes to be applied in a single transaction, which is tracked as a single modification, and is undone in it's entirety by a single `undo()` call.

```swift
model.$activity.setWithTransaction { activity in
    activity.title = "New title"
    activity.priority = .medium(dueDate: nil)
}
model.$activity.undo() // model.activity.title -> "Title" && model.activity.priority -> .low
```

### Scopes

Scopes act as barriers separating collections of undo and redo actions. A root scope is always created by default, and new scopes can be pushed using the `pushNewScope()` function and popped using the `popCurrentScope()` function. The current scope level can be inspected using the `scopeLevel` property, which is `0` indexed. Versions can only be pushed to and used on the current scope, enforcing the separation of different groups of modifications.

For instance, say some state is used across several screens. When a child screen is pushed, and a new scope is pushed at the same time, all the modifications made on the child screen are stored in that new scope, and can be abandoned using the `undoAndPopCurrentScope()` function, or squashed into a single change and appended to the previous scope using the `popCurrentScope()` function. This means that when the user returns to the previous screen, all of those changes can be undone atomically with a single `undo()` call. 

```swift
model.activity.title = "New title"
model.$activity.pushNewScope() // model.$activity.scopeLevel -> 1 && model.$activity.hasUndo -> false
model.activity.priority = .medium(dueDate: nil)
model.activity.childActivities.append(.mock)
model.$activity.popCurrentScope() // model.$activity.scopeLevel -> 0 && model.$activity.hasUndo -> true
model.$activity.undo() // model.$activity.childActivities -> [] && model.$activity.priority -> low
```

There are similarities between scopes and transactions, with the exception being that scopes are open ended.

### Tags

A version can be tagged with some `Hashable` value for future reference using the `tag(_:)` function. You can then undo or redo to that version by passing the tag to the `undo(to:)` or `redo(to:)` functions. You cannot pop a scope this way, and can only revert to a tag within the current scope. To see all tags within a scope, use the `tags(inScopeLevel:)` function that returns a tuple of `AnyHashable?` arrays, containing all action tags, even if they are nil `nil`.

```swift
model.$activity.tag("original")
model.activity.title = "New title"
model.activity.priority = .medium(dueDate: nil)
model.$activity.tag("without-child")
model.activity.childActivities = Activity.mock(count: 3)
model.$activity.tag("with-child")

model.$activity.undo(to: "without-child") // model.activity.childActivities -> []
print(model.$activity.tags()) // (["original", nil, "without-child"], ["with-child"])
```

### Error handling

Most functions in the versioning interface are capable of throwing an error when a reversion can't be applied. Under the hood, every reversion holds on to the `hashValue` of the version of the object that was used to create it. When applying that reversion, if the `hashValue` of the object being reverted doesn't match the stored value in the reversion, then a `ReversionError` is thrown.

In most cases, the risk of this error being thrown is negligible, as the reversions and the objects being reverted are managed for you, however the function signatures are still marked as throwing. This can lead to an annoying situation where you must wrap all calls in a `do`-`catch` block an handle errors you know will not get thrown.

To remove this boilerplate error handling, many of the versioning interfaces used, including the `@Versioning` macro, allow you instruct it to handle errors itself and assign them to some property. The `@Versioning` macro has an `errorMode` parameter, that accepts a `VersioningErrorHandlingMode` enum case:

- `throwErrors` causes any potentially throwing function on the versioning interface to be marked as `throws`, meaning the caller will handle any thrown errors.

- `assignErrors` causes the potentially throwing functions to instead automatically handle their errors and assign them to a property available to the `@Versioning` type. 
    - In most cases, this is available at `model.$activity.error`, however for `@Observable` and `@ObservableObject` types, the error is assigned to property on that type. The name of the property is provided as a `String` in the associated value. If no name is provided then `versioningError` is used. This property can be declared manually, but must be of type `Error?` or `(any Error)?` if it is. If it is not declared manually, then the macro will synthesize the property for you.

Standard model

```swift
@Versioning(errorMode: .assignErrors)
struct Model {
    var activity: Activity = .mock
}
model.$activity.undo() // 👍
model.$activity.error  // ReversionError?
```

`@Observable` model

```swift
@Observable
@Versioning(errorMode: .assignErrors("myError"))
final class Model {
    var activity: Activity = .mock
}
model._$activity.undo() // 👍
model.myError           // (any Error)?
```

Throwing standard model

```swift
@Versioning(errorMode: .throwErrors)
struct Model {
    var activity: Activity = .mock
}
model.$activity.undo() // Call can throw but is not marked with 'try'
try model.$activity.undo() // 👍
```

### Modification debouncing

By default, every change to a tracked object is stored as a separate version. This makes sense in most instances, such as adding or removing a value from a collection, but consider the case of a user typing in a text field. Each individual character added or removed from the string will be stored as a new version. This essentially means that every key press they do is a new version, and when attempting to undo changes, it will only undo one character at a time. This is more cumbersome than manually using the backspace key, and is not what users expect from an undo function.

To overcome this, most versioning interfaces accept a debounce interval parameter. This prevents modifications made in quick succession each being stored as a separate version, and instead groups them together in one bulk change. In the typing example above, pressing the undo button on debounced typing will undo the previous burst of typing, instead of each character.

Most versioning interfaces accept a `Duration` instance, with the exception of `@Versioning` which currently doesn't work with `Duration` due to a Swift compiler bug causing a crash when attempting to use the provided duration instance in the synthesized code. Therefore, for now, the `@Versioning` macro accepts a positive integer number of milliseconds for the debounce interval.

Consider the following code, that aims to replicate rapid user typing:

```swift
model.activity.title = "N"
model.activity.title += "e"
model.activity.title += "w"
model.activity.title += " "
model.activity.title += "t"
model.activity.title += "i"
model.activity.title += "t"
model.activity.title += "l"
model.activity.title += "e"

model.$activity.undo() // model.activity.title -> "New titl"
```

In this case every new character is stored as a new version. Now let's add a debounce interval:

```swift
@Versioning(debounceMilliseconds: 200)
struct Model {
    var activity: Activity = .mock
}

... // Set new title character by character

model.$activity.undo() // model.activity.title -> "Title"
```

The individual character alterations have been squashed into a single change, that can all be undone in one call.

## Deep dive

The above covers the majority of the features and use cases that will get you started with the library. The following sections go into detail on each aspect of the library, starting at the lowest level with the components that drive it all and going up to the convenient interfaces.

### Making a type revertible

The first thing you'll need to do to make use of the library is make a type able to produce a diff between two versions of itself. This diff can then be applied to the current version to revert it to it's previous state. At the base level, this is what drives the library. Whenever a value is changed, the previous value is stored alongside it's `KeyPath` in a single `Reversion` object. Multiple changes are stored as collections of these `Reversion` objects, and the composability of `KeyPath` is used to allow reversions to be mapped on to parent objects.

The way the library constructs these `Reversion` objects is through the `Revertible` protocol. The `Versionable` protocol builds on top of that to provide a cleaner interface for creating a `Reversion` and the `Versionable` macro provides a default conformance for the protocol.

#### `Revertible` protocol

This protocol defines the basic interface for tracking changes. The conforming type implements the `reversion(to previous: Self) -> Reversion<Self>?` function. The implementation compares the current value to the provided previous value. If they are the same, then it returns `nil`, and if they have changes, then some `Reversion` is returned.

This is a strictly functional interface and is not directly called that often. Additionally, the concrete `Reversion` types required to conform this protocol manually are not public, and so this cannot be conformed to directly on custom types. Instead the `Versionable` protocol is implemented.

**Note** This protocol extends `Hashable`, which is used to confirm the `hashValue` of an object before reverting it, and because a lot of logic makes use of `Equatable`.

#### `Versionable` protocol

This type extends the `Revertible` protocol, and provides a default implementation for `reversion(to previous: Self) -> Reversion<Self>?` and in its place requires a `addReversions(into reverter: inout some Reverter<Self>)` implementation. This function provides a `Reverter<Self>` instance that you use to register key paths to check for changes. 

The `Reverter` is a type that allows key paths to be registered and checked for changes. It includes several `appendReversion(at:)` functions that accept key paths to basic types, such as `Int`, `Bool`, `String`, `Array` etc., as well as ones that allow other `Versionable` types to be checked, allowing for deep checks in nested types.

It also has the `hasChanged(at:)` function to check for changes before registering them, and `appendOverwriteReversion(at:)` that does not perform any diffing, and instead stores a whole value to overwrite the existing value when the reversion is applied. This is less performant, but can be hepful with `enum` types when changing between cases.

Each registered key path will be checked for any differences between versions and only those with changes will be stored. This allows multiple changes on an object to be stored in a single call. The `@Versionable` macro creates an implementation for this protocol, providing all mutable stored properties as key paths.

The implementation for the `Activity` struct would look like this:

```swift
extension Activity: Versionable {
    func addReversions(into reverter: inout some Reverter<Self>) {
        reverter.appendReversion(at: \.title)
        reverter.appendReversion(at: \.priority)
        reverter.appendReversion(at: \.childActivities)
    }
}
```

**Note** that the `id` property has not been included as it is immutable.

#### `Versionable` macro

The implementations for `Versionable` are simple for the most part, requiring simple boilerplate code, similar to a basic `Codable` implementation. It's also possible to forget to update the function when a new property is added to a model.

`enum` implementations are a little more complex too, where tracking both the case and any associated values need to be tracked efficiently. 

The `@Versionable` macro synthesizes all of this boilerplate code for you. The `Activity` extension in the previous section will be synthesized for you, and every mutable used in a `reverter.appendReversion(at:)` call. If you wish to ignore a property, then the `@VersionableIgnored` can be used to indicate to the macro that it shouldn't track it. The `@VersionableIgnored` macro can only be applied to `struct` properties, as in an `enum`, individual associated values are required to track `self` at all.

When attached to an `enum`, the synthesized code is a little more involved. For example, when applied to the `Activity.Priority`, the following code is synthesized:

```swift
extension Activity.Priority: Versionable {

    func addReversions(into reverter: inout some Reverter<Self>) {
        guard reverter.hasChanged(at: \.caseName) == false else {
            reverter.appendOverwriteReversion(at: \.self)
            return
        }
        reverter.appendReversion(at: \.medium_dueDate)
        reverter.appendReversion(at: \.high_dueDate)
        reverter.appendReversion(at: \.high_reason)
    }

    private enum CaseName {
        case low
        case medium
        case high
    }

    private var caseName: CaseName {
        switch self {
        case .low:
            .low
        case .medium:
            .medium
        case .high:
            .high
        }
    }

    private var medium_dueDate: Date? {
        get {
            guard case let .medium(medium_dueDate) = self else {
                return nil
            }
            return medium_dueDate
        }
        set {
            guard case .medium = self, let newValue else {
                return
            }
            self = .medium(dueDate: newValue)
        }
    }

    private var high_dueDate: Date? {
        get {
            guard case let .high(high_dueDate, _) = self else {
                return nil
            }
            return high_dueDate
        }
        set {
            guard case let .high(_, high_reason) = self, let newValue else {
                return
            }
            self = .high(dueDate: newValue, reason: high_reason)
        }
    }

    private var high_reason: String? {
        get {
            guard case let .high(_, high_reason) = self else {
                return nil
            }
            return high_reason
        }
        set {
            guard case let .high(high_dueDate, _) = self, let newValue else {
                return
            }
            self = .high(dueDate: high_dueDate, reason: newValue)
        }
    }
}
```

The extension contains private getters and setters for every associated value on each case, a nested `enum` mirroring the attached type, but with no associated values, and the `addReversions(into:)` function declaration. First, when checking any changes, the code will check if the case has changed. If so then the whole value is overwritten to provide an initial value for the associated values. If the case is the same, then the associated values are checked for changes.

### Using a revertible type

There are a few ways of actually using a revertible type, from handling each reversion individually to letting macros do everything. At it's core, this library gives you a diff between two objects that can be applied to the newer version to return it to it's previous state.

#### `Reversion`

This type contains a single change from one version of a value to another. This single change can contain multiple individual changes along multiple key paths. The `revert(_ object: inout Root) throws` function provides functionality to revert the current version of the value back to the previous version. 

It is important to remember that a `Reversion` can only be applied to the version of the value that was used to make it. For instance, if an `Activity` has it's title changed, and a reversion back to the previous title made, and then the title changed again, the created reversion will not work on the current value, as the value has changed since the reversion was created. This is done to prevent `Reversion` objects being applied in the incorrect order and jumbling the state.

```swift
let original = Activity(
    id: .init(),
    title: "Title",
    priority: .low,
    childActivities: []

)
var mutable = original
mutable.title = "New title"
let reversion = mutable.reversion(to: original) // Reversion<Activity>
mutable.title = "Newer title"

try reversion?.revert(&mutable) // throws error
```

These `Reversion` objects are created for each version of an object. They can be applied in order to navigate through the whole history of an object. Managing these objects is a chore though, so the `VersioningController` has been made to do this for us.

#### `VersioningController`

The `VersioningController` tracks changes to a type and organises the `Reversion` objects for you, ensuring they are always applied in the correct order. It can track changes in a single value, so it is best to consolidate your state into a single type. It is the type that is used in all of the versioning interfaces to do all of the work.

It is the `VersioningController` that manages scopes, `undo()` and `redo()` functions, version tagging as well as error handling. In fact, the dollar syntax projected values in the macros are `VersioningController` instances. Each version is manually appended to the controller, which is then checked for changes and added to the version stack of the current scope.

There are a few different ways to use the `VersioningController`. They are mostly the same, but there are some finer points to be aware of.

##### Direct tracking

Direct tracking is the simplest implementation, and is used by creating an instance with the `init(_:)` initializer. Use this method when you want to track an entire object at the root level. For instance if you have some state you don't own but still want to track from some other type, such as when state is provided by some third party library or `@Environment`.

Once an instance has been made, versions can be pushed using the `append(_ newValue: _)` function, which will check for any changes and store them in the version stack. Versions are stored in a last in - first out basis. The status of the `VersioningController` can be inspected with the `hasUndo` and `hasRedo` properties, and there are a couple of `undo` and `redo` variations available. One implementation for each function returns the undone / redone value, and the other accepts an `inout` parameter that is updated in place.

This allows you to version external state. For those enjoying TCA, this is the best way to manage your reducer's `State`.

```swift
let controller = VersioningController(activity)
activity.title = "New title"
controller.append(activity)
try controller.undo(&activity)
```

**Note** `activity = try controller.undo()` and `try controller.undo(&activity)` are functionally identical.

##### Key path tracking

Key path tracking is functionally the same as the direct tracking method, but it accepts a `WritableKeyPath` in the `public init(on root: _, at keyPath: _)` initializer. This allows you to point to just a single property of a value to track, and also provides convenience methods that allow you to push and revert versions using the `Root` value of the key path.

```swift
let controller = VersioningController(
    on: activity,
    at: \.priority
)

activity.title = "New title"
controller.append(root: activity) // Append the whole root object, but only priority is checked for changes, so no new version is stored on the stack

// Priority has changed, so a new version is appended.
activity.priority = .medium(dueDate: nil)
controller.append(activity.priority)

try controller.undo(root: &activity)
```

**Note** `activity.priority = try controller.undo()`, `try controller.undo(root: &activity)` and `try controller.undo(&activity.priority)` are functionally identical.

Key path tracking still has the direct tracking interface available for use, should it be preferred.

##### Reference key path tracking

Reference key path tracking is the same as key path tracking, but when the `Root` type of the key path is a reference type. This allows the `VersioningController` to hold on to a weak reference of the root, and read and write properties directly on that weak reference. This mode provides more basic `appendCurrentVersion()`, `undo()` and `redo()` functions that don't accept any parameters or return any values, but instead directly read and write to the root object.

```swift
// model is a class
let controller = VersioningController(
    on: model,
    at: \.activity
)

model.activity.title = "New title"
controller.appendCurrentVersion()
try controller.undo() // model.activity.title -> "Title"
```

Reference key path tracking still has the interface for the other two modes available for use, meaning that `model.activity = try controller.undo()` and `try controller.undo(root: &model)` are still valid.

###### `@Observable` and `ObservableObject` types

Having to manually append versions to the controller can be an annoyance, especially if it's a user facing state that needs to be manually tracked after every change. Calling `append()` all over your model in a `didSet` is messy and easy to forget. `VersioningController` has support `@Observable` and `ObservableObject` conforming root objects, to automatically be notified of changes and append them for you.

For an `@ObservableObject` object, then there is an overload of the `init(on:at:debounceInterval:)` initializer that will use the `ObservableObjectPublisher` on the root to be notified of changes, and trigger updates in SwiftUI. This functionality should happen automatically as long as the correct initializer is being used.

`@Observable` objects are a little different. The root can be observed easily, but in order to notify SwiftUI of updates, the `VersioningController` requires the `ObservationRegistrar` of the instance. Therefore, there is another initializer that accepts an `ObservationRegistrar` instance.

In both cases, the `VersioningController` will trigger an update whenever a versioning function is used (`undo()` or `redo()`), when a new version is appended, whenever there is a change to the scope, and whenever an error is produced. This allows your UI to stay up to date with not only the state being tracked, but also the state of the controller itself, allowing you to bind UI elements directly the controller with confidence.

##### Scope details

The scopes are useful for setting up barriers between versions and grouping versions, allowing you to squash groups of versions into a single change, or discard the changes in the current scope altogether. Internally, versions are stored in stacks, one is the undo stack and the other is the redo stack. Each scope contains one of these stack pairs, and all versions are appended to the stack in the current scope.

Scopes are best used when changing focus in a form, such as when pushing new screens that focus on a part of your state, and popped or discarded when leaving that screen. There is no set limit on the number of scopes you can make.

To explicitly carry out multiple changes in a single version change, is is best to use the `setWithTransaction(_:)` functions instead of scopes.

Scopes must always be explicitly pushed and popped, and an undo or redo call will *NEVER* alter the current scope.

##### Tag details

A tag can be applied to a version either it is explicitly appended to the `VersioningController` using the `append(_:tag:)` function or similar. When versions are automatically appended for you, you can instead tag the latest version using `tagCurrentVersion(_:)`. When a version is tagged, you can use it as a waypoint when navigating the version stack by calling the `undo(to:)` and `redo(to:)` functions. You cannot navigate to a tag from another scope, as you must always explicitly handle your scopes.

When using either `undo(to:)` or `redo(to:)` you will always end up on the version that was tagged. There is an important distinction between versions of the state and the modifications between them. You tag a *version*, and not the changes that made that version. When performing an undo to a tag, you will undo all changes up to but not including the tagged changes. When performing a redo to a tag, you will redo all changes including the tagged changes.

##### Error handling details

Error handling has been made dynamic thanks to typed error throwing. `VersioningController` has a generic `Failure` type that conforms to the `Error` protocol and is thrown by much of it's interface. When a `VersioningController` has been initialized with a key path to place any encountered errors, then it has a `Failure` type of `Never`, otherwise it is `ReversionError`. The initializer that accepts an error key path retains a weak reference to the Root object, and creates a closure with the signature `(ReversionError) throws(Failure) -> Void`, allowing errors to be handled internally.

This type of error handling can only be used when the root object on the `VersioningController` is a reference type, such as a class based view model. The [`@Versioned`](#versioned-property-wrapper) can handle errors for you in value types.

##### Debouncing details

Debouncing changes is something you are likely to use when versioning mutable user facing state. Other than the unfortunate limitations of the macro parameters only being able to accept a number of milliseconds, it behaves as you would expect from Combine or Async Algorithms. In fact, when used with an `ObservableObject`, the combine debounce publisher is used directly. In other cases, a custom implementation is used, which is designed to mirror other, first party implementations.

When using an initializer that accepts a `debounceInterval`, you can also specify the clock / scheduler to use to measure that interval. By default the `ContinuousClock` or `DispatchQueue.main` are used, depending on which initializer is called. This allows you to test your versioned objects with test clocks, so your tests don't need to sleep while waiting for values to be debounced. If relying on the macros, you will need to overwrite the default `VersioningController` or `@Versioned` property wrappers in your tests in order to inject your custom clock. In order to change the debouncing clock in tests, use the `withDebouncing(clock:, interval:)` function on `VersioningController` or the `@Versioned` projected value. On `ObservableObject` types, use `withDebouncing(scheduler:interval:)` instead.

#### `@Versioned` property wrapper

The `@Versioned` property wrapper is relatively simple. It owns an instance of `VersioningController` and uses it to directly track the `wrappedValue`. The versioning interface is available through the projected value using dollar syntax, but it does not directly provide the `VersioningController`. Instead it provides a cut down interface that makes sense for the value based tracking being carried out. This interface still gives access to scopes, tags, transactions etc.

The error handling on `@Versioned` is similar to `VersioningController`, but instead of accepting a key path to store the error, it will store the error internally on the `$value.error` property on the projected value. If you'd rather handle errors yourself, then the `@ThrowingVersioned` property wrapper will cause the interface to throw errors instead of catching them.

#### `@Versioning` macro

All of the above can be a bit much to remember. Which initializer to use, error handling, whether or not `@Versioned` can be used or not. The `@Versioning` macro aims to join all of this together into a single call. It will check the type it is attached to for `@Observable` or `ObservableObject` and will apply the appropriate tracking method for each. If neither are there, then the default `@Versioned` approach is used.

## [License](https://github.com/AndyHeardApps/Revertible/blob/develop/License)

This project is licensed under the terms of the MIT license.
