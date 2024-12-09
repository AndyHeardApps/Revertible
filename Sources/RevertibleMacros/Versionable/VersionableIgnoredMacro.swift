import SwiftSyntax
import SwiftSyntaxMacros

public struct VersionableIgnoredMacro {}

// MARK: - Extension macro
extension VersionableIgnoredMacro: AccessorMacro {

    public static func expansion(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AccessorDeclSyntax] {
        []
    }
}
