
extension Equatable where Self: Revertable {

    func overwritingReversion(toPrevious previous: Self) -> SingleValueReversion<Self, Self>? {

        guard self != previous else {
            return nil
        }

        return SingleValueReversion(keyPath: \.self, value: previous)
    }
}
