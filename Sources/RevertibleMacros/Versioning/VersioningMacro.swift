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

        let arguments = try parseArguments(
            for: mode,
            from: node,
            on: declaration,
            in: context
        )

        guard [.observable, .observedObject].contains(mode) else {
            return []
        }

        let errorProperty = try errorProperty(
            arguments: arguments,
            from: declaration,
            in: context
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
                                    if macroMode == .observable {
                                        LabeledExprSyntax(
                                            leadingTrivia: .newline,
                                            label: "using",
                                            colon: .colonToken(),
                                            expression: DeclReferenceExprSyntax(baseName: "_$observationRegistrar"),
                                            trailingComma: arguments.debounceInterval == nil ? nil : .commaToken()
                                        )
                                    }
                                    if let debounceInterval = arguments.debounceInterval {
                                        debounceExpression(
                                            duration: debounceInterval,
                                            leadingNewLine: true
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
        from declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> DeclSyntax? {

        guard case let .assignErrors(errorPropertyName) = arguments.errorMode else {
            return nil
        }

        let errorPropertyDeclaration = VariableDeclSyntax(
            bindingSpecifier: .keyword(.var),
            bindings: [
                .init(
                    pattern: IdentifierPatternSyntax(identifier: .identifier(errorPropertyName)),
                    typeAnnotation: .init(
                        type: OptionalTypeSyntax(
                            wrappedType: TupleTypeSyntax(
                                elements: [
                                    .init(
                                        type: SomeOrAnyTypeSyntax(
                                            someOrAnySpecifier: .keyword(.any),
                                            constraint: IdentifierTypeSyntax(
                                                name: .identifier("Error")
                                            )
                                        )
                                    )
                                ]
                            )
                        )
                    )
                )
            ]
        )

        let properties = declaration.memberBlock.members
            .compactMap { $0.decl.as(VariableDeclSyntax.self) }
            .flatMap { variable in
                variable.bindings.compactMap { binding in
                    (variable, binding)
                }
            }

        if
            let (variable, binding) = properties.first(where: {
                $0.1.pattern
                    .as(IdentifierPatternSyntax.self)?
                    .identifier.text == errorPropertyName
            })
        {

            guard !variable.modifiers.map(\.name.tokenKind).contains(.keyword(.static)) else {
                context.diagnose(
                    .init(
                        node: variable,
                        message: DiagnosticMessage.errorPropertyIsStatic
                    )
                )
                return .init(errorPropertyDeclaration)
            }

            guard
                let optionalBinding = binding.typeAnnotation?.type.as(OptionalTypeSyntax.self),
                optionalBinding.wrappedType.description.contains("Error")
            else {
                throw DiagnosticsError(diagnostics: [
                    .init(
                        node: variable,
                        message: DiagnosticMessage.errorPropertyIsWrongType
                    )
                ])
            }

            guard variable.bindingSpecifier.tokenKind == .keyword(.var) else {
                throw DiagnosticsError(diagnostics: [
                    .init(
                        node: variable,
                        message: DiagnosticMessage.errorPropertyIsNotVariable
                    )
                ])
            }

            if
                let accessors = binding.accessorBlock?.accessors
                    .as(AccessorDeclListSyntax.self)?
                    .compactMap(\.accessorSpecifier.tokenKind),
                accessors.contains(.keyword(.get)),
                !accessors.contains(.keyword(.set))
            {
                throw DiagnosticsError(diagnostics: [
                    .init(
                        node: variable,
                        message: DiagnosticMessage.errorPropertyHasNoSetter
                    )
                ])

            } else if
                let accessors = binding.accessorBlock?.accessors,
                accessors.is(CodeBlockItemListSyntax.self)
            {
                throw DiagnosticsError(diagnostics: [
                    .init(
                        node: variable,
                        message: DiagnosticMessage.errorPropertyHasNoSetter
                    )
                ])

            }

            return nil
        }

        return .init(errorPropertyDeclaration)
    }
}

extension VersioningMacro: MemberAttributeMacro {

    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingAttributesFor member: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AttributeSyntax] {

        do {
            let mode = mode(from: declaration)
            let arguments = try parseArguments(
                for: mode,
                from: node,
                on: declaration,
                in: nil
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
                                    leadingNewLine: false
                                )
                            }
                        }
                    )
                ),
                rightParen: hasParameters ? .rightParenToken() : nil
            )

            return [versionedPropertyWrapper]
        } catch {
            return []
        }
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
        leadingNewLine: Bool
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
            )
        )
    }
}
