import XCTest
import SwiftSyntaxMacrosTestSupport

final class VersoinableMacroEnumTests: XCTestCase {

    func test_enumExpansion() throws {

        guard MacroTesting.shared.isEnabled else {
            throw XCTSkip()
        }

        assertMacroExpansion(
        """
        @Versionable
        enum MyEnum {
            case basic
            case associatedValue(Int)
            case associatedValues(Int, named: Int)
        }
        """,
        expandedSource: """
        enum MyEnum {
            case basic
            case associatedValue(Int)
            case associatedValues(Int, named: Int)
        }
        
        extension MyEnum: Versionable {
        
            func addReversions(into reverter: inout some Reverter<Self>) {
                guard reverter.hasChanged(at: \\.caseName) == false else {
                    reverter.appendOverwriteReversion(at: \\.self)
                    return
                }
                reverter.appendReversion(at: \\.associatedValue_$0)
                reverter.appendReversion(at: \\.associatedValues_$0)
                reverter.appendReversion(at: \\.associatedValues_named)
            }
        
            private enum CaseName {
                case basic
                case associatedValue
                case associatedValues
            }
        
            private var caseName: CaseName {
                switch self {
                case .basic:
                    .basic
                case .associatedValue:
                    .associatedValue
                case .associatedValues:
                    .associatedValues
                }
            }
        
            private var associatedValue_$0: Int? {
                get {
                    guard case let .associatedValue(associatedValue_$0) = self else {
                        return nil
                    }
                    return associatedValue_$0
                }
                set {
                    guard case .associatedValue = self, let newValue else {
                        return
                    }
                    self = .associatedValue(newValue)
                }
            }
        
            private var associatedValues_$0: Int? {
                get {
                    guard case let .associatedValues(associatedValues_$0, _) = self else {
                        return nil
                    }
                    return associatedValues_$0
                }
                set {
                    guard case let .associatedValues(_, associatedValues_named) = self, let newValue else {
                        return
                    }
                    self = .associatedValues(newValue, named: associatedValues_named)
                }
            }
        
            private var associatedValues_named: Int? {
                get {
                    guard case let .associatedValues(_, associatedValues_named) = self else {
                        return nil
                    }
                    return associatedValues_named
                }
                set {
                    guard case let .associatedValues(associatedValues_$0, _) = self, let newValue else {
                        return
                    }
                    self = .associatedValues(associatedValues_$0, named: newValue)
                }
            }
        }
        """,
        macros: MacroTesting.shared.testMacros
        )
    }
}
