import XCTest
import SwiftSyntaxMacrosTestSupport

final class VersioningMacroObservableTests: XCTestCase {

    func test_expansion() throws {
        guard MacroTesting.shared.isEnabled else {
            throw XCTSkip()
        }

        assertMacroExpansion(
        """
        @Versioning
        @Observable
        final class Model {
            public var state1 = MyState()
            var state2: MyState = .init()
        }
        """,
        expandedSource: """
        @Observable
        final class Model {
            public var state1 = MyState()
            var state2: MyState = .init()

            var versioningError: (any Error)?

            @ObservationIgnored
            public private(set) lazy var _$state1 = VersioningController(
                on: self,
                at: \\.state1,
                storingErrorsAt: \\.versioningError,
                using: _$observationRegistrar
            )

            @ObservationIgnored
            private(set) lazy var _$state2 = VersioningController(
                on: self,
                at: \\.state2,
                storingErrorsAt: \\.versioningError,
                using: _$observationRegistrar
            )
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
        @Observable
        @Versioning("state1")
        final class Model {
            var state1 = MyState()
            var state2: MyState = .init()
        }
        """,
        expandedSource: """
        @Observable
        final class Model {
            var state1 = MyState()
            var state2: MyState = .init()
        
            var versioningError: (any Error)?

            @ObservationIgnored
            private(set) lazy var _$state1 = VersioningController(
                on: self,
                at: \\.state1,
                storingErrorsAt: \\.versioningError,
                using: _$observationRegistrar
            )
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
        @Observable
        @Versioning(errorMode: .throwErrors)
        final class Model {
            var state1 = MyState()
            var state2: MyState = .init()
        }
        """,
        expandedSource: """
        @Observable
        final class Model {
            var state1 = MyState()
            var state2: MyState = .init()

            @ObservationIgnored
            private(set) lazy var _$state1 = VersioningController(
                on: self,
                at: \\.state1,
                using: _$observationRegistrar
            )
        
            @ObservationIgnored
            private(set) lazy var _$state2 = VersioningController(
                on: self,
                at: \\.state2,
                using: _$observationRegistrar
            )
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
        @Observable
        @Versioning(errorMode: .assignErrors)
        final class Model {
            var state1 = MyState()
            var state2: MyState = .init()
        }
        """,
        expandedSource: """
        @Observable
        final class Model {
            var state1 = MyState()
            var state2: MyState = .init()

            var versioningError: (any Error)?

            @ObservationIgnored
            private(set) lazy var _$state1 = VersioningController(
                on: self,
                at: \\.state1,
                storingErrorsAt: \\.versioningError,
                using: _$observationRegistrar
            )

            @ObservationIgnored
            private(set) lazy var _$state2 = VersioningController(
                on: self,
                at: \\.state2,
                storingErrorsAt: \\.versioningError,
                using: _$observationRegistrar
            )
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
        @Observable
        @Versioning(errorMode: .assignErrors("error"))
        final class Model {
            var state1 = MyState()
            var state2: MyState = .init()
        }
        """,
        expandedSource: """
        @Observable
        final class Model {
            var state1 = MyState()
            var state2: MyState = .init()

            var error: (any Error)?

            @ObservationIgnored
            private(set) lazy var _$state1 = VersioningController(
                on: self,
                at: \\.state1,
                storingErrorsAt: \\.error,
                using: _$observationRegistrar
            )
        
            @ObservationIgnored
            private(set) lazy var _$state2 = VersioningController(
                on: self,
                at: \\.state2,
                storingErrorsAt: \\.error,
                using: _$observationRegistrar
            )
        }
        """,
        macros: MacroTesting.shared.testMacros
        )
    }

    func test_expansionWithExplicitCatchingErrorModeWithManualDeclaration() throws {
        guard MacroTesting.shared.isEnabled else {
            throw XCTSkip()
        }

        assertMacroExpansion(
        """
        @Observable
        @Versioning(errorMode: .assignErrors("error"))
        final class Model {
            var state1 = MyState()
            var state2: MyState = .init()
        
            var error: (any Error)?
        }
        """,
        expandedSource: """
        @Observable
        final class Model {
            var state1 = MyState()
            var state2: MyState = .init()

            var error: (any Error)?

            @ObservationIgnored
            private(set) lazy var _$state1 = VersioningController(
                on: self,
                at: \\.state1,
                storingErrorsAt: \\.error,
                using: _$observationRegistrar
            )
        
            @ObservationIgnored
            private(set) lazy var _$state2 = VersioningController(
                on: self,
                at: \\.state2,
                storingErrorsAt: \\.error,
                using: _$observationRegistrar
            )
        }
        """,
        macros: MacroTesting.shared.testMacros
        )
    }

