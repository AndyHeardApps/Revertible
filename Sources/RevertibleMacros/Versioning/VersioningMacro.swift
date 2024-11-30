import SwiftSyntax
import SwiftSyntaxMacros
import SwiftDiagnostics

public struct VersioningMacro {}

extension VersioningMacro: MemberMacro {

    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {

        let mode = mode(from: declaration)

        guard [.observable, .observedObject].contains(mode) else {
            return []
        }

        let arguments = try parseArguments(
            for: mode,
            from: node,
            on: declaration,
            in: context
        )
        
        let errorProperty = errorProperty(
            arguments: arguments,
            from: declaration
        )
        
        let properties = arguments.properties.map {
            DeclSyntax(
                versioningControllerDeclaration(
                    for: $0,
                    arguments: arguments,
                    withMacroMode: mode
                )
            )
        }
        
        return (CollectionOfOne(errorProperty) + properties).compactMap { $0 }
    }

    private static func versioningControllerDeclaration(
        for property: Property,
        arguments: Arguments,
        withMacroMode macroMode: Mode
    ) -> VariableDeclSyntax {
        .init(
            attributes: .init(
                itemsBuilder: {
                    if macroMode == .observable {
                        AttributeSyntax(
                            attributeName: IdentifierTypeSyntax(name: "ObservationIgnored"),
                            trailingTrivia: .newline
                        )
                    }
                }
            ),
            modifiers: .init(
                itemsBuilder: {
                    if let accessScopeModifier = property.accessScopeModifier {
                        accessScopeModifier
                    }
                    if property.accessScopeModifier?.name.tokenKind != .keyword(.private) {
                        .init(
                            name: .keyword(.private),
                            detail: .init(
                                leftParen: .leftParenToken(),
                                detail: .keyword(.set),
                                rightParen: .rightParenToken()
                            )
                        )
                    }
                    .init(name: .keyword(.lazy))
                }
            ),
            bindingSpecifier: .keyword(.var),
            bindings: [
                .init(
                    pattern: IdentifierPatternSyntax(identifier: .identifier("_$\(property.name)")),
                    initializer: .init(
                        equal: .equalToken(),
                        value: FunctionCallExprSyntax(
                            calledExpression: DeclReferenceExprSyntax(baseName: .identifier("VersioningController")),
                            leftParen: .leftParenToken(),
                            arguments: .init(
                                itemsBuilder: {
                                    LabeledExprSyntax(
                                        leadingTrivia: .newline,
                                        label: "on",
                                        colon: .colonToken(),
                                        expression: DeclReferenceExprSyntax(baseName: "self"),
                                        trailingComma: .commaToken()
                                    )
                                    LabeledExprSyntax(
                                        leadingTrivia: .newline,
                                        label: "at",
                                        colon: .colonToken(),
                                        expression: KeyPathExprSyntax(
                                            components: [
                                                .init(
                                                    period: .periodToken(),
                                                    component: .property(
                                                        .init(
                                                            declName: .init(
                                                                baseName: .identifier(property.name)
                                                            )
                                                        )
                                                    )
                                                )
                                            ]
                                        ),
                                        trailingComma: (macroMode == .observable || arguments.errorMode != .throwErrors)  ? .commaToken() : nil
                                    )
                                    if case let .assignErrors(errorPropertyName) = arguments.errorMode {
                                        LabeledExprSyntax(
                                            leadingTrivia: .newline,
                                            label: "storingErrorsAt",
                                            colon: .colonToken(),
                                            expression: KeyPathExprSyntax(
                                                components: [
                                                    .init(
                                                        period: .periodToken(),
                                                        component: .property(
                                                            .init(
                                                                declName: .init(
                                                                    baseName: .identifier(errorPropertyName)
                                                                )
                                                            )
                                                        )
                                                    )
                                                ]
                                            ),
                                            trailingComma: macroMode == .observable ? .commaToken() : nil
                                        )
                                    }
                                    if let debounceInterval = arguments.debounceInterval {
                                        debounceExpression(
                                            duration: debounceInterval,
                                            leadingNewLine: true,
                                            trailingComma: macroMode == .observable
                                        )
                                    }
                                    if macroMode == .observable {
                                        LabeledExprSyntax(
                                            leadingTrivia: .newline,
                                            label: "using",
                                            colon: .colonToken(),
                                            expression: DeclReferenceExprSyntax(baseName: "_$observationRegistrar")
                                        )
                                    }
                                }
                            ),
                            rightParen: .rightParenToken(leadingTrivia: .newline)
                        )
                    )
                )
            ]
        )
    }
    
