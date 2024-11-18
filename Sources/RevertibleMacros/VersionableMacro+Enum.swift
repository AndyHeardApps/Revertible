import SwiftSyntax
import SwiftSyntaxMacros
import SwiftDiagnostics

extension VersionableMacro {

    static func enumExtensionSyntax(
        declaration: EnumDeclSyntax,
        type: some TypeSyntaxProtocol
    ) -> [ExtensionDeclSyntax] {

        let accessScopeModifier = declaration.modifiers.first(where: \.isNeededAccessLevelModifier)?.minimumProtocolWitnessVisibilityForAccessModifier

        let enumCases = parseEnumCases(on: declaration)

        let computedAccessors = enumCases.flatMap { enumCase in
            enumCase.associatedValues.map { associatedValue in
                computedProperty(
                    for: associatedValue,
                    on: enumCase
                )
            }
        }

        let appendOverwriteReversionCall = FunctionCallExprSyntax(
            calledExpression: MemberAccessExprSyntax(
                base: DeclReferenceExprSyntax(
                    baseName: .identifier(
                        "reverter"
                    )
                ),
                name: .identifier("appendOverwriteReversion")
            ),
            leftParen: .leftParenToken(),
            arguments: [
                .init(
                    label: "at",
                    expression: KeyPathExprSyntax(
                        components: [
                            KeyPathComponentSyntax(
                                period: .periodToken(),
                                component: .property(
                                    .init(
                                        declName: .init(baseName: .keyword(.self))
                                    )
                                )
                            )
                        ]
                    )
                )
            ],
            rightParen: .rightParenToken()
        )

        let body = CodeBlockSyntax(
            statements: [
                CodeBlockItemSyntax(
                    item: .stmt(
                        .init(
                            guardStatement(
                                conditions: [
                                    .init(
                                        condition: .expression(
                                            .init(
                                                SequenceExprSyntax(
                                                    elements: [
                                                        .init(
                                                            FunctionCallExprSyntax(
                                                                calledExpression: MemberAccessExprSyntax(
                                                                    base: DeclReferenceExprSyntax(baseName: .identifier("reverter")),
                                                                    name: .identifier("hasChanged")
                                                                ),
                                                                leftParen: .leftParenToken(),
                                                                arguments: [
                                                                    .init(
                                                                        label: "at",
                                                                        expression: KeyPathExprSyntax(
                                                                            components: [
                                                                                .init(
                                                                                    period: .periodToken(),
                                                                                    component: .property(
                                                                                        .init(
                                                                                            declName: .init(
                                                                                                baseName: .identifier("caseName")
                                                                                            )
                                                                                        )
                                                                                    )
                                                                                )
                                                                            ]
                                                                        )
                                                                    )
                                                                ],
                                                                rightParen: .rightParenToken()
                                                            )
                                                        ),
                                                        .init(BinaryOperatorExprSyntax(operator: .binaryOperator("=="))),
                                                        .init(BooleanLiteralExprSyntax(literal: .keyword(.false)))
                                                    ]
                                                )
                                            )
                                        )
                                    )
                                ],
                                blockItems: [
                                    .init(
                                        item: .expr(
                                            .init(
                                                appendOverwriteReversionCall
                                            )
                                        )
                                    )
                                ]
                            )
                        )
                    )
                )
            ] +
            enumCases.flatMap { enumCase in
                enumCase.associatedValues.map { associatedValue in
                    CodeBlockItemSyntax(
                        item: .expr(
                            .init(
                                propertyReversionCall(on: associatedValue.uniqueName)
                            )
                        )
                    )
                }
            }
        )

        let extensionSyntax = ExtensionDeclSyntax(
            extendedType: type,
            inheritanceClause: inheritanceClause(syntax: declaration.inheritanceClause),
            memberBlock: .init(
                members: .init(
                    itemsBuilder: {
                        revertFunctionDeclaration(
                            accessScopeModifier: accessScopeModifier,
                            body: body
                        )

                        caseNamesEnum(for: enumCases)
                        caseNameProperty(for: enumCases)
                        computedAccessors
                    }
                )
            )
        )

        return [extensionSyntax]
    }
}

// MARK: - Enum case
extension VersionableMacro {

    struct EnumCase {
        let name: TokenSyntax
        let associatedValues: [AssociatedValue]
    }
}

// MARK: - Enum case child
extension VersionableMacro.EnumCase {

    struct AssociatedValue {
        let name: TokenSyntax?
        let uniqueName: TokenSyntax
        let type: TypeSyntax
    }
}

extension VersionableMacro.EnumCase.AssociatedValue {

    var isOptional: Bool {
        type.is(OptionalTypeSyntax.self)
    }
}

// MARK: - Enum case extraction
extension VersionableMacro {

