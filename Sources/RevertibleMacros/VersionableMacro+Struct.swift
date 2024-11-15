import SwiftSyntax
import SwiftSyntaxMacros
import SwiftDiagnostics

extension VersionableMacro {

    static func structExtensionSyntax(
        declaration: StructDeclSyntax,
        type: some TypeSyntaxProtocol
    ) throws -> [ExtensionDeclSyntax] {

        let accessScopeModifier = declaration.modifiers.first(where: \.isNeededAccessLevelModifier)?.minimumProtocolWitnessVisibilityForAccessModifier

        let variables = declaration.memberBlock.members
            .compactMap { $0.decl.as(VariableDeclSyntax.self) }
            .flatMap { variable in
                variable.bindings.compactMap { binding in
                    Property(declaration: variable, binding: binding)
                }
            }

        let body = CodeBlockSyntax(
            statements: .init(
                variables.map { variable in
                    CodeBlockItemSyntax(
                        item: .expr(
                            .init(
                                propertyReversionCall(on: variable.identifier.identifier)
                            )
                        )
                    )
                }
            )
        )

        let extensionSyntax = ExtensionDeclSyntax(
            extendedType: type,
            inheritanceClause: inheritanceClause(syntax: declaration.inheritanceClause),
            memberBlock: .init(
                members: .init(
                    itemsBuilder: {
                        revertFunctionDeclaration(accessScopeModifier: accessScopeModifier, body: body)
                    }
                )
            )
        )

        return [extensionSyntax]
    }
}

// MARK: - Property
private struct Property {

    // Properties
    let identifier: IdentifierPatternSyntax

    // Initializer
    init?(
        declaration: VariableDeclSyntax,
        binding: PatternBindingSyntax
    ) {

        let attributeNames = declaration.attributes
            .compactMap { $0.as(AttributeSyntax.self)?.attributeName }
            .compactMap { $0.as(IdentifierTypeSyntax.self)?.name.text }

        guard
            !attributeNames.contains("VersionableIgnored"),
            declaration.bindingSpecifier.tokenKind == .keyword(.var),
            let identifier = binding.pattern.as(IdentifierPatternSyntax.self)
        else {
            return nil
        }

        if
            let accessors = binding.accessorBlock?.accessors
                .as(AccessorDeclListSyntax.self)?
                .compactMap(\.accessorSpecifier.tokenKind),
            accessors.contains(.keyword(.set)) || accessors.contains(.keyword(.get))
        {
            return nil
        } else if
            let accessors = binding.accessorBlock?.accessors,
            accessors.is(CodeBlockItemListSyntax.self)
        {
            return nil
        }

        self.identifier = identifier
    }
}
