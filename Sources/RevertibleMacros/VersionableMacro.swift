import SwiftSyntax
import SwiftSyntaxMacros
import SwiftDiagnostics

public struct VersionableMacro {}

// MARK: - Extension macro
extension VersionableMacro: ExtensionMacro {

    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {

        if let enumDeclaration = declaration.as(EnumDeclSyntax.self) {
            enumExtensionSyntax(
                declaration: enumDeclaration,
                type: type
            )
        } else if let structDeclaration = declaration.as(StructDeclSyntax.self) {
            try structExtensionSyntax(
                declaration: structDeclaration,
                type: type
            )
        } else {
            throw DiagnosticsError(diagnostics: [
                .init(
                    node: Syntax(declaration),
                    message: DiagnosticMessage.notAValueType
                )
            ])
        }
    }
}

// MARK: - Revert function declaration
extension VersionableMacro {

    static func revertFunctionDeclaration(
        accessScopeModifier: TokenSyntax?,
        body: CodeBlockSyntax
    ) -> FunctionDeclSyntax {
        FunctionDeclSyntax(
            leadingTrivia: .newlines(2),
            attributes: [],
            modifiers: .init {
                if let accessScopeModifier {
                    DeclModifierSyntax(name: accessScopeModifier)
                }
            },
            name: "addReversions",
            signature: .init(
                parameterClause: .init(
                    parameters: [
                        .init(
                            firstName: "into",
                            secondName: "reverter",
                            type: AttributedTypeSyntax(
                                specifiers: TypeSpecifierListSyntax([
                                    .simpleTypeSpecifier(.init(specifier: .keyword(.inout)))
                                ]),
                                baseType: SomeOrAnyTypeSyntax(
                                    someOrAnySpecifier: .keyword(.some),
                                    constraint: IdentifierTypeSyntax(
                                        name: "Reverter",
                                        genericArgumentClause: .init(
                                            arguments: [
                                                GenericArgumentSyntax(
                                                    argument: IdentifierTypeSyntax(name: .keyword(.Self))
                                                )
                                            ]
                                        )
                                    )
                                )
                            )
                        )
                    ]
                )
            ),
            body: body,
            trailingTrivia: .newline
        )
    }

    static func propertyReversionCall(on property: TokenSyntax) -> FunctionCallExprSyntax {
        FunctionCallExprSyntax(
            callee: MemberAccessExprSyntax(
                base: DeclReferenceExprSyntax(baseName: .identifier("reverter")),
                name: .identifier("appendReversion")
            ),
            argumentList: {
                .init(
                    label: "at",
                    expression: KeyPathExprSyntax(
                        components: [
                            KeyPathComponentSyntax(
                                period: .periodToken(),
                                component: .property(
                                    .init(
                                        declName: .init(baseName: property).trimmed
                                    )
                                )
                            )
                        ]
                    )
                )
            }
        )
    }
}

// MARK: - Inheritance clause
extension VersionableMacro {

    static func inheritanceClause(syntax: InheritanceClauseSyntax?) -> InheritanceClauseSyntax? {

        let inheritedTypeNames = syntax?.inheritedTypes
            .compactMap { type in
                type.type.trimmedDescription
                    .replacingOccurrences(of: "@retroactive", with: "")
                    .trimmingCharacters(in: .whitespaces)
            } ?? []

        if inheritedTypeNames.contains("Versionable") {
            return nil
        }

        let inheritanceClause = InheritanceClauseSyntax(
            inheritedTypes: [
                .init(
                    type: IdentifierTypeSyntax(name: "Versionable")
                )
            ]
        )

        return inheritanceClause
    }
}

// MARK: - Diagnostic message
extension VersionableMacro {
    fileprivate enum DiagnosticMessage {

        case notAValueType
    }
}

extension VersionableMacro.DiagnosticMessage: SwiftDiagnostics.DiagnosticMessage {

    var message: String {

        switch self {
        case .notAValueType:
            "Macro \"@Versionable\" can only be applied to a value type."

        }
    }

    private var messageID: String {

        switch self {
        case .notAValueType:
            "notAValueType"

        }
    }

    var diagnosticID: MessageID {

        .init(
            domain: "VersionableMacro",
            id: messageID
        )
    }

    var severity: DiagnosticSeverity {

        switch self {
        case .notAValueType:
            .error

        }
    }
}
