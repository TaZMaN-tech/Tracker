import Foundation

struct ScheduleCategoryTableViewModel {
    let name: String
    var discription: String?
}

extension ScheduleCategoryTableViewModel: Equatable {
    static func == (lrh: ScheduleCategoryTableViewModel, rhs: ScheduleCategoryTableViewModel) -> Bool {
        lrh.discription == rhs.discription ? true : false
    }
}
