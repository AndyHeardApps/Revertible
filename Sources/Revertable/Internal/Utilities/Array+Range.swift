
extension Array where Element: BinaryInteger {
    
    func convertToRanges() -> [ClosedRange<Element>] {
        
        var ranges: [ClosedRange<Element>] = []
        var range: ClosedRange<Element>?
        
        for element in self {
            if let currentRange = range {
                switch element {
                case currentRange.lowerBound-1:
                    range = element...currentRange.upperBound
                    
                case currentRange.upperBound+1:
                    range = currentRange.lowerBound...element
                    
                default:
                    ranges.append(currentRange)
                    range = element...element
                    
                }
            } else {
                range = element...element
            }
        }
        
        if let currentRange = range {
            ranges.append(currentRange)
        }
        
        return ranges
    }
}
