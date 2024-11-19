
struct AnyHashableSendable: @unchecked Sendable, Hashable {

    // MARK: - Properties
    let wrapped: AnyHashable

    // MARK: - Initializer
    init(wrapped: some Hashable & Sendable) {
        self.wrapped = .init(wrapped)
    }
}
