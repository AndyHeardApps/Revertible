struct ChangeRestorationCollection<Root> {
    
    // MARK: - Properties
    private let restorations: [any ChangeRestoration<Root>]
    
    // MARK: - Initialiser
    init<C: Collection<any ChangeRestoration<Root>>>(_ restorations: C) {
        
        self.restorations = Array(restorations)
    }
}

// MARK: - Change restoration
extension ChangeRestorationCollection: ChangeRestoration {
    
    func restore(_ object: inout Root) {
        
        for restoration in restorations {
            restoration.restore(&object)
        }
    }
    
    func mapped<NewRoot>(to keyPath: WritableKeyPath<NewRoot, Root>) -> any ChangeRestoration<NewRoot> {
        
        let mappedRestorations = restorations
            .map { $0.mapped(to: keyPath) }
        
        return ChangeRestorationCollection<NewRoot>(mappedRestorations)
    }
}

