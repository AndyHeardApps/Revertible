import SwiftSyntax

extension DeclModifierSyntax {

    var minimumProtocolWitnessVisibilityForAccessModifier: TokenSyntax? {

        switch name.tokenKind {
        case .keyword(.public):
            return .keyword(.public)
        case .keyword(.internal):
            return .keyword(.internal)
        case .keyword(.fileprivate):
            return .keyword(.fileprivate)
        case .keyword(.private):
            return .keyword(.fileprivate)
        default:
            return nil
        }
    }

    var isNeededAccessLevelModifier: Bool {

        switch name.tokenKind {
        case .keyword(.public):
            return true
        case .keyword(.internal):
            return false
        case .keyword(.fileprivate):
            return true
        case .keyword(.private):
            return true
        default:
            return false
        }
    }
}
