
struct UnorderedCollectionValueRevertable<Element: Hashable> {
    
    
}

extension UnorderedCollectionValueRevertable: ValueReversion {
    
    func revert(_ object: inout Set<Element>) {
        
    }
}
