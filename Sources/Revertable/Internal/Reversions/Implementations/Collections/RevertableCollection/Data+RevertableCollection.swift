import Foundation

extension Data: RevertableCollection {
    
    func reversions(to previousValue: Data) -> [DataReversion<Data>] {
     
        guard self != previousValue else {
            return []
        }
        
        let difference = self.difference(from: previousValue)
        
        var elementsToInsert: [(Int, Data.Element)] = []
        var indicesToRemove: [Int] = []
        
        for change in difference.reversed() {
            switch change {
            case let .remove(offset, element, _):
                elementsToInsert.append((offset, element))
                
            case let .insert(offset, _, _):
                indicesToRemove.append(offset)
                
            }
        }
        
        var reversions: [DataReversion<Data>] = []

        if !indicesToRemove.isEmpty {
            
            let reversion = DataReversion(remove: Set(indicesToRemove))
            
            reversions.append(reversion)
        }
        
        if !elementsToInsert.isEmpty {
            let insertions = elementsToInsert.map { index, element in
                
                return DataReversion<Data>.Insertion(
                    index: index,
                    element: element
                )
            }
            
            let reversion = DataReversion(insert: Set(insertions))
            
            reversions.append(reversion)
        }
        
        return reversions
    }
}
