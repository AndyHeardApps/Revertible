import SwiftSyntaxMacros
#if canImport(RevertibleMacros)
@testable import RevertibleMacros
#endif

struct MacroTesting {

    // MARK: - Static properties
    static let shared = MacroTesting()

    // MARK: - Properties
    let testMacros: [String : Macro.Type]
    let isEnabled: Bool

    // MARK: - Initializer
    private init() {

        #if canImport(RevertibleMacros)
        self.testMacros = [
            "Versionable" : VersionableMacro.self,
            "VersionableIgnored" : VersionableIgnoredMacro.self
        ]
        self.isEnabled = true
        #else
        self.testMacros = [:]
        self.isEnabled = false
        #endif
    }
}
