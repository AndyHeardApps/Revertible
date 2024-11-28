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

        let arguments = parseArguments(
            from: node,
            on: declaration,
            in: context
        )

        return arguments.properties.map {
            .init(
                versioningControllerDeclaration(
                    for: $0,
                    withMode: mode
                )
            )
        }
    }

    private static func versioningControllerDeclaration(for property: Property, withMode mode: Mode) -> VariableDeclSyntax {
        .init(
            attributes: .init(
                itemsBuilder: {
                    if mode == .observable {
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
                                        trailingComma: mode == .observable ? .commaToken() : nil
                                    )
                                    if mode == .observable {
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
}

extension VersioningMacro: MemberAttributeMacro {

    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingAttributesFor member: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AttributeSyntax] {

        let mode = mode(from: declaration)
        let arguments = parseArguments(
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
            attributeName: IdentifierTypeSyntax(name: arguments.internalizesErrors ? "Versioned" : "ThrowingVersioned"),
            leftParen: hasParameters ? .leftParenToken() : nil,
            arguments: .argumentList(
                .init(
                    itemsBuilder: {
                        if let debounceInterval = arguments.debounceInterval {
                            LabeledExprSyntax(
                                label: "debounceInterval",
                                expression: FunctionCallExprSyntax(
                                    calledExpression: MemberAccessExprSyntax(
                                        period: .periodToken(),
                                        name: .identifier("milliseconds")
                                    ),
                                    leftParen: .leftParenToken(),
                                    arguments: [
                                        .init(
                                            expression: IntegerLiteralExprSyntax(
                                                literal: .integerLiteral(debounceInterval.description)
                                            )
                                        )
                                    ],
                                    rightParen: .rightParenToken()
                                )
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

    private enum Mode {
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

// MARK: - Arguments
extension VersioningMacro {

    private struct Arguments {
        let properties: [Property]
        let internalizesErrors: Bool
        let debounceInterval: UInt?

        init(
            properties: [Property] = [],
            internalizesErrors: Bool = true,
            debounceInterval: UInt? = nil
        ) {
            self.properties = properties
            self.internalizesErrors = internalizesErrors
            self.debounceInterval = debounceInterval
        }
    }

    private static func parseArguments(
        from node: AttributeSyntax,
        on declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) -> Arguments {

        let declaredProperties = declaredProperties(in: declaration)
        guard let arguments = node.arguments?.as(LabeledExprListSyntax.self) else {
            let defaultProperties = declaredProperties
                .filter {
                    [.basicVar, .computedGetterSetter].contains($0.declarationType)
                }
            return .init(properties: defaultProperties)
        }

        let targetProperties = arguments
            .filter { $0.label == nil }
            .compactMap { $0.expression.as(StringLiteralExprSyntax.self)?.representedLiteralValue }

        let generatedProperties = targetProperties.isEmpty ? declaredProperties.map(\.name) : targetProperties

        // Validate properties
        var properties: [Property] = []
        for generatedProperty in Set(generatedProperties) {
            guard let property = declaredProperties.first(where: { $0.name == generatedProperty }) else {
                context.diagnose(
                    .init(
                        node: node,
                        message: DiagnosticMessage.propertyNotFound(generatedProperty)
                    )
                )
                continue
            }

            let diagnosticMessage: DiagnosticMessage? = switch property.declarationType {
            case .static:
                .propertyIsStatic(generatedProperty)
            case .let:
                .propertyIsLetDeclaration(generatedProperty)
            case .computedGetter:
                .propertyIsAComputedGetter(generatedProperty)
            default:
                nil
            }

            if let diagnosticMessage {
                context.diagnose(
                    .init(
                        node: node,
                        message: diagnosticMessage
                    )
                )
            }

            properties.append(property)
        }

        // Error mode
        let internalizesErrors: Bool
        if let argument = arguments.first(where: { $0.label?.text == "internalizesErrors" }) {
            if let booleanDeclaration = argument.expression.as(BooleanLiteralExprSyntax.self) {
                internalizesErrors = booleanDeclaration.literal.text == "true"
            } else {
                internalizesErrors = true
                context.diagnose(
                    .init(
                        node: node,
                        message: DiagnosticMessage.errorHandlingParameterIsNotBooleanLiteral
                    )
                )
            }
        } else {
            internalizesErrors = true
        }

        // Debounce interval
        let debounceInterval: UInt?
        if let argument = arguments.first(where: { $0.label?.text == "debounceMilliseconds" }) {
            if
                let integerDeclaration = argument.expression.as(IntegerLiteralExprSyntax.self),
                let value = UInt(integerDeclaration.literal.text),
                value > .zero
            {
                debounceInterval = value
            } else {
                debounceInterval = nil
                context.diagnose(
                    .init(
                        node: node,
                        message: DiagnosticMessage.debounceIntervalParameterIsNotIntegerLiteral
                    )
                )
            }
        } else {
            debounceInterval = nil
        }

        return .init(
            properties: properties,
            internalizesErrors: internalizesErrors,
            debounceInterval: debounceInterval
        )
    }

    private static func declaredProperties(in declaration: some DeclGroupSyntax) -> [Property] {

        declaration.memberBlock.members
            .compactMap { $0.decl.as(VariableDeclSyntax.self) }
            .flatMap { variable in
                variable.bindings.compactMap { binding in
                    Property(declaration: variable, binding: binding)
                }
            }
    }
}

extension VersioningMacro {

    fileprivate struct Property {

        // Properties
        let identifier: IdentifierPatternSyntax
        let declarationType: DeclarationType
        let containsVersionedAttribute: Bool
        let accessScopeModifier: DeclModifierSyntax?
        var name: String {
            identifier.identifier.text
        }

        // Initializer
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

extension VersioningMacro.Property {
    enum DeclarationType {
        case `static`
        case `let`
        case basicVar
        case computedGetter
        case computedGetterSetter
    }
}

// MARK: - Diagnostic message
extension VersioningMacro {
    fileprivate enum DiagnosticMessage {

        case propertyNotFound(String)
        case propertyIsStatic(String)
        case propertyIsLetDeclaration(String)
        case propertyIsAComputedGetter(String)
        case errorHandlingParameterIsNotBooleanLiteral
        case debounceIntervalParameterIsNotIntegerLiteral
    }
}

extension VersioningMacro.DiagnosticMessage: SwiftDiagnostics.DiagnosticMessage {

    var message: String {

        switch self {
        case let .propertyNotFound(name):
            "Property \"\(name)\" not found and will be ignored."

        case let .propertyIsStatic(name):
            "Property \"\(name)\" is \"static\" and will be ignored."

        case let .propertyIsLetDeclaration(name):
            "Property \"\(name)\" is a \"let\" declaration and will be ignored. Properties must be mutable to be used with \"@Versioning\"."

        case let .propertyIsAComputedGetter(name):
            "Property \"\(name)\" has no setter and will be ignored. Properties must be mutable to be used with \"@Versioning\"."

        case .errorHandlingParameterIsNotBooleanLiteral:
            "Parameter must be a Bool literal (true|false)."

        case .debounceIntervalParameterIsNotIntegerLiteral:
            "Parameter must be a positive Integer literal"

        }
    }

    private var messageID: String {

        switch self {
        case .propertyNotFound:
            "propertyNotFound"
        case .propertyIsStatic:
            "propertyIsStatic"
        case .propertyIsLetDeclaration:
            "propertyIsLetDeclaration"
        case .propertyIsAComputedGetter:
            "propertyIsAComputedGetter"
        case .errorHandlingParameterIsNotBooleanLiteral:
            "errorHandlingParameterIsNotBooleanLiteral"
        case .debounceIntervalParameterIsNotIntegerLiteral:
            "debounceIntervalParameterIsNotIntegerLiteral"
        }
    }

    var diagnosticID: MessageID {

        .init(
            domain: "VersioningMacro",
            id: messageID
        )
    }

    var severity: DiagnosticSeverity {

        switch self {
        case .propertyNotFound:
            .warning
        case .propertyIsStatic:
            .warning
        case .propertyIsLetDeclaration:
            .warning
        case .propertyIsAComputedGetter:
            .warning
        case .errorHandlingParameterIsNotBooleanLiteral:
            .error
        case .debounceIntervalParameterIsNotIntegerLiteral:
            .error
        }
    }
}
