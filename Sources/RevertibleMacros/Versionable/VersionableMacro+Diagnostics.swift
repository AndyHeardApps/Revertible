import SwiftDiagnostics

extension VersionableMacro {
    enum DiagnosticMessage {

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
