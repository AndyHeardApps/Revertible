import SwiftSyntax

extension VersioningMacro {
    struct Property {

        // MARK: - Properties
        let identifier: IdentifierPatternSyntax
        let declarationType: DeclarationType
        let containsVersionedAttribute: Bool
        let accessScopeModifier: DeclModifierSyntax?
        var name: String {
            identifier.identifier.text
        }

        // MARK: - Initializer
        init?(
            declaration: VariableDeclSyntax,
            binding: PatternBindingSyntax
        ) {

            // Identifier
            guard
                let identifier = binding.pattern.as(IdentifierPatternSyntax.self)
            else {
                return nil
            }
            self.identifier = identifier

            // Access modifier
            self.accessScopeModifier = declaration.modifiers.first(where: \.isNeededAccessLevelModifier)

            // Existing attributes
            let attributes = declaration.attributes
                .compactMap { $0.as(AttributeSyntax.self)?.attributeName }
                .compactMap { $0.as(IdentifierTypeSyntax.self)?.name.text }
            self.containsVersionedAttribute = attributes.contains("_Versioned") ||
                attributes.contains("Versioned") ||
                attributes.contains("ThrowingVersioned")

            // Property accessors
            if declaration.modifiers.map(\.name.tokenKind).contains(.keyword(.static)) {
                self.declarationType = .static

            } else {
                switch declaration.bindingSpecifier.tokenKind {
                case .keyword(.let):
                    self.declarationType = .let

                case .keyword(.var) where binding.accessorBlock == nil:
                    self.declarationType = .basicVar

                case .keyword(.var) :
                    guard let accessorBlock = binding.accessorBlock else {
                        return nil
                    }

                    let accessorSpecifiers = accessorBlock.accessors
                        .as(AccessorDeclListSyntax.self)?
                        .compactMap(\.accessorSpecifier.tokenKind) ?? []

                    if accessorSpecifiers.contains(.keyword(.set)) {
                        self.declarationType = .computedGetterSetter
                    } else if accessorSpecifiers.contains(.keyword(.get)) {
                        self.declarationType = .computedGetter
                    } else if accessorBlock.accessors.is(CodeBlockItemListSyntax.self) == true {
                        self.declarationType = .computedGetter
                    } else {
                        self.declarationType = .basicVar
                    }

                default:
                    return nil

                }
            }

        }
    }
}

// MARK: - Declaration type
extension VersioningMacro {
    enum DeclarationType {
        case `static`
        case `let`
        case basicVar
        case computedGetter
        case computedGetterSetter
    }
}
