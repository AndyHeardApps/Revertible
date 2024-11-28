import Foundation

public enum VersioningErrorHandlingMode {
    case throwErrors
    case assignErrors(StaticString)
}

@attached(member, names: arbitrary) @attached(memberAttribute)
public macro Versioning(
    _ properties: StaticString...,
    internalizesErrors: BooleanLiteralType = true,
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
