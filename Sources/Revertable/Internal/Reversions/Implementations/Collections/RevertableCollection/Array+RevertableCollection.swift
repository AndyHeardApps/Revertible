
extension Array: RevertableCollection where Element: Equatable {
    
    func collectionReversions(to previousValue: Self) -> [ArrayReversion<Self, Element>] {
        
        var reversions: [ArrayReversion<Self, Element>] = []
        
        guard self != previousValue else {
            return reversions
        }
        
        let difference = self.difference(from: previousValue)
        
        var indicesToRemove: Set<Index> = []
        var elementsToInsert: Set<ArrayReversion<Self, Element>.Insertion> = []
        
        for change in difference {
            switch change {
            case let .insert(offset, _, _):
                indicesToRemove.insert(offset)
                
            case let .remove(offset, element, _):
                elementsToInsert.insert(.init(index: offset, element: element))
                
            }
        }
        
        if !indicesToRemove.isEmpty {
            let reversion = ArrayReversion<Self, Element>(remove: indicesToRemove)
            reversions.append(reversion)
        }
        
        if !elementsToInsert.isEmpty {
            let reversion = ArrayReversion(insert: elementsToInsert)
            reversions.append(reversion)
        }
        
        return reversions
    }
}