    private static func parseEnumCases(on declaration: EnumDeclSyntax) -> [EnumCase] {

        let caseDeclarations = declaration.memberBlock.members
            .compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
            .flatMap(\.elements)

        let enumCases = caseDeclarations
            .map { element in
                EnumCase(
                    name: element.name,
                    associatedValues: parseElementAssociatedValues(element: element)
                )
            }

        return enumCases
    }

    private static func parseElementAssociatedValues(element: EnumCaseElementListSyntax.Element) -> [EnumCase.AssociatedValue] {

        guard let parameters = element.parameterClause?.parameters else {
            return []
        }

        return parameters.enumerated().map { (index, parameter) in

            let parameterName: TokenSyntax
            if let name = parameter.firstName?.text {
                parameterName = "\(raw: element.name.text)_\(raw: name)"
            } else {
                parameterName = "\(raw: element.name.text)_$\(raw: index)"
            }

            return .init(
                name: parameter.firstName,
                uniqueName: parameterName,
                type: parameter.type
            )
        }
    }
}

// MARK: - Property accessors
extension VersionableMacro {

    private static func computedProperty(
        for associatedValue: EnumCase.AssociatedValue,
        on enumCase: EnumCase
    ) -> VariableDeclSyntax {

        VariableDeclSyntax(
            leadingTrivia: .newlines(2),
            modifiers: [
                .init(name: .keyword(.private))
            ],
            bindingSpecifier: .keyword(.var),
            bindings: [
                .init(
                    pattern: IdentifierPatternSyntax(identifier: associatedValue.uniqueName),
                    typeAnnotation: associatedValue.isOptional ?
                        .init(type: associatedValue.type) :
                            .init(type: OptionalTypeSyntax(wrappedType: associatedValue.type)),
                    accessorBlock: .init(
                        accessors: .accessors(
                            [
                                .init(
                                    accessorSpecifier: .keyword(.get),
                                    body: .init(
                                        statements: [
                                            .init(
                                                item: .stmt(
                                                    .init(
                                                        guardStatement(
                                                            conditions: [
                                                                .init(
                                                                    condition: .matchingPattern(
                                                                        patternMatch(
                                                                            enumCase: enumCase,
                                                                            associatedValues: [associatedValue]
                                                                        )
                                                                    )
                                                                )
                                                            ],
                                                            return: ReturnStmtSyntax(
                                                                expression: NilLiteralExprSyntax()
                                                            )
                                                        )
                                                    )
                                                )
                                            ),
                                            .init(
                                                item: .stmt(
                                                    .init(
                                                        ReturnStmtSyntax(
                                                            expression: DeclReferenceExprSyntax(
                                                                baseName: associatedValue.uniqueName
                                                            )
                                                        )
                                                    )
                                                )
                                            )
                                        ]
                                    )
                                ),
                                .init(
                                    accessorSpecifier: .keyword(.set),
                                    body: .init(
                                        statements: [
                                            .init(
                                                item: .stmt(
                                                    .init(
                                                        guardStatement(
                                                            conditions: [
                                                                .init(
                                                                    condition: .matchingPattern(
                                                                        patternMatch(
                                                                            enumCase: enumCase,
                                                                            associatedValues: enumCase.associatedValues.filter { $0.uniqueName != associatedValue.uniqueName }
                                                                        )
                                                                    ),
                                                                    trailingComma: .commaToken()
                                                                ),
                                                                .init(
                                                                    condition: .optionalBinding(
                                                                        .init(
                                                                            bindingSpecifier: .keyword(.let),
                                                                            pattern: IdentifierPatternSyntax(identifier: .identifier("newValue"))
                                                                        )
                                                                    )
                                                                )
                                                            ]
                                                        )
                                                    )
                                                )
                                            ),
                                            .init(
                                                item: .expr(
                                                    .init(
                                                        SequenceExprSyntax(
                                                            elements: [
                                                                .init(DeclReferenceExprSyntax(baseName: .keyword(.self))),
                                                                .init(AssignmentExprSyntax()),
                                                                .init(
                                                                    FunctionCallExprSyntax(
                                                                        calledExpression: MemberAccessExprSyntax(
                                                                            period: .periodToken(),
                                                                            name: enumCase.name
                                                                        ),
                                                                        leftParen: .leftParenToken(),
                                                                        arguments: .init(
                                                                            enumCase.associatedValues.enumerated().map { index, value in
                                                                                LabeledExprSyntax(
                                                                                    label: value.name,
                                                                                    colon: value.name == nil ? nil : .colonToken(),
                                                                                    expression: DeclReferenceExprSyntax(baseName: associatedValue.uniqueName == value.uniqueName ? .identifier("newValue") : value.uniqueName),
                                                                                    trailingComma: index == enumCase.associatedValues.count-1 ? nil : .commaToken()
                                                                                )
                                                                            }
                                                                        ),
                                                                        rightParen: .rightParenToken()
                                                                    )
                                                                )
                                                            ]
                                                        )
                                                    )
                                                )
                                            )
                                        ]
                                    )
                                )
                            ]
                        )
                    )
                )
            ]
        )
    }

