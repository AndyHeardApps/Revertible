import XCTest
import SwiftSyntaxMacrosTestSupport

final class VersioningMacroObservableObjectTests: XCTestCase {

    func test_expansion() throws {
        guard MacroTesting.shared.isEnabled else {
            throw XCTSkip()
        }

        assertMacroExpansion(
        """
        @Versioning
        final class Model: ObservableObject {
            public var state1 = MyState()
            var state2: MyState = .init()
        }
        """,
        expandedSource: """
        final class Model: ObservableObject {
            public var state1 = MyState()
            var state2: MyState = .init()

            var versioningError: (any Error)?

            public private(set) lazy var _$state1 = VersioningController(
                on: self,
                at: \\.state1,
                storingErrorsAt: \\.versioningError,
                scheduler: DispatchQueue.main
            )

            private(set) lazy var _$state2 = VersioningController(
                on: self,
                at: \\.state2,
                storingErrorsAt: \\.versioningError,
                scheduler: DispatchQueue.main
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
        @Versioning("state1")
        final class Model: ObservableObject {
            var state1 = MyState()
            var state2: MyState = .init()
        }
        """,
        expandedSource: """
        final class Model: ObservableObject {
            var state1 = MyState()
            var state2: MyState = .init()
        
            var versioningError: (any Error)?

            private(set) lazy var _$state1 = VersioningController(
                on: self,
                at: \\.state1,
                storingErrorsAt: \\.versioningError,
                scheduler: DispatchQueue.main
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
        @Versioning(errorMode: .throwErrors)
        final class Model: ObservableObject {
            var state1 = MyState()
            var state2: MyState = .init()
        }
        """,
        expandedSource: """
        final class Model: ObservableObject {
            var state1 = MyState()
            var state2: MyState = .init()

            private(set) lazy var _$state1 = VersioningController(
                on: self,
                at: \\.state1,
                scheduler: DispatchQueue.main
            )
        
            private(set) lazy var _$state2 = VersioningController(
                on: self,
                at: \\.state2,
                scheduler: DispatchQueue.main
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
        @Versioning(errorMode: .assignErrors)
        final class Model: ObservableObject {
            var state1 = MyState()
            var state2: MyState = .init()
        }
        """,
        expandedSource: """
        final class Model: ObservableObject {
            var state1 = MyState()
            var state2: MyState = .init()

            var versioningError: (any Error)?

            private(set) lazy var _$state1 = VersioningController(
                on: self,
                at: \\.state1,
                storingErrorsAt: \\.versioningError,
                scheduler: DispatchQueue.main
            )

            private(set) lazy var _$state2 = VersioningController(
                on: self,
                at: \\.state2,
                storingErrorsAt: \\.versioningError,
                scheduler: DispatchQueue.main
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
        @Versioning(errorMode: .assignErrors("error"))
        final class Model: ObservableObject {
            var state1 = MyState()
            var state2: MyState = .init()
        }
        """,
        expandedSource: """
        final class Model: ObservableObject {
            var state1 = MyState()
            var state2: MyState = .init()

            var error: (any Error)?

            private(set) lazy var _$state1 = VersioningController(
                on: self,
                at: \\.state1,
                storingErrorsAt: \\.error,
                scheduler: DispatchQueue.main
            )
        
            private(set) lazy var _$state2 = VersioningController(
                on: self,
                at: \\.state2,
                storingErrorsAt: \\.error,
                scheduler: DispatchQueue.main
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
        @Versioning(errorMode: .assignErrors("error"))
        final class Model: ObservableObject {
            var state1 = MyState()
            var state2: MyState = .init()
        
            var error: (any Error)?
        }
        """,
        expandedSource: """
        final class Model: ObservableObject {
            var state1 = MyState()
            var state2: MyState = .init()

            var error: (any Error)?

            private(set) lazy var _$state1 = VersioningController(
                on: self,
                at: \\.state1,
                storingErrorsAt: \\.error,
                scheduler: DispatchQueue.main
            )
        
            private(set) lazy var _$state2 = VersioningController(
                on: self,
                at: \\.state2,
                storingErrorsAt: \\.error,
                scheduler: DispatchQueue.main
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
        @Versioning(errorMode: .assignErrors("error"))
        final class Model: ObservableObject {
            var state1 = MyState()
            var state2: MyState = .init()
        
            static var error: (any Error)?
        }
        """,
        expandedSource: """
        final class Model: ObservableObject {
            var state1 = MyState()
            var state2: MyState = .init()

            static var error: (any Error)?

            var error: (any Error)?

            private(set) lazy var _$state1 = VersioningController(
                on: self,
                at: \\.state1,
                storingErrorsAt: \\.error,
                scheduler: DispatchQueue.main
            )
        
            private(set) lazy var _$state2 = VersioningController(
                on: self,
                at: \\.state2,
                storingErrorsAt: \\.error,
                scheduler: DispatchQueue.main
            )
        }
        """,
        diagnostics: [
            .init(
                message: "Declared error property is marked as \"static\" and will be ignored.",
                line: 6,
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
        @Versioning(errorMode: .assignErrors("error"))
        final class Model: ObservableObject {
            var state1 = MyState()
            var state2: MyState = .init()
        
            var error: ConcreteError?
        }
        """,
        expandedSource: """
        final class Model: ObservableObject {
            var state1 = MyState()
            var state2: MyState = .init()

            var error: ConcreteError?
        }
        """,
        diagnostics: [
            .init(
                message: "Declared error property must be of type \"Error?\" or \"(any Error)?\".",
                line: 6,
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
        @Versioning(errorMode: .assignErrors("error"))
        final class Model: ObservableObject {
            var state1 = MyState()
            var state2: MyState = .init()
        
            let error: (any Error)?
        }
        """,
        expandedSource: """
        final class Model: ObservableObject {
            var state1 = MyState()
            var state2: MyState = .init()

            let error: (any Error)?
        }
        """,
        diagnostics: [
            .init(
                message: "Declared error property must be declared as a \"var\".",
                line: 6,
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
        @Versioning(errorMode: .assignErrors("error"))
        final class Model: ObservableObject {
            var state1 = MyState()
            var state2: MyState = .init()
        
            var error: (any Error)? {
                nil
            }
        }
        """,
        expandedSource: """
        final class Model: ObservableObject {
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
                line: 6,
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
        @Versioning(errorMode: .assignErrors("error"))
        final class Model: ObservableObject {
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
        final class Model: ObservableObject {
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
                line: 6,
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
        @Versioning(debounceMilliseconds: 100)
        final class Model: ObservableObject {
            var state1 = MyState()
            var state2: MyState = .init()
        }
        """,
        expandedSource: """
        final class Model: ObservableObject {
            var state1 = MyState()
            var state2: MyState = .init()

            var versioningError: (any Error)?

            private(set) lazy var _$state1 = VersioningController(
                on: self,
                at: \\.state1,
                storingErrorsAt: \\.versioningError,
                scheduler: DispatchQueue.main,
                debounceInterval: .milliseconds(100)
            )

            private(set) lazy var _$state2 = VersioningController(
                on: self,
                at: \\.state2,
                storingErrorsAt: \\.versioningError,
                scheduler: DispatchQueue.main,
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
        @Versioning(
            "state1",
            errorMode: .throwErrors,
            debounceMilliseconds: 100
        )
        final class Model: ObservableObject {
            var state1 = MyState()
            var state2: MyState = .init()
        }
        """,
        expandedSource: """
        final class Model: ObservableObject {
            var state1 = MyState()
            var state2: MyState = .init()

            private(set) lazy var _$state1 = VersioningController(
                on: self,
                at: \\.state1,
                scheduler: DispatchQueue.main,
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
        @Versioning("state3")
        final class Model: ObservableObject {
            var state1 = MyState()
            var state2: MyState = .init()
        }
        """,
        expandedSource: """
        final class Model: ObservableObject {
            var state1 = MyState()
            var state2: MyState = .init()

            var versioningError: (any Error)?
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
        final class Model: ObservableObject {
            var state1 = MyState()
            var state2: MyState = .init()
            static var state3 = MyState()
        }
        """,
        expandedSource: """
        final class Model: ObservableObject {
            var state1 = MyState()
            var state2: MyState = .init()
            static var state3 = MyState()
        
            var versioningError: (any Error)?
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
        final class Model: ObservableObject {
            let state1 = MyState()
            var state2: MyState = .init()
        }
        """,
        expandedSource: """
        final class Model: ObservableObject {
            let state1 = MyState()
            var state2: MyState = .init()
        
            var versioningError: (any Error)?
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
        final class Model: ObservableObject {
            var state1: MyState {
                .init()
            }
            var state2 = MyState()
        }
        """,
        expandedSource: """
        final class Model: ObservableObject {
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
        final class Model: ObservableObject {
            var state1: MyState {
                get {
                    .init()
                }
            }
            var state2 = MyState()
        }
        """,
        expandedSource: """
        final class Model: ObservableObject {
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
        final class Model: ObservableObject {
            var state1 = MyState()
            var state2: MyState = .init()
        }
        """,
        expandedSource: """
        let errorMode = VersioningErrorHandlingMode.throwErrors
        final class Model: ObservableObject {
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
        final class Model: ObservableObject {
            var state1 = MyState()
            var state2: MyState = .init()
        }
        """,
        expandedSource: """
        final class Model: ObservableObject {
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
        final class Model: ObservableObject {
            var state1 = MyState()
            var state2: MyState = .init()
        }
        """,
        expandedSource: """
        let debounceMilliseconds = 100
        final class Model: ObservableObject {
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

    func test_expansionAllowsComputedProperties() throws {
        guard MacroTesting.shared.isEnabled else {
            throw XCTSkip()
        }

        assertMacroExpansion(
        """
        @Versioning("state1")
        final class Model: ObservableObject {
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
        final class Model: ObservableObject {
            var state1: MyState {
                get {
                    .init()
                }
                set {}
            }
            var state2 = MyState()

            var versioningError: (any Error)?

            private(set) lazy var _$state1 = VersioningController(
                on: self,
                at: \\.state1,
                storingErrorsAt: \\.versioningError,
                scheduler: DispatchQueue.main
            )
        }
        """,
        macros: MacroTesting.shared.testMacros
        )
    }
}
