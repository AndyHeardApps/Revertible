import Testing
@testable import Revertible

@Suite("Multiple value reversion")
struct MultipleValueReversionTests {}

// MARK: - Tests
extension MultipleValueReversionTests {

    @Test("Invokes revert on child reversions")
    func invokesRevertOnChildReversions() {
        
        let reversion1 = MockValueReversion<Int>()
        let reversion2 = MockValueReversion<Int>()
        let multipleReversion = MultipleValueReversion([
            reversion1.erasedToAnyValueReversion(),
            reversion2.erasedToAnyValueReversion()
        ])
        
        var value = 1
        
        #expect(reversion1.revertedObject == nil)
        #expect(reversion2.revertedObject == nil)
        multipleReversion.revert(&value)
        #expect(reversion1.revertedObject == 1)
        #expect(reversion2.revertedObject == 1)
    }

    @Test("Mapped reversion invokes revert on child reversions")
    func mappedReversionInvokesRevertOnChildReversions() {

        let reversion1 = MockValueReversion<Int>()
        let reversion2 = MockValueReversion<Int>()
        let multipleReversion = MultipleValueReversion([
            reversion1.erasedToAnyValueReversion(),
            reversion2.erasedToAnyValueReversion()
        ])

        #expect(reversion1.mappedCalled == false)
        #expect(reversion2.mappedCalled == false)
        let _ = multipleReversion.mapped(to: \Int.self)
        #expect(reversion1.mappedCalled == true)
        #expect(reversion2.mappedCalled == true)
    }
}