    private static func guardStatement(
        conditions: [ConditionElementSyntax],
        blockItems: [CodeBlockItemSyntax] = [],
        return returnStatement: ReturnStmtSyntax = .init()
    ) -> GuardStmtSyntax {
        GuardStmtSyntax(
            conditions: .init(conditions),
            body: .init(
                statements: blockItems + [
                    .init(
                        item: .stmt(
                            .init(returnStatement)
                        )
                    )
                ]
            )
        )
    }

    private static func patternMatch(
        enumCase: EnumCase,
        associatedValues boundAssociatedValues: [EnumCase.AssociatedValue]
    ) -> MatchingPatternConditionSyntax {
        if !boundAssociatedValues.isEmpty {
            return MatchingPatternConditionSyntax(
                pattern: ValueBindingPatternSyntax(
                    bindingSpecifier: .keyword(.let),
                    pattern: ExpressionPatternSyntax(
                        expression: FunctionCallExprSyntax(
                            calledExpression: MemberAccessExprSyntax(
                                period: .periodToken(),
                                name: enumCase.name
                            ),
                            leftParen: .leftParenToken(),
                            arguments: .init(
                                enumCase.associatedValues.enumerated()
                                    .map { (index, associatedValue) in
                                        if boundAssociatedValues.map(\.uniqueName).contains(associatedValue.uniqueName) {
                                            LabeledExprSyntax(
                                                expression: PatternExprSyntax(
                                                    pattern: IdentifierPatternSyntax(
                                                        identifier: associatedValue.uniqueName
                                                    )
                                                ),
                                                trailingComma: index == enumCase.associatedValues.count-1 ? nil : .commaToken()
                                            )
                                        } else {
                                            LabeledExprSyntax(
                                                expression: DiscardAssignmentExprSyntax(),
                                                trailingComma: index == enumCase.associatedValues.count-1 ? nil : .commaToken()
                                            )
                                        }
                                    }
                            ),
                            rightParen: .rightParenToken()
                        )
                    )
                ),
                initializer: .init(
                    equal: .equalToken(),
                    value: DeclReferenceExprSyntax(
                        baseName: .keyword(.self)
                    )
                )
            )
        } else {
            return MatchingPatternConditionSyntax(
                pattern: ExpressionPatternSyntax(
                    expression: MemberAccessExprSyntax(
                        period: .periodToken(),
                        name: enumCase.name
                    )
                ),
                initializer: .init(
                    equal: .equalToken(),
                    value: DeclReferenceExprSyntax(
                        baseName: .keyword(.self)
                    )
                )
            )
        }
    }
}

// MARK: - Case name
extension VersionableMacro {

    private static func caseNamesEnum(for enumCases: [EnumCase]) -> EnumDeclSyntax {
        .init(
            leadingTrivia: .newline,
            modifiers: [
                .init(name: .keyword(.private))
            ],
            name: .identifier("CaseName"),
            memberBlock: .init(
                members: .init(
                    enumCases.map {
                        .init(decl: EnumCaseDeclSyntax(elements: [.init(name: $0.name)]))
                    }
                )
            )
        )
    }

    private static func caseNameProperty(for enumCases: [EnumCase]) -> VariableDeclSyntax {
        .init(
            leadingTrivia: .newlines(2),
            modifiers: [
                .init(name: .keyword(.private))
            ],
            bindingSpecifier: .keyword(.var),
            bindings: [
                .init(
                    pattern: IdentifierPatternSyntax(identifier: .identifier("caseName")),
                    typeAnnotation: .init(type: IdentifierTypeSyntax(name: .identifier("CaseName"))),
                    accessorBlock: .init(
                        accessors: .getter(
                            [
                                .init(
                                    item: .expr(
                                        .init(
                                            SwitchExprSyntax(
                                                subject: DeclReferenceExprSyntax(baseName: .keyword(.self)),
                                                cases: .init(
                                                    enumCases.map {
                                                        .switchCase(
                                                            SwitchCaseSyntax(
                                                                label: .case(
                                                                    .init(
                                                                        caseItems: [
                                                                            .init(
                                                                                pattern: ExpressionPatternSyntax(
                                                                                    expression: MemberAccessExprSyntax(
                                                                                        name: $0.name
                                                                                    )
                                                                                )
                                                                            )
                                                                        ]
                                                                    )
                                                                ),
                                                                statements: [
                                                                    .init(item: .expr(.init(MemberAccessExprSyntax(name: $0.name))))
                                                                ]
                                                            )
                                                        )
                                                    }
                                                )
                                            )
                                        )
                                    )
                                )
                            ]
                        )
                    )
                )
            ]
        )
    }
}
