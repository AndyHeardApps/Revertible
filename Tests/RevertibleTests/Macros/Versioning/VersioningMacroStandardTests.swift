import XCTest
import SwiftSyntaxMacrosTestSupport

final class VersioningMacroStandardTests: XCTestCase {

    func test_expansion() throws {
        guard MacroTesting.shared.isEnabled else {
            throw XCTSkip()
        }

        assertMacroExpansion(
        """
        @Versioning
        struct Model {
            var state1 = MyState()
            var state2: MyState = .init()
        }
        """,
        expandedSource: """
        struct Model {
            @Versioned
            var state1 = MyState()
            @Versioned
            var state2: MyState = .init()
        }
        """,
        macros: MacroTesting.shared.testMacros
        )
    }

    func test_expansionWithSpecificProperties() throws {
        guard MacroTesting.shared.isEnabled else {
            throw XCTSkip()
        }

        assertMacroExpansion(
        """
        @Versioning("state1")
        struct Model {
            var state1 = MyState()
            var state2: MyState = .init()
        }
        """,
        expandedSource: """
        struct Model {
            @Versioned
            var state1 = MyState()
            var state2: MyState = .init()
        }
        """,
        macros: MacroTesting.shared.testMacros
        )
    }

    func test_expansionWithThrowingErrorMode() throws {
        guard MacroTesting.shared.isEnabled else {
            throw XCTSkip()
        }

        assertMacroExpansion(
        """
        @Versioning(errorMode: .throwErrors)
        struct Model {
            var state1 = MyState()
            var state2: MyState = .init()
        }
        """,
        expandedSource: """
        struct Model {
            @ThrowingVersioned
            var state1 = MyState()
            @ThrowingVersioned
            var state2: MyState = .init()
        }
        """,
        macros: MacroTesting.shared.testMacros
        )
    }

    func test_expansionWithCatchingErrorMode() throws {
        guard MacroTesting.shared.isEnabled else {
            throw XCTSkip()
        }

        assertMacroExpansion(
        """
        @Versioning(errorMode: .assignErrors)
        struct Model {
            var state1 = MyState()
            var state2: MyState = .init()
        }
        """,
        expandedSource: """
        struct Model {
            @Versioned
            var state1 = MyState()
            @Versioned
            var state2: MyState = .init()
        }
        """,
        macros: MacroTesting.shared.testMacros
        )
    }

    func test_expansionWithExplicitCatchingErrorMode() throws {
        guard MacroTesting.shared.isEnabled else {
            throw XCTSkip()
        }

        assertMacroExpansion(
        """
        @Versioning(errorMode: .assignErrors("error"))
        struct Model {
            var state1 = MyState()
            var state2: MyState = .init()
        }
        """,
        expandedSource: """
        struct Model {
            @Versioned
            var state1 = MyState()
            @Versioned
            var state2: MyState = .init()
        }
        """,
        diagnostics: [
            .init(
                message: "Error property name will not be used. The macro is using \"@Versioned\" property wrappers which stores errors internally when the error mode is set to \".assignErrors\".",
                line: 1,
                column: 1,
                severity: .warning
            )
        ],
        macros: MacroTesting.shared.testMacros
        )
    }

    func test_expansionWithDebounceInterval() throws {
        guard MacroTesting.shared.isEnabled else {
            throw XCTSkip()
        }

        assertMacroExpansion(
        """
        @Versioning(debounceMilliseconds: 100)
        struct Model {
            var state1 = MyState()
            var state2: MyState = .init()
        }
        """,
        expandedSource: """
        struct Model {
            @Versioned(debounceInterval: .milliseconds(100))
            var state1 = MyState()
            @Versioned(debounceInterval: .milliseconds(100))
            var state2: MyState = .init()
        }
        """,
        macros: MacroTesting.shared.testMacros
        )
    }

