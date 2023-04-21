import Foundation

extension Set where Self: Hashable, Element: Hashable {
    
    /// Creates a ``Reversion`` to a the previous version of the object.
    ///
    /// The returned ``Reversion`` will revert the calling object back to the state of the `previous` parameter.
    ///
    /// If the calling object and `previous` parameter are equal, then `nil` is returned.
    /// - Parameter previous: Some other instance or previous version of the calling type that the returned ``Reversion`` will revert the calling object to.
    /// - Returns: A ``Reversion`` that will update the state of the calling instance to `previous`, or `nil` if the two are equal.
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

extension Set where Self: Hashable, Element: Identifiable & Revertable {
    
    /// Creates a ``Reversion`` to a the previous version of the object.
    ///
    /// The returned ``Reversion`` will revert the calling object back to the state of the `previous` parameter.
    ///
    /// If the calling object and `previous` parameter are equal, then `nil` is returned.
    /// - Parameter previous: Some other instance or previous version of the calling type that the returned ``Reversion`` will revert the calling object to.
    /// - Returns: A ``Reversion`` that will update the state of the calling instance to `previous`, or `nil` if the two are equal.
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

extension Array where Self: Hashable, Element: Hashable {
    
    /// Creates a ``Reversion`` to a the previous version of the object.
    ///
    /// The returned ``Reversion`` will revert the calling object back to the state of the `previous` parameter.
    ///
    /// If the calling object and `previous` parameter are equal, then `nil` is returned.
    /// - Parameter previous: Some other instance or previous version of the calling type that the returned ``Reversion`` will revert the calling object to.
    /// - Returns: A ``Reversion`` that will update the state of the calling instance to `previous`, or `nil` if the two are equal.
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

extension Array where Self: Hashable, Element: Identifiable & Revertable {
    
    /// Creates a ``Reversion`` to a the previous version of the object.
    ///
    /// The returned ``Reversion`` will revert the calling object back to the state of the `previous` parameter.
    ///
    /// If the calling object and `previous` parameter are equal, then `nil` is returned.
    /// - Parameter previous: Some other instance or previous version of the calling type that the returned ``Reversion`` will revert the calling object to.
    /// - Returns: A ``Reversion`` that will update the state of the calling instance to `previous`, or `nil` if the two are equal.
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

extension Dictionary where Self: Hashable, Key: Hashable, Value: Equatable {
    
    /// Creates a ``Reversion`` to a the previous version of the object.
    ///
    /// The returned ``Reversion`` will revert the calling object back to the state of the `previous` parameter.
    ///
    /// If the calling object and `previous` parameter are equal, then `nil` is returned.
    /// - Parameter previous: Some other instance or previous version of the calling type that the returned ``Reversion`` will revert the calling object to.
    /// - Returns: A ``Reversion`` that will update the state of the calling instance to `previous`, or `nil` if the two are equal.
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

extension Dictionary where Self: Hashable, Key: Hashable, Value: Identifiable & Revertable {

    /// Creates a ``Reversion`` to a the previous version of the object.
    ///
    /// The returned ``Reversion`` will revert the calling object back to the state of the `previous` parameter.
    ///
    /// If the calling object and `previous` parameter are equal, then `nil` is returned.
    /// - Parameter previous: Some other instance or previous version of the calling type that the returned ``Reversion`` will revert the calling object to.
    /// - Returns: A ``Reversion`` that will update the state of the calling instance to `previous`, or `nil` if the two are equal.
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

extension Data {

    /// Creates a ``Reversion`` to a the previous version of the object.
    ///
    /// The returned ``Reversion`` will revert the calling object back to the state of the `previous` parameter.
    ///
    /// If the calling object and `previous` parameter are equal, then `nil` is returned.
    /// - Parameter previous: Some other instance or previous version of the calling type that the returned ``Reversion`` will revert the calling object to.
    /// - Returns: A ``Reversion`` that will update the state of the calling instance to `previous`, or `nil` if the two are equal.
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

extension String {

    /// Creates a ``Reversion`` to a the previous version of the object.
    ///
    /// The returned ``Reversion`` will revert the calling object back to the state of the `previous` parameter.
    ///
    /// If the calling object and `previous` parameter are equal, then `nil` is returned.
    /// - Parameter previous: Some other instance or previous version of the calling type that the returned ``Reversion`` will revert the calling object to.
    /// - Returns: A ``Reversion`` that will update the state of the calling instance to `previous`, or `nil` if the two are equal.
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
