
extension Set: RevertableCollection {
    
    func collectionReversions(to previousValue: Self) -> [SetReversion<Self, Element>] {
        
        var reversions: [SetReversion<Self, Element>] = []

        guard self != previousValue else {
            return reversions
        }
        
        let elementsToRemove = self.subtracting(previousValue)
        let elementsToInsert = previousValue.subtracting(self)

        if !elementsToRemove.isEmpty {
            let reversion = SetReversion(remove: elementsToRemove)
            reversions.append(reversion)
        }
        
        if !elementsToInsert.isEmpty {
            let reversion = SetReversion(insert: elementsToInsert)
            reversions.append(reversion)
        }
        
        return reversions
    }
}