    func test_expansionWithAllParameters() throws {
        guard MacroTesting.shared.isEnabled else {
            throw XCTSkip()
        }

        assertMacroExpansion(
        """
        @Versioning(
            "state1",
            errorMode: .throwErrors,
            debounceMilliseconds: 100
        )
        struct Model {
            var state1 = MyState()
            var state2: MyState = .init()
        }
        """,
        expandedSource: """
        struct Model {
            @ThrowingVersioned(debounceInterval: .milliseconds(100))
            var state1 = MyState()
            var state2: MyState = .init()
        }
        """,
        macros: MacroTesting.shared.testMacros
        )
    }

    func test_expansionWithMissingExplicitProperty() throws {
        guard MacroTesting.shared.isEnabled else {
            throw XCTSkip()
        }

        assertMacroExpansion(
        """
        @Versioning("state3")
        struct Model {
            var state1 = MyState()
            var state2: MyState = .init()
        }
        """,
        expandedSource: """
        struct Model {
            var state1 = MyState()
            var state2: MyState = .init()
        }
        """,
        diagnostics: [
            .init(
                message: "Property \"state3\" not found and will be ignored.",
                line: 1,
                column: 1,
                severity: .warning
            )
        ],
        macros: MacroTesting.shared.testMacros
        )
    }

    func test_expansionWithStaticExplicitProperty() throws {
        guard MacroTesting.shared.isEnabled else {
            throw XCTSkip()
        }

        assertMacroExpansion(
        """
        @Versioning("state3")
        struct Model {
            var state1 = MyState()
            var state2: MyState = .init()
            static var state3 = MyState()
        }
        """,
        expandedSource: """
        struct Model {
            var state1 = MyState()
            var state2: MyState = .init()
            static var state3 = MyState()
        }
        """,
        diagnostics: [
            .init(
                message: "Property \"state3\" is \"static\" and will be ignored.",
                line: 1,
                column: 1,
                severity: .warning
            )
        ],
        macros: MacroTesting.shared.testMacros
        )
    }

    func test_expansionWithImmutableLetExplicitProperty() throws {
        guard MacroTesting.shared.isEnabled else {
            throw XCTSkip()
        }

        assertMacroExpansion(
        """
        @Versioning("state1")
        struct Model {
            let state1 = MyState()
            var state2: MyState = .init()
        }
        """,
        expandedSource: """
        struct Model {
            let state1 = MyState()
            var state2: MyState = .init()
        }
        """,
        diagnostics: [
            .init(
                message: "Property \"state1\" is a \"let\" declaration and will be ignored. Properties must be mutable to be used with \"@Versioning\".",
                line: 1,
                column: 1,
                severity: .warning
            )
        ],
        macros: MacroTesting.shared.testMacros
        )
    }

    func test_expansionWithImmutableComputedExplicitProperty() throws {
        guard MacroTesting.shared.isEnabled else {
            throw XCTSkip()
        }

        assertMacroExpansion(
        """
        @Versioning("state1")
        struct Model {
            var state1: MyState {
                .init()
            }
            var state2 = MyState()
        }
        """,
        expandedSource: """
        struct Model {
            var state1: MyState {
                .init()
            }
            var state2 = MyState()
        }
        """,
        diagnostics: [
            .init(
                message: "Property \"state1\" has no setter and will be ignored. Properties must be mutable to be used with \"@Versioning\".",
                line: 1,
                column: 1,
                severity: .warning
            )
        ],
        macros: MacroTesting.shared.testMacros
        )
    }

    func test_expansionWithImmutableComputedGetterExplicitProperty() throws {
        guard MacroTesting.shared.isEnabled else {
            throw XCTSkip()
        }

        assertMacroExpansion(
        """
        @Versioning("state1")
        struct Model {
            var state1: MyState {
                get {
                    .init()
                }
            }
            var state2 = MyState()
        }
        """,
        expandedSource: """
        struct Model {
            var state1: MyState {
                get {
                    .init()
                }
            }
            var state2 = MyState()
        }
        """,
        diagnostics: [
            .init(
                message: "Property \"state1\" has no setter and will be ignored. Properties must be mutable to be used with \"@Versioning\".",
                line: 1,
                column: 1,
                severity: .warning
            )
        ],
        macros: MacroTesting.shared.testMacros
        )
    }