    private static func errorProperty(
        arguments: Arguments,
        from declaration: some DeclGroupSyntax
    ) -> DeclSyntax? {
        
        guard case let .assignErrors(errorPropertyName) = arguments.errorMode else {
            return nil
        }
        
        // Check for existing
        
        // Validate existing is correct type, not static, correct access modifier, has getter and setter
        
        // Create property if nil
        
        return nil
    }
}

extension VersioningMacro: MemberAttributeMacro {

    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingAttributesFor member: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AttributeSyntax] {

        let mode = mode(from: declaration)
        let arguments = try parseArguments(
            for: mode,
            from: node,
            on: declaration,
            in: context
        )

        guard
            let propertyDeclaration = member.as(VariableDeclSyntax.self),
            propertyDeclaration.bindings.count == 1,
            mode == .default,
            let binding = propertyDeclaration.bindings.first?.pattern.as(IdentifierPatternSyntax.self),
            let property = arguments.properties.first(where: { $0.name == binding.identifier.text }),
            !property.containsVersionedAttribute
        else {
            return []
        }

        let hasParameters = arguments.debounceInterval != nil
        let versionedPropertyWrapper = AttributeSyntax(
            attributeName: IdentifierTypeSyntax(name: arguments.errorMode == .throwErrors ? "ThrowingVersioned" : "Versioned"),
            leftParen: hasParameters ? .leftParenToken() : nil,
            arguments: .argumentList(
                .init(
                    itemsBuilder: {
                        if let debounceInterval = arguments.debounceInterval {
                            debounceExpression(
                                duration: debounceInterval,
                                leadingNewLine: false,
                                trailingComma: false
                            )
                        }
                    }
                )
            ),
            rightParen: hasParameters ? .rightParenToken() : nil
        )

        return [versionedPropertyWrapper]
    }
}

// MARK: - Mode
extension VersioningMacro {

    enum Mode {
        case `default`
        case observable
        case observedObject
    }

    private static func mode(from declaration: some DeclGroupSyntax) -> Mode {

        let isObservableObject = declaration.inheritanceClause?
            .inheritedTypes
            .compactMap {
                $0.type.as(IdentifierTypeSyntax.self)?.name.text
            }
            .contains("ObservableObject") ?? false


        let isObservable = declaration.attributes
            .compactMap {
                guard
                    case let .attribute(attribute) = $0,
                    let name = attribute.attributeName.as(IdentifierTypeSyntax.self)?.name.text
                else {
                    return nil
                }

                return name
            }
            .contains("Observable")

        if isObservable {
            return .observable
        } else if isObservableObject {
            return .observedObject
        } else {
            return .default
        }
    }
}

// MARK: - Debounce expression
extension VersioningMacro {
    
    private static func debounceExpression(
        duration: UInt,
        leadingNewLine: Bool,
        trailingComma: Bool
    ) -> LabeledExprSyntax {
        LabeledExprSyntax(
            leadingTrivia: leadingNewLine ? .newline : nil,
            label: "debounceInterval",
            colon: .colonToken(),
            expression: FunctionCallExprSyntax(
                calledExpression: MemberAccessExprSyntax(
                    period: .periodToken(),
                    name: .identifier("milliseconds")
                ),
                leftParen: .leftParenToken(),
                arguments: [
                    .init(
                        expression: IntegerLiteralExprSyntax(
                            literal: .integerLiteral(duration.description)
                        )
                    )
                ],
                rightParen: .rightParenToken()
            ),
            trailingComma: trailingComma ? .commaToken() : nil
        )
    }
}
