struct SingleChangeRestoration<Root, Value> {
    
    // MARK: - Properties
    private let restoration: (inout Root, WritableKeyPath<Root, Value>) -> Void
    private let keyPath: WritableKeyPath<Root, Value>
    
    // MARK: - Initialisers
    private init(
        restoration: @escaping (inout Root, WritableKeyPath<Root, Value>) -> Void,
        keyPath: WritableKeyPath<Root, Value>
    ) {
        
        self.restoration = restoration
        self.keyPath = keyPath
    }
    
    init(value: Value) where Root == Value {
        
        self.restoration = OverwritingKeyPathRestoration(value: value).apply
        self.keyPath = \.self
    }
}

// MARK: Restorable collection
extension SingleChangeRestoration where Value: RestorableCollection {
    
    init(insert elements: Value.InsertedElements) where Root == Value {
        
        self.restoration = CollectionInsertionKeyPathRestoration(elements: elements).apply
        self.keyPath = \.self
    }
    
    init(remove elements: Value.RemovedElements) where Root == Value {
        
        self.restoration = CollectionRemovalKeyPathRestoration(elements: elements).apply
        self.keyPath = \.self
    }
}

// MARK: Restorable ordered collection
extension SingleChangeRestoration where Value: RestorableOrderedCollection {
    
    init(move element: Value.MovedElement) where Root == Value {
        
        self.restoration = OrderedCollectionMoveKeyPathRestoration(element: element).apply
        self.keyPath = \.self
    }
}

// MARK: - Change restoration
extension SingleChangeRestoration: ChangeRestoration {

    func restore(_ object: inout Root) {
        
        restoration(&object, keyPath)
    }
    
    func mapped<NewRoot>(to keyPath: WritableKeyPath<NewRoot, Root>) -> any ChangeRestoration<NewRoot> {
     
        let newKeyPath = keyPath.appending(path: self.keyPath)
        let newRestoration: (inout NewRoot, WritableKeyPath<NewRoot, Value>) -> Void = { object, newKeyPath in
            restoration(&object[keyPath: keyPath], self.keyPath)
        }
        
        return SingleChangeRestoration<NewRoot, Value>(
            restoration: newRestoration,
            keyPath: newKeyPath
        )
    }
}

// MARK: - Key path restoration
fileprivate protocol KeyPathRestoration<Value> {
    
    // MARK: Associated type
    associatedtype Value
    
    // MARK: Functions
    func apply<Root>(to object: inout Root, at keyPath: WritableKeyPath<Root, Value>)
}

// MARK: - Overwriting
fileprivate struct OverwritingKeyPathRestoration<Value>: KeyPathRestoration {
    
    // MARK: Properties
    private let value: Value
    
    // MARK: Initialiser
    init(value: Value) {
        
        self.value = value
    }
    
    // MARK: Functions
    func apply<Root>(to object: inout Root, at keyPath: WritableKeyPath<Root, Value>) {
        object[keyPath: keyPath] = value
    }
}

// MARK: - Collections
fileprivate struct CollectionInsertionKeyPathRestoration<Value: RestorableCollection>: KeyPathRestoration {
    
    // MARK: Properties
    private let elements: Value.InsertedElements
    
    // MARK: Initialiser
    init(elements: Value.InsertedElements) {
        
        self.elements = elements
    }
    
    // MARK: Functions
    func apply<Root>(to object: inout Root, at keyPath: WritableKeyPath<Root, Value>) {
        
        object[keyPath: keyPath].performInsertRestoration(insertions: elements)
    }
}

fileprivate struct CollectionRemovalKeyPathRestoration<Value: RestorableCollection>: KeyPathRestoration {
    
    // MARK: Properties
    private let elements: Value.RemovedElements
    
    // MARK: Initialiser
    init(elements: Value.RemovedElements) {
        
        self.elements = elements
    }
    
    // MARK: Functions
    func apply<Root>(to object: inout Root, at keyPath: WritableKeyPath<Root, Value>) {
        
        object[keyPath: keyPath].performRemoveRestoration(removals: elements)
    }
}

fileprivate struct OrderedCollectionMoveKeyPathRestoration<Value: RestorableOrderedCollection>: KeyPathRestoration {
    
    // MARK: Properties
    private let element: Value.MovedElement
    
    // MARK: Initialiser
    init(element: Value.MovedElement) {
        
        self.element = element
    }
    
    // MARK: Functions
    func apply<Root>(to object: inout Root, at keyPath: WritableKeyPath<Root, Value>) {
        
        object[keyPath: keyPath].performMoveRestoration(move: element)
    }
}
