
struct AnyHashableSendable: @unchecked Sendable, Hashable {

    // MARK: - Properties
    private let wrapped: AnyHashable

    // MARK: - Initializer
    init(wrapped: some Hashable & Sendable) {
        self.wrapped = .init(wrapped)
    }
}
