
struct AnyValueReversion<Root> {
    
    // MARK: - Properties
    private let wrapped: any ValueReversion<Root>
    
    // MARK: - Initialiser
    fileprivate init(_ reversion: some ValueReversion<Root>) {
        
        self.wrapped = reversion
    }
}

// MARK: - Value reversion
extension AnyValueReversion: ValueReversion {
    
    func revert(_ object: inout Root) {
        
        wrapped.revert(&object)
    }
    
    func mapped<NewRoot>(to keyPath: WritableKeyPath<NewRoot, Root>) -> AnyValueReversion<NewRoot> {
        
        wrapped.mapped(to: keyPath)
    }
}

// MARK: - Value reversion extension
extension ValueReversion {
    
    func erasedToAnyValueReversion() -> AnyValueReversion<Root> {
        
        .init(self)
    }
}
