import Foundation

struct TrackerRecord: Hashable {
    let trackerID: String
    let checkDate: Date
}

extension TrackerRecord: Equatable {
    static func == (lrh: TrackerRecord, rhs: TrackerRecord) -> Bool {
        lrh.trackerID == rhs.trackerID && lrh.checkDate == rhs.checkDate ? true : false
    }
}
