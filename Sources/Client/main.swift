import Foundation
import Revertible
import SwiftUI
import Combine

@Versionable
struct Person: Sendable {

    var age = 1
}

@Versioning
struct DumbModel {

    var person: Person = .init()
}

@Observable
@Versioning(
    "person",
    internalizesErrors: false,
    debounceMilliseconds: 1
)
final class ObservableModel {

    var person = Person()
    static let person = Person()
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
    try observableModel._$person.undo()
    print(observableModel.person.age)

    let observableObjectModel = ObservableObjectModel()
    observableObjectModel.person.age = 5
    try observableObjectModel._$person.undo()
    print(observableObjectModel.person.age)

    let actorModel = ActorModel()
    await actorModel.$person.setWithTransaction { $0.age = 5 }
    await actorModel.$person.undo()
    print(await actorModel.person.age)

    try await Task.sleep(for: .seconds(1))
}

try await test()
