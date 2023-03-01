import Foundation

// MARK: - Default implementation
extension Equatable where Self: Restorable {

    fileprivate func equatableRestoration(toPrevious previous: Self) -> SingleChangeRestoration<Self, Self>? {

        guard self != previous else {
            return nil
        }

        return SingleChangeRestoration(value: previous)
    }
}

// MARK: - Conformances
extension Int: Restorable {
    func restoration(toPrevious previous: Self) -> (some ChangeRestoration<Self>)? {
        equatableRestoration(toPrevious: previous)
    }
}

extension Int64: Restorable {
    func restoration(toPrevious previous: Self) -> (some ChangeRestoration<Self>)? {
        equatableRestoration(toPrevious: previous)
    }
}

extension Int32: Restorable {
    func restoration(toPrevious previous: Self) -> (some ChangeRestoration<Self>)? {
        equatableRestoration(toPrevious: previous)
    }
}

extension Int16: Restorable {
    func restoration(toPrevious previous: Self) -> (some ChangeRestoration<Self>)? {
        equatableRestoration(toPrevious: previous)
    }
}

extension Int8: Restorable {
    func restoration(toPrevious previous: Self) -> (some ChangeRestoration<Self>)? {
        equatableRestoration(toPrevious: previous)
    }
}

extension UInt: Restorable {
    func restoration(toPrevious previous: Self) -> (some ChangeRestoration<Self>)? {
        equatableRestoration(toPrevious: previous)
    }
}

extension UInt64: Restorable {
    func restoration(toPrevious previous: Self) -> (some ChangeRestoration<Self>)? {
        equatableRestoration(toPrevious: previous)
    }
}

extension UInt32: Restorable {
    func restoration(toPrevious previous: Self) -> (some ChangeRestoration<Self>)? {
        equatableRestoration(toPrevious: previous)
    }
}

extension UInt16: Restorable {
    func restoration(toPrevious previous: Self) -> (some ChangeRestoration<Self>)? {
        equatableRestoration(toPrevious: previous)
    }
}

extension UInt8: Restorable {
    func restoration(toPrevious previous: Self) -> (some ChangeRestoration<Self>)? {
        equatableRestoration(toPrevious: previous)
    }
}

extension Double: Restorable {
    func restoration(toPrevious previous: Self) -> (some ChangeRestoration<Self>)? {
        equatableRestoration(toPrevious: previous)
    }
}

extension Float: Restorable {
    func restoration(toPrevious previous: Self) -> (some ChangeRestoration<Self>)? {
        equatableRestoration(toPrevious: previous)
    }
}

extension String: Restorable {
    func restoration(toPrevious previous: Self) -> (some ChangeRestoration<Self>)? {
        equatableRestoration(toPrevious: previous)
    }
}

extension Data: Restorable {
    func restoration(toPrevious previous: Self) -> (some ChangeRestoration<Self>)? {
        equatableRestoration(toPrevious: previous)
    }
}