    func test_expansionWithExplicitCatchingErrorModeWithManualStaticDeclaration() throws {
        guard MacroTesting.shared.isEnabled else {
            throw XCTSkip()
        }

        assertMacroExpansion(
        """
        @Observable
        @Versioning(errorMode: .assignErrors("error"))
        final class Model {
            var state1 = MyState()
            var state2: MyState = .init()
        
            static var error: (any Error)?
        }
        """,
        expandedSource: """
        @Observable
        final class Model {
            var state1 = MyState()
            var state2: MyState = .init()

            static var error: (any Error)?

            var error: (any Error)?

            @ObservationIgnored
            private(set) lazy var _$state1 = VersioningController(
                on: self,
                at: \\.state1,
                storingErrorsAt: \\.error,
                using: _$observationRegistrar
            )
        
            @ObservationIgnored
            private(set) lazy var _$state2 = VersioningController(
                on: self,
                at: \\.state2,
                storingErrorsAt: \\.error,
                using: _$observationRegistrar
            )
        }
        """,
        diagnostics: [
            .init(
                message: "Declared error property is marked as \"static\" and will be ignored.",
                line: 7,
                column: 5,
                severity: .warning
            )
        ],
        macros: MacroTesting.shared.testMacros
        )
    }

    func test_expansionWithExplicitCatchingErrorModeWithManualDeclarationOfWrongType() throws {
        guard MacroTesting.shared.isEnabled else {
            throw XCTSkip()
        }

        assertMacroExpansion(
        """
        @Observable
        @Versioning(errorMode: .assignErrors("error"))
        final class Model {
            var state1 = MyState()
            var state2: MyState = .init()
        
            var error: ConcreteError?
        }
        """,
        expandedSource: """
        @Observable
        final class Model {
            var state1 = MyState()
            var state2: MyState = .init()

            var error: ConcreteError?
        }
        """,
        diagnostics: [
            .init(
                message: "Declared error property must be of type \"Error?\" or \"(any Error)?\".",
                line: 7,
                column: 5
            )
        ],
        macros: MacroTesting.shared.testMacros
        )
    }

    func test_expansionWithExplicitCatchingErrorModeWithManualLetDeclaration() throws {
        guard MacroTesting.shared.isEnabled else {
            throw XCTSkip()
        }

        assertMacroExpansion(
        """
        @Observable
        @Versioning(errorMode: .assignErrors("error"))
        final class Model {
            var state1 = MyState()
            var state2: MyState = .init()
        
            let error: (any Error)?
        }
        """,
        expandedSource: """
        @Observable
        final class Model {
            var state1 = MyState()
            var state2: MyState = .init()

            let error: (any Error)?
        }
        """,
        diagnostics: [
            .init(
                message: "Declared error property must be declared as a \"var\".",
                line: 7,
                column: 5
            )
        ],
        macros: MacroTesting.shared.testMacros
        )
    }

    func test_expansionWithExplicitCatchingErrorModeWithManualComputedDeclaration() throws {
        guard MacroTesting.shared.isEnabled else {
            throw XCTSkip()
        }

        assertMacroExpansion(
        """
        @Observable
        @Versioning(errorMode: .assignErrors("error"))
        final class Model {
            var state1 = MyState()
            var state2: MyState = .init()
        
            var error: (any Error)? {
                nil
            }
        }
        """,
        expandedSource: """
        @Observable
        final class Model {
            var state1 = MyState()
            var state2: MyState = .init()

            var error: (any Error)? {
                nil
            }
        }
        """,
        diagnostics: [
            .init(
                message: "Declared error property must have an accessible getter and setter.",
                line: 7,
                column: 5
            )
        ],
        macros: MacroTesting.shared.testMacros
        )
    }

