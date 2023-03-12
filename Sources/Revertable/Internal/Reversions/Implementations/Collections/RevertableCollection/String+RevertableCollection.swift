
extension String: RevertableCollection {
    
    func reversions(to previousValue: String) -> [StringReversion<String>] {
        
        guard self != previousValue else {
            return []
        }
        
        let difference = self.difference(from: previousValue)
        
        var elementsToInsert: [(Int, String.Element)] = []
        var indicesToRemove: [Int] = []
        
        for change in difference.reversed() {
            switch change {
            case let .remove(offset, element, _):
                elementsToInsert.append((offset, element))
                
            case let .insert(offset, _, _):
                indicesToRemove.append(offset)
                
            }
        }
        
        var reversions: [StringReversion<String>] = []
        
        if !indicesToRemove.isEmpty {
            let rangesToRemove = indicesToRemove.convertToRanges()
            let stringIndices = rangesToRemove
                .map { range in
                    let lowerBound = self.index(self.startIndex, offsetBy: range.lowerBound)
                    let upperBound = self.index(self.startIndex, offsetBy: range.upperBound)
                    return lowerBound...upperBound
                }
            
            let reversion = StringReversion(remove: Set(stringIndices))

            reversions.append(reversion)
        }

        if !elementsToInsert.isEmpty {
            
            let insertionDictionary = Dictionary(uniqueKeysWithValues: elementsToInsert)
            let rangesToInsert = elementsToInsert.map(\.0).convertToRanges()
            let insertions = rangesToInsert.map { range in
                let elements = range.compactMap { insertionDictionary[$0] }
                let startIndex = previousValue.index(previousValue.startIndex, offsetBy: range.lowerBound)
                
                return StringReversion<String>.Insertion(
                    index: startIndex,
                    elements: Substring(elements)
                )
            }
            let reversion = StringReversion(insert: Set(insertions))

            reversions.append(reversion)
        }
        
        return reversions
    }
}
