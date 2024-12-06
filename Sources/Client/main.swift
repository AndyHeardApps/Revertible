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

@Observable
@Versioning(debounceMilliseconds: 200)
final class Model {
    var activity: Activity = .mock

    init(activity: Activity) {
        self.activity = activity
    }
}

let model = Model(
    activity: Activity(
        id: .init(),
        title: "Title",
        priority: .low,
        childActivities: []
    )
)

let controller = VersioningController(
    on: model,
    at: \.activity,
)

model.activity.title = "New title"
controller.appendCurrentVersion()
try controller.undo()

model.activity = try controller.undo()
try controller.undo(root: &model)
