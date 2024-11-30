import SwiftSyntax
import SwiftSyntaxMacros
import SwiftDiagnostics

extension VersioningMacro {
    
    static func parseArguments(
        for macroMode: Mode,
        from node: AttributeSyntax,
        on declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> Arguments {
        
        let declaredProperties = declaredProperties(in: declaration)
        guard let arguments = node.arguments?.as(LabeledExprListSyntax.self) else {
            let defaultProperties = declaredProperties
                .filter {
                    [.basicVar, .computedGetterSetter].contains($0.declarationType)
                }
            return .init(properties: defaultProperties)
        }
        
        let properties = properties(
            from: node,
            on: declaration,
            with: arguments,
            in: context
        )
                
        let errorMode = try errorMode(
            for: macroMode,
            from: node,
            with: arguments,
            in: context
        )
        
        let debounceInterval = try debounceInterval(
            from: node,
            with: arguments,
            in: context
        )
        
        return .init(
            properties: properties,
            errorMode: errorMode,
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

// MARK: - Properties
extension VersioningMacro {
    private static func properties(
        from node: AttributeSyntax,
        on declaration: some DeclGroupSyntax,
        with arguments: LabeledExprListSyntax,
        in context: some MacroExpansionContext
    ) -> [Property] {
        
        let declaredProperties = declaredProperties(in: declaration)
        
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

        return properties
    }
}

// MARK: - Error mode
extension VersioningMacro {
    
    private static func errorMode(
        for macroMode: Mode,
        from node: AttributeSyntax,
        with arguments: LabeledExprListSyntax,
        in context: some MacroExpansionContext
    ) throws -> Arguments.ErrorMode {
        
        guard let argument = arguments.first(where: { $0.label?.text == "errorMode" }) else {
            return .default
        }
        
        let modeName: String
        let errorPropertyName: String?
        if
            let functionDeclaration = argument.expression.as(FunctionCallExprSyntax.self),
            let memberDeclaration = functionDeclaration.calledExpression.as(MemberAccessExprSyntax.self)
        {
            modeName = memberDeclaration.declName.baseName.text
            errorPropertyName = functionDeclaration.arguments.first?
                .expression.as(StringLiteralExprSyntax.self)?
                .representedLiteralValue
            
        } else if let memberDeclaration = argument.expression.as(MemberAccessExprSyntax.self) {
            modeName = memberDeclaration.declName.baseName.text
            errorPropertyName = nil
        } else {
            throw DiagnosticsError(diagnostics: [
                .init(
                    node: node,
                    message: DiagnosticMessage.invalidErrorModeExpression
                )
            ])
        }
        
        let errorMode: Arguments.ErrorMode
        switch modeName {
        case "throwErrors":
            errorMode = .throwErrors
            
        case "assignErrors":
            if let errorPropertyName {
                guard !errorPropertyName.isEmpty else {
                    throw DiagnosticsError(diagnostics: [
                        .init(
                            node: node,
                            message: DiagnosticMessage.emptyErrorPropertyName
                        )
                    ])
                }
                
                if macroMode == .default {
                    context.diagnose(
                        .init(
                            node: node,
                            message: DiagnosticMessage.unusedErrorPropertyName
                        )
                    )
                }
                
                errorMode = .assignErrors(errorPropertyName)
                
            } else {
                errorMode = .assignErrors("versioningError")
                
            }
            
        default:
            throw DiagnosticsError(diagnostics: [
                .init(
                    node: node,
                    message: DiagnosticMessage.invalidErrorModeExpression
                )
            ])

        }
        
        return errorMode
    }
}

// MARK: - Debounce interval
extension VersioningMacro {
    
    private static func debounceInterval(
        from node: AttributeSyntax,
        with arguments: LabeledExprListSyntax,
        in context: some MacroExpansionContext
    ) throws -> UInt? {
        
        guard let argument = arguments.first(where: { $0.label?.text == "debounceMilliseconds" }) else {
            return nil
        }
        
        guard
            let integerDeclaration = argument.expression.as(IntegerLiteralExprSyntax.self),
            let value = UInt(integerDeclaration.literal.text),
            value > .zero
        else {
            throw DiagnosticsError(diagnostics: [
                .init(
                    node: node,
                    message: DiagnosticMessage.debounceIntervalParameterIsNotIntegerLiteral
                )
            ])
        }
        
        return value
    }
}

// MARK: - Arguments
extension VersioningMacro {
    struct Arguments {
        
        // MARK: - Properties
        let properties: [Property]
        let errorMode: ErrorMode
        let debounceInterval: UInt?
        
        // MARK: - Initializer
        init(
            properties: [Property] = [],
            errorMode: ErrorMode = .default,
            debounceInterval: UInt? = nil
        ) {
            self.properties = properties
            self.errorMode = errorMode
            self.debounceInterval = debounceInterval
        }
        
        enum ErrorMode: Equatable {
            
            fileprivate static let `default` = assignErrors("versioningError")
            
            case throwErrors
            case assignErrors(String)
        }
    }
}
