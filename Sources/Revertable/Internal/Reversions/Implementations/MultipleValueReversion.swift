
struct MultipleValueReversion<Root> {

    // MARK: - Properties
    private let reversions: [any ValueReversion<Root>]
    
    // MARK: - Initialiser
    init<C: Collection<any ValueReversion<Root>>>(_ reversions: C) {
        
        self.reversions = Array(reversions)
    }
}

// MARK: - Value reversion
//extension MultipleValueReversion: ValueReversion {
//
//    func revert(_ object: inout Root) {
//
//        for reversion in reversions {
//            reversion.revert(&object)
//        }
//    }
//
//    func mapped<NewRoot>(to keyPath: WritableKeyPath<NewRoot, Root>) -> MultipleValueReversion<NewRoot> {
//
//        let mappedReversions = reversions.mapped
//        MultipleValueReversion(reversions.mapped)
//        SingleValueReversion<NewRoot, Value>(
//            keyPath: keyPath.appending(path: self.keyPath),
//            value: value
//        )
//    }
//}
