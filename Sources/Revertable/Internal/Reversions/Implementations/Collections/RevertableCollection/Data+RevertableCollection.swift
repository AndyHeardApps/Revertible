import Foundation

extension Data: RevertableCollection {
    
    func collectionReversions(to previousValue: Self) -> [DataReversion<Self>] {
     
        var reversions: [DataReversion<Self>] = []

        guard self != previousValue else {
            return reversions
        }
        
        let difference = self.difference(from: previousValue)
        
        var elementsToInsert: [(Int, Element)] = []
        var indicesToRemove: [Int] = []
        
        for change in difference.reversed() {
            switch change {
            case let .remove(offset, element, _):
                elementsToInsert.append((offset, element))
                
            case let .insert(offset, _, _):
                indicesToRemove.append(offset)
                
            }
        }

        if !indicesToRemove.isEmpty {
            let rangesToRemove = indicesToRemove.convertToRanges()
            let reversion = DataReversion(remove: Set(rangesToRemove))

            reversions.append(reversion)
        }
        
        if !elementsToInsert.isEmpty {
            let insertionDictionary = Dictionary(uniqueKeysWithValues: elementsToInsert)
            let rangesToInsert = elementsToInsert.map(\.0).convertToRanges()

            let insertions = rangesToInsert.map { range in
                let elements = range.compactMap { insertionDictionary[$0] }
                
                return DataReversion<Self>.Insertion(
                    index: range.lowerBound,
                    elements: SubSequence(elements)
                )
            }
            let reversion = DataReversion(insert: Set(insertions))
            
            reversions.append(reversion)
        }
        
        return reversions
    }
}
