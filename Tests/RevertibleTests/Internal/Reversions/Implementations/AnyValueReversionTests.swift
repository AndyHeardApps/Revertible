import Testing
@testable import Revertible

@Suite("Any value reversion")
struct AnyValueReversionTests {}

// MARK: - Tests
extension AnyValueReversionTests {
    
    @Test("Invokes revert on wrapped reversion")
    func invokesRevertOnWrappedReversion() {

        let reversion = MockValueReversion<Int>()
        let anyReversion = reversion.erasedToAnyValueReversion()
        
        var value = 1
        
        #expect(reversion.revertedObject == nil)
        anyReversion.revert(&value)
        #expect(reversion.revertedObject == 1)
    }

    @Test("Mapped reversion invokes revert on wrapped reversion")
    func mappedReversionInvokesRevertOnWrappedReversion() {

        let reversion = MockValueReversion<Int>()
        let anyReversion = reversion.erasedToAnyValueReversion()
                
        #expect(reversion.mappedCalled == false)
        let _ = anyReversion.mapped(to: \Int.self)
        #expect(reversion.mappedCalled == true)
    }
}