    func test_expansionWithIndirectErrorModeParameter() throws {
        guard MacroTesting.shared.isEnabled else {
            throw XCTSkip()
        }

        assertMacroExpansion(
        """
        let errorMode = VersioningErrorHandlingMode.throwErrors
        @Versioning("state1", errorMode: errorMode)
        struct Model {
            var state1 = MyState()
            var state2: MyState = .init()
        }
        """,
        expandedSource: """
        let errorMode = VersioningErrorHandlingMode.throwErrors
        struct Model {
            var state1 = MyState()
            var state2: MyState = .init()
        }
        """,
        diagnostics: [
            .init(
                message: "Invalid error mode declaration. The error mode must be declared in the macro itself and not assigned to a variable elsewhere.",
                line: 2,
                column: 1
            )
        ],
        macros: MacroTesting.shared.testMacros
        )
    }

    func test_expansionWithEmptyErrorModePropertyName() throws {
        guard MacroTesting.shared.isEnabled else {
            throw XCTSkip()
        }

        assertMacroExpansion(
        """
        @Versioning("state1", errorMode: .assignErrors("")
        struct Model {
            var state1 = MyState()
            var state2: MyState = .init()
        }
        """,
        expandedSource: """
        struct Model {
            var state1 = MyState()
            var state2: MyState = .init()
        }
        """,
        diagnostics: [
            .init(
                message: "Error property name cannot be empty.",
                line: 1,
                column: 1
            )
        ],
        macros: MacroTesting.shared.testMacros
        )
    }

    func test_expansionWithIndirectDebounceMillisecondsParameter() throws {
        guard MacroTesting.shared.isEnabled else {
            throw XCTSkip()
        }

        assertMacroExpansion(
        """
        let debounceMilliseconds = 100
        @Versioning("state1", debounceMilliseconds: debounceMilliseconds)
        struct Model {
            var state1 = MyState()
            var state2: MyState = .init()
        }
        """,
        expandedSource: """
        let debounceMilliseconds = 100
        struct Model {
            var state1 = MyState()
            var state2: MyState = .init()
        }
        """,
        diagnostics: [
            .init(
                message: "Parameter must be a positive Integer literal.",
                line: 2,
                column: 1
            )
        ],
        macros: MacroTesting.shared.testMacros
        )
    }

    func test_expansionIgnoresAlreadyVersionedProperties() throws {
        guard MacroTesting.shared.isEnabled else {
            throw XCTSkip()
        }

        assertMacroExpansion(
        """
        @Versioning
        struct Model {
            @Versioned
            var state1 = MyState()
            @ThrowingVersioned
            var state2 = MyState()
            @_Versioned
            var state3 = MyState()
            var state4 = MyState()
        }
        """,
        expandedSource: """
        struct Model {
            @Versioned
            var state1 = MyState()
            @ThrowingVersioned
            var state2 = MyState()
            @_Versioned
            var state3 = MyState()
            @Versioned
            var state4 = MyState()
        }
        """,
        macros: MacroTesting.shared.testMacros
        )
    }

    func test_expansionAllowsComputedProperties() throws {
        guard MacroTesting.shared.isEnabled else {
            throw XCTSkip()
        }

        assertMacroExpansion(
        """
        @Versioning("state1")
        struct Model {
            var state1: MyState {
                get {
                    .init()
                }
                set {}
            }
            var state2 = MyState()
        }
        """,
        expandedSource: """
        struct Model {
            @Versioned
            var state1: MyState {
                get {
                    .init()
                }
                set {}
            }
            var state2 = MyState()
        }
        """,
        macros: MacroTesting.shared.testMacros
        )
    }
}
