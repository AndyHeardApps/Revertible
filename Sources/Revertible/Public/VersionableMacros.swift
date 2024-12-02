import Foundation

/// Defines the  error handling method used by the ``Versioning(_:errorMode:debounceMilliseconds:)`` macro.
public enum VersioningErrorHandlingMode: Sendable {

    /// Errors thrown by versioning function calls will be caught and assigned to a property (`var versioningError: (any Error)?`) on the attached type. If the property is not manually declared, it will be synthesized.
    public static let assignErrors = assignErrors("versioningError")

    /// Causes errors to be thrown by the versioning interface functions.
    case throwErrors

    /// Errors thrown by versioning function calls will be caught and assigned to a property with the specified name on the attached type. If the property is not manually declared, it will be synthesized.
    case assignErrors(StaticString)
}

/// Applies an appropriate versioning method to the attached type.
///
/// The default naming convensions in Swift prevent the ``Versioned`` property wrapper being applied to `@Observable` and `ObservableObject` implementations, where the default `_` prefixed names used by property wrappers are already claimed. This means that ``VersioningController`` must be used directly with slightly different initializers for each case. To reduce the friction when adding versioning to a type, this macro checks the conformances and macros on a type, annd applies the appropriate versioning technique. For standard types, the ``Versioned`` property wrapper is used, for `@Observable` and `ObservableObject` types, each property has a ``VersioningController`` synthesized with the `_$` prefix. This means the only change needed is when accessing the versioning interface, with standard types using `$value` and `@Observable` and `ObservableObject` types using `_$value`.
///
/// By default, every variable property has versioning applied to it. Specific properties to be versioned can be defined in the `proeprties` parameter, which will supress every property havign versioning applied. The properties must be provided as a `String` value, as macros don't work with key paths for the type they are attached to.
///
/// The error reporting mode can also be controlled with the `errorMode` parameter. Allowing the errors to be stored internally or thrown on the versioning interface.
///
/// The debounce interval can also be defined, but as an integer number of milliseconds. The is due to an unfortunate bug in the compiler that causes it to crash when a `Duration` instance is passed from the macro to the synthesized objects.
///
/// - Parameters:
///   - properties: The properties to synthesize versioning control for, represented as `String` values.
///   - errorMode: The error mode to use each synthesized versioning control.
///   - debounceMilliseconds: The number of milliseconds to debounce each of the synthesized versioning controls for. If `nil`, then debouncing is not used.
@attached(member, names: arbitrary) @attached(memberAttribute)
public macro Versioning(
    _ properties: StaticString...,
    errorMode: VersioningErrorHandlingMode = .assignErrors,
    debounceMilliseconds: StaticBigInt? = nil
) = #externalMacro(module: "RevertibleMacros", type: "VersioningMacro")

/// Adds a default implementation of the ``Versionable`` protocol to a `struct` or `enum` declaration.
///
/// Each mutable, stored property will have an entry added to the  generated ``Versionable/addReversions(into:)`` function. For the case of enums, each associated value will have a private getter and setter generated, and used in the generated function.
@attached(extension, conformances: Versionable, names: named(addReversions), arbitrary)
public macro Versionable() = #externalMacro(module: "RevertibleMacros", type: "VersionableMacro")

/// Signifies that the property this macro is attached to should not be tracked when calculating reversions.
@attached(accessor, names: named(didSet))
public macro VersionableIgnored() = #externalMacro(module: "RevertibleMacros", type: "VersionableIgnoredMacro")
