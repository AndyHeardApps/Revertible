import XCTest
import SwiftSyntaxMacrosTestSupport

final class StructMacroTests: XCTestCase {

    func test_structExpansion() throws {

        guard MacroTesting.shared.isEnabled else {
            throw XCTSkip()
        }

        assertMacroExpansion(
        """
        @Versionable
        struct MyStruct {
            let immutable = 0
            var mutable = 0
            var computed: Int {
                0
            }
            var wrapper: Int {
                get { 0 }
                set {}
            }
            var observed = 0 {
                didSet {}
                willSet {}
            }
            @VersionableIgnored
            var ignored = 0
        }
        """,
        expandedSource: """
        struct MyStruct {
            let immutable = 0
            var mutable = 0
            var computed: Int {
                0
            }
            var wrapper: Int {
                get { 0 }
                set {}
            }
            var observed = 0 {
                didSet {}
                willSet {}
            }
            var ignored = 0
        }
        
        extension MyStruct: Versionable {

            func addReversions(into reverter: inout some Reverter<Self>) {
                reverter.appendReversion(at: \\.mutable )
                reverter.appendReversion(at: \\.observed )
            }
        }
        """,
        macros: MacroTesting.shared.testMacros
        )
    }

    func test_structExpansion_private() throws {

        guard MacroTesting.shared.isEnabled else {
            throw XCTSkip()
        }

        assertMacroExpansion(
        """
        @Versionable
        private struct MyStruct: Versionable {
            var value = 0
        }
        """,
        expandedSource: """
        private struct MyStruct: Versionable {
            var value = 0
        }
        
        extension MyStruct {

            fileprivate func addReversions(into reverter: inout some Reverter<Self>) {
                reverter.appendReversion(at: \\.value )
            }
        }
        """,
        macros: MacroTesting.shared.testMacros
        )
    }
}
