
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
            let stringIndices = indicesToRemove
                .map { index in
                    self.index(self.startIndex, offsetBy: index)
                }
            
            let reversion = StringReversion(remove: Set(stringIndices))

            reversions.append(reversion)
        }
        
        if !elementsToInsert.isEmpty {
            let insertions = elementsToInsert.map { index, element in
                let startIndex = previousValue.index(previousValue.startIndex, offsetBy: index)
                
                return StringReversion<String>.Insertion(
                    index: startIndex,
                    element: element
                )
            }
            
            let reversion = StringReversion(insert: Set(insertions))

            reversions.append(reversion)
        }
        
        return reversions
    }
}
