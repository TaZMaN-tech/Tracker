import UIKit

struct Tracker {
    let id: String
    let name: String
    let color: UIColor?
    let emoji: String
    let schedule: [String]?
}

extension Tracker: Equatable {
    static func == (lrh: Tracker, rhs: Tracker) -> Bool {
        lrh.id == rhs.id ? true : false
    }
}
