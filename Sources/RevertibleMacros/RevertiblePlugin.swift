import SwiftSyntaxMacros
import SwiftCompilerPlugin

@main
struct RevertiblePlugin: CompilerPlugin {

    // MARK: - Properties
    let providingMacros: [Macro.Type] = [
        VersionableMacro.self,
        VersionableIgnoredMacro.self
    ]
}
