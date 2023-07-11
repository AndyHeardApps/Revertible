import Foundation

// MARK: - Set
extension Set: Revertable where Self: Hashable, Element: Hashable {
    
    public func reversion(to previous: Self) -> Reversion<Self>? {
        
        var reverter = DefaultReverter(current: self, previous: previous)
        reverter.appendReversion(at: \.self)
        
        guard let reverterReversion = reverter.erasedToAnyValueReversion() else {
            return nil
        }
        
        let reversion = Reversion(
            root: self,
            reversion: reverterReversion
        )
        
        return reversion
    }
}

// MARK: - Array
extension Array: Revertable where Self: Hashable, Element: Identifiable & Versionable {
    
    public func reversion(to previous: Self) -> Reversion<Self>? {
        
        var reverter = DefaultReverter(current: self, previous: previous)
        reverter.appendReversion(at: \.self)
        
        guard let reverterReversion = reverter.erasedToAnyValueReversion() else {
            return nil
        }
        
        let reversion = Reversion(
            root: self,
            reversion: reverterReversion
        )
        
        return reversion
    }
}

// MARK: - Dictionary
extension Dictionary: Revertable where Self: Hashable, Key: Hashable, Value: Identifiable & Versionable {

    public func reversion(to previous: Self) -> Reversion<Self>? {
        
        var reverter = DefaultReverter(current: self, previous: previous)
        reverter.appendReversion(at: \.self)
        
        guard let reverterReversion = reverter.erasedToAnyValueReversion() else {
            return nil
        }
        
        let reversion = Reversion(
            root: self,
            reversion: reverterReversion
        )
        
        return reversion
    }
}

// MARK: - Data
extension Data: Revertable {

    public func reversion(to previous: Self) -> Reversion<Self>? {
        
        var reverter = DefaultReverter(current: self, previous: previous)
        reverter.appendReversion(at: \.self)
        
        guard let reverterReversion = reverter.erasedToAnyValueReversion() else {
            return nil
        }
        
        let reversion = Reversion(
            root: self,
            reversion: reverterReversion
        )
        
        return reversion
    }
}

// MARK: - String
extension String: Revertable {

    public func reversion(to previous: Self) -> Reversion<Self>? {
        
        var reverter = DefaultReverter(current: self, previous: previous)
        reverter.appendReversion(at: \.self)
        
        guard let reverterReversion = reverter.erasedToAnyValueReversion() else {
            return nil
        }
        
        let reversion = Reversion(
            root: self,
            reversion: reverterReversion
        )
        
        return reversion
    }
}
