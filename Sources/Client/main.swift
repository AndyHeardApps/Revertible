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
@Versioning("activity", debounceMilliseconds: 200)
final class Model {

    @ObservationIgnored
    @Versioned var test = Activity.mock

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

var act
