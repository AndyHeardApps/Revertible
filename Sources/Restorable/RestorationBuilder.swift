import Foundation

@resultBuilder
struct RestorationBuilder {
    
    static func buildBlock<Root>(_ restorations: (any ChangeRestoration<Root>)?...) -> (some ChangeRestoration<Root>)? {
        
        let nonNilRestorations = restorations
            .compactMap { $0 }
        
        guard !nonNilRestorations.isEmpty else {
            return ChangeRestorationCollection<Root>?.none
        }
        
        return ChangeRestorationCollection(nonNilRestorations)
    }
}
