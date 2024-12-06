import Foundation

extension Activity: CustomStringConvertible {

    init(_ seed: inout Seed, level: UInt = 0) {
        self.id = .init(integerLiteral: Int(seed()))
        self.title = "Activity \(seed())"
        self.priority = .init(&seed)
        let childSeed = seed() % 4
        let childCount = UInt(max(Int(childSeed) - Int(level), 0))
        self.childActivities = (0..<childCount).map { _ in Activity(&seed, level: level+1) }
    }

    static func mock(count: UInt) -> [Activity] {
        var seed = Seed()
        return (0..<count).map { _ in Activity(&seed) }
    }

    static var mock: Activity {
        var seed = Seed()
        return Activity(&seed)
    }

    private func nestedDescription(_ level: Int) -> String {
        [
            "ID - \(id.uuidString)",
            "Title - \(title)",
            "Priority - \(priority.nestedDescription(level))",
            "Child activities - \(childActivities.count)",
            "\n" + childActivities.map { $0.nestedDescription(level+1) }.joined(separator: "\n")
        ]
        .map { $0.indented(level) }
        .joined(separator: "\n")
    }

    var description: String {
        nestedDescription(0)
    }
}

extension Activity.Priority {

    init(_ seed: inout Seed) {

        switch seed().quotientAndRemainder(dividingBy: 10).remainder {
        case 1, 5:
            self = .low
        case 2, 6:
            self = .medium(dueDate: nil)
        case 3, 7:
            self = .medium(dueDate: Date(timeIntervalSinceReferenceDate: .init(seed()*1000)))
        default:
            self = .high(
                dueDate: Date(timeIntervalSinceReferenceDate: .init(seed()*1050)),
                reason: "Some reason no. \(seed())"
            )
        }
    }

    fileprivate func nestedDescription(_ level: Int) -> String {
        switch self {
        case .low:
            "Low"

        case .medium(nil):
            "Medium"

        case let .medium(dueDate?):
            [
                "Medium:",
                "Due - \(dueDate.formatted(date: .abbreviated, time: .shortened))".indented(level+1)
            ]
            .joined(separator: "\n")

        case let .high(dueDate, reason):
            [
                "High:",
                "Due - \(dueDate.formatted(date: .abbreviated, time: .shortened))".indented(level+1),
                "Reason - \(reason)".indented(level+1)
            ]
            .joined(separator: "\n")

        }
    }
}

extension String {
    func indented(_ count: Int) -> String {
        String(repeating: "\t", count: count) + self
    }
}

extension Array where Element == Activity {

    var dump: String {
        map(\.description).joined(separator: "\n")
    }
}

struct Seed {

    private var value: UInt = 0

    mutating func callAsFunction() -> UInt {
        defer { value += 1 }
        return value
    }
}

extension UUID: @retroactive ExpressibleByIntegerLiteral {

    public init(integerLiteral value: IntegerLiteralType) {
        self.init(uuidString: "00000000-0000-0000-0000-\(String(format: "%012x", value))")!
    }
}