    func test_expansionWithExplicitCatchingErrorModeWithManualComputedGetterDeclaration() throws {
        guard MacroTesting.shared.isEnabled else {
            throw XCTSkip()
        }

        assertMacroExpansion(
        """
        @Observable
        @Versioning(errorMode: .assignErrors("error"))
        final class Model {
            var state1 = MyState()
            var state2: MyState = .init()
        
            var error: (any Error)? {
                get {
                    nil
                }
            }
        }
        """,
        expandedSource: """
        @Observable
        final class Model {
            var state1 = MyState()
            var state2: MyState = .init()

            var error: (any Error)? {
                get {
                    nil
                }
            }
        }
        """,
        diagnostics: [
            .init(
                message: "Declared error property must have an accessible getter and setter.",
                line: 7,
                column: 5
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
        @Observable
        @Versioning(debounceMilliseconds: 100)
        final class Model {
            var state1 = MyState()
            var state2: MyState = .init()
        }
        """,
        expandedSource: """
        @Observable
        final class Model {
            var state1 = MyState()
            var state2: MyState = .init()

            var versioningError: (any Error)?

            @ObservationIgnored
            private(set) lazy var _$state1 = VersioningController(
                on: self,
                at: \\.state1,
                storingErrorsAt: \\.versioningError,
                using: _$observationRegistrar,
                debounceInterval: .milliseconds(100)
            )

            @ObservationIgnored
            private(set) lazy var _$state2 = VersioningController(
                on: self,
                at: \\.state2,
                storingErrorsAt: \\.versioningError,
                using: _$observationRegistrar,
                debounceInterval: .milliseconds(100)
            )
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
        @Observable
        @Versioning(
            "state1",
            errorMode: .throwErrors,
            debounceMilliseconds: 100
        )
        final class Model {
            var state1 = MyState()
            var state2: MyState = .init()
        }
        """,
        expandedSource: """
        @Observable
        final class Model {
            var state1 = MyState()
            var state2: MyState = .init()

            @ObservationIgnored
            private(set) lazy var _$state1 = VersioningController(
                on: self,
                at: \\.state1,
                using: _$observationRegistrar,
                debounceInterval: .milliseconds(100)
            )
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
        @Observable
        @Versioning("state3")
        final class Model {
            var state1 = MyState()
            var state2: MyState = .init()
        }
        """,
        expandedSource: """
        @Observable
        final class Model {
            var state1 = MyState()
            var state2: MyState = .init()

            var versioningError: (any Error)?
        }
        """,
        diagnostics: [
            .init(
                message: "Property \"state3\" not found and will be ignored.",
                line: 2,
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
        @Observable
        @Versioning("state3")
        final class Model {
            var state1 = MyState()
            var state2: MyState = .init()
            static var state3 = MyState()
        }
        """,
        expandedSource: """
        @Observable
        final class Model {
            var state1 = MyState()
            var state2: MyState = .init()
            static var state3 = MyState()
        
            var versioningError: (any Error)?
        }
        """,
        diagnostics: [
            .init(
                message: "Property \"state3\" is \"static\" and will be ignored.",
                line: 2,
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
        @Observable
        @Versioning("state1")
        final class Model {
            let state1 = MyState()
            var state2: MyState = .init()
        }
        """,
        expandedSource: """
        @Observable
        final class Model {
            let state1 = MyState()
            var state2: MyState = .init()
        
            var versioningError: (any Error)?
        }
        """,
        diagnostics: [
            .init(
                message: "Property \"state1\" is a \"let\" declaration and will be ignored. Properties must be mutable to be used with \"@Versioning\".",
                line: 2,
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
        @Observable
        @Versioning("state1")
        final class Model {
            var state1: MyState {
                .init()
            }
            var state2 = MyState()
        }
        """,
        expandedSource: """
        @Observable
        final class Model {
            var state1: MyState {
                .init()
            }
            var state2 = MyState()

            var versioningError: (any Error)?
        }
        """,
        diagnostics: [
            .init(
                message: "Property \"state1\" has no setter and will be ignored. Properties must be mutable to be used with \"@Versioning\".",
                line: 2,
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
        @Observable
        @Versioning("state1")
        final class Model {
            var state1: MyState {
                get {
                    .init()
                }
            }
            var state2 = MyState()
        }
        """,
        expandedSource: """
        @Observable
        final class Model {
            var state1: MyState {
                get {
                    .init()
                }
            }
            var state2 = MyState()

            var versioningError: (any Error)?
        }
        """,
        diagnostics: [
            .init(
                message: "Property \"state1\" has no setter and will be ignored. Properties must be mutable to be used with \"@Versioning\".",
                line: 2,
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
        @Observable
        @Versioning("state1", errorMode: errorMode)
        final class Model {
            var state1 = MyState()
            var state2: MyState = .init()
        }
        """,
        expandedSource: """
        let errorMode = VersioningErrorHandlingMode.throwErrors
        @Observable
        final class Model {
            var state1 = MyState()
            var state2: MyState = .init()
        }
        """,
        diagnostics: [
            .init(
                message: "Invalid error mode declaration. The error mode must be declared in the macro itself and not assigned to a variable elsewhere.",
                line: 3,
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
        @Observable
        @Versioning("state1", errorMode: .assignErrors("")
        final class Model {
            var state1 = MyState()
            var state2: MyState = .init()
        }
        """,
        expandedSource: """
        @Observable
        final class Model {
            var state1 = MyState()
            var state2: MyState = .init()
        }
        """,
        diagnostics: [
            .init(
                message: "Error property name cannot be empty.",
                line: 2,
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
        @Observable
        @Versioning("state1", debounceMilliseconds: debounceMilliseconds)
        final class Model {
            var state1 = MyState()
            var state2: MyState = .init()
        }
        """,
        expandedSource: """
        let debounceMilliseconds = 100
        @Observable
        final class Model {
            var state1 = MyState()
            var state2: MyState = .init()
        }
        """,
        diagnostics: [
            .init(
                message: "Parameter must be a positive Integer literal.",
                line: 3,
                column: 1
            )
        ],
        macros: MacroTesting.shared.testMacros
        )
    }

    func test_expansionAllowsComputedProperties() throws {
        guard MacroTesting.shared.isEnabled else {
            throw XCTSkip()
        }

        assertMacroExpansion(
        """
        @Observable
        @Versioning("state1")
        final class Model {
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
        @Observable
        final class Model {
            var state1: MyState {
                get {
                    .init()
                }
                set {}
            }
            var state2 = MyState()

            var versioningError: (any Error)?

            @ObservationIgnored
            private(set) lazy var _$state1 = VersioningController(
                on: self,
                at: \\.state1,
                storingErrorsAt: \\.versioningError,
                using: _$observationRegistrar
            )
        }
        """,
        macros: MacroTesting.shared.testMacros
        )
    }
}
