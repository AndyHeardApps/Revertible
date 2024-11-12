import Testing
@testable import Revertible

@Suite("Single value reversion")
struct SingleValueReversionTests {}

// MARK: - Tests
extension SingleValueReversionTests {
    
    @Test("Reverts self key path")
    func revertsSelfKeyPath() {

        var value = 0
        let reversion = SingleValueReversion(value: value)
        
        value = 1
        
        #expect(value == 1)
        reversion.revert(&value)
        #expect(value == 0)
    }

    @Test("Reverts mapped value key path")
    func revertsMappedValueKeyPath() {

        var value = MockStruct()
        let reversion = SingleValueReversion(value: value.int)
        .mapped(to: \MockStruct.int)
        
        value.int = 1
        
        #expect(value.int == 1)
        reversion.revert(&value)
        #expect(value.int == 0)
    }

    @Test("Reverts mapped reference key path")
    func revertsMappedReferenceKeyPath() {

        var value = MockClass()
        let reversion = SingleValueReversion(value: value.int)
        .mapped(to: \MockClass.int)
        
        value.int = 1
        
        #expect(value.int == 1)
        reversion.revert(&value)
        #expect(value.int == 0)
    }
}
