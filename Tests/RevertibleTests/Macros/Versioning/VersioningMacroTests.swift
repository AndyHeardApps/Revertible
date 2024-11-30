import XCTest
import SwiftSyntaxMacrosTestSupport

final class VersioningMacroTests: XCTestCase {

    func test_enumExpansion() throws {
        guard MacroTesting.shared.isEnabled else {
            throw XCTSkip()
        }

        assertMacroExpansion(
        """
        @Versioning(
            internalizesErrors: false,
            debounceMilliseconds: 300
        )
        struct DumbModel {

            @Versioned(debounceInterval: .milliseconds(300)) var person: Person = .init()
            @ThrowingVersioned var person2: Person

            var person3: Person = .init()
        }
        """,
        expandedSource: """
        """,
        macros: MacroTesting.shared.testMacros
        )
    }
}
