import SwiftDiagnostics

extension VersioningMacro {
    enum DiagnosticMessage {

        case propertyNotFound(String)
        case propertyIsStatic(String)
        case propertyIsLetDeclaration(String)
        case propertyIsAComputedGetter(String)
        case invalidErrorModeExpression
        case emptyErrorPropertyName
        case unusedErrorPropertyName
        case errorPropertyIsStatic
        case errorPropertyIsWrongType
        case errorPropertyIsNotVariable
        case errorPropertyHasNoSetter
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
       
        case .invalidErrorModeExpression:
            "Invalid error mode declaration. The error mode must be declared in the macro itself and not assigned to a variable elsewhere."
            
        case .emptyErrorPropertyName:
            "Error property name cannot be empty."
            
        case .unusedErrorPropertyName:
            "Error property name will not be used. The macro is using \"@Versioned\" property wrappers which stores errors internally when the error mode is set to \".assignErrors\"."

        case .errorPropertyIsStatic:
            "Declared error property is marked as \"static\" and will be ignored."

        case .errorPropertyIsWrongType:
            "Declared error property must be of type \"Error?\" or \"(any Error)?\"."

        case .errorPropertyIsNotVariable:
            "Declared error property must be declared as a \"var\"."

        case .errorPropertyHasNoSetter:
            "Declared error property must have an accessible getter and setter."

        case .debounceIntervalParameterIsNotIntegerLiteral:
            "Parameter must be a positive Integer literal."

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
        case .invalidErrorModeExpression:
            "invalidErrorModeExpression"
        case .emptyErrorPropertyName:
            "emptyErrorPropertyName"
        case .unusedErrorPropertyName:
            "unusedErrorPropertyName"
        case .errorPropertyIsStatic:
            "errorPropertyIsStatic"
        case .errorPropertyIsWrongType:
            "errorPropertyIsWrongType"
        case .errorPropertyIsNotVariable:
            "errorPropertyIsNotVariable"
        case .errorPropertyHasNoSetter:
            "errorPropertyHasNoSetter"
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
        case .invalidErrorModeExpression:
            .error
        case .emptyErrorPropertyName:
            .error
        case .unusedErrorPropertyName:
            .warning
        case .errorPropertyIsStatic:
            .warning
        case .errorPropertyIsWrongType:
            .error
        case .errorPropertyIsNotVariable:
            .error
        case .errorPropertyHasNoSetter:
            .error
        case .debounceIntervalParameterIsNotIntegerLiteral:
            .error
        }
    }
}

