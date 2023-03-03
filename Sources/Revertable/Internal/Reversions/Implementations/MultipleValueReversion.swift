
struct MultipleValueReversion<Root> {

    // MARK: - Properties
    private let reversions: [AnyValueReversion<Root>]
    
    // MARK: - Initialiser
    init<C: Collection<AnyValueReversion<Root>>>(_ reversions: C) {
        
        self.reversions = Array(reversions)
    }
}

// MARK: - Value reversion
extension MultipleValueReversion: ValueReversion {
        
    func revert(_ object: inout Root) {

        for reversion in reversions {
            reversion.revert(&object)
        }
    }

    func mapped<NewRoot>(to keyPath: WritableKeyPath<NewRoot, Root>) -> AnyValueReversion<NewRoot> {

        MultipleValueReversion<NewRoot>(reversions.mapped(to: keyPath))
            .erasedToAnyValueReversion()
    }
}
