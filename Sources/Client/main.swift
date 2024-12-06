import Foundation
import Revertible
import SwiftUI
import Combine

@Versionable
struct Activity: Identifiable {

    let id: UUID
    var title: String
    var priority: Priority
    var childActivities: [Activity]

    @Versionable
    enum Priority {
        case low
        case medium(dueDate: Date?)
        case high(dueDate: Date, reason: String)
    }
}

@Versioning(debounceMilliseconds: 200)
struct Model {
    var activity: Activity = .mock
}

let model = Model(
    activity: Activity(
        id: .init(),
        title: "Title",
        priority: .low,
        childActivities: []
    )
)

var activity = Activity(
    id: .init(),
    title: "Title",
    priority: .low,
    childActivities: []

)
let controller = VersioningController(activity)
controller.
