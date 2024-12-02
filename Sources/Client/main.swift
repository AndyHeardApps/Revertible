import Foundation
import Revertible
import SwiftUI
import Combine

@Versionable
struct Person {

    var age = 1
}

@Versioning
struct DumbModel {

    var person: Person = .init()
}

@Observable
@Versioning
final class ObservableModel {

    var person = Person()
}

@Versioning
final class ObservableObjectModel: ObservableObject {

    @Published var person: Person = .init()
}

@Versioning
actor ActorModel {

    var person: Person = .init()
}


func test() async throws {

    let structModel = DumbModel()
    structModel.person.age += 5
    structModel.$person.undo()
    print(structModel.person.age)

    let observableModel = ObservableModel()
    observableModel.person.age = 5
    observableModel._$person.undo()
    print(observableModel.person.age)

    let observableObjectModel = ObservableObjectModel()
    observableObjectModel.person.age = 5
    observableObjectModel._$person.undo()
    print(observableObjectModel.person.age)

    let actorModel = ActorModel()
    await actorModel.$person.setWithTransaction { $0.age = 5 }
    await actorModel.$person.undo()
    print(await actorModel.person.age)

    try await Task.sleep(for: .seconds(1))
}

try await test()

@Versionable
struct MyState {}

@Versioning(
    "state3", "state4",
    errorMode: .throwErrors
//    debounceMilliseconds: 100
)
@MainActor
struct Model {

//    @ThrowingVersioned(debounceInterval: .milliseconds(100))
    var state1 = MyState()
    var state2: MyState = .init()
    static var state3 = MyState()
    var state4: MyState {
        get {
            .init()
        }
    }
}
