import UIKit

protocol SheduleCategoryTableViewHelperDelegate: AnyObject {
    func showCategory()
    func showShedule()
    func reloadTableView()
}

final class SheduleCategoryTableViewHelper: NSObject {
    
    private var typeTracker: TypeTracker
    private var cellsTitle = [
        ScheduleCategoryTableViewModel(name: "Категория", discription: nil),
        ScheduleCategoryTableViewModel(name: "Расписание", discription: nil),
    ]
    
    weak var delegate: SheduleCategoryTableViewHelperDelegate?
    
    init(typeTracker: TypeTracker) {
        self.typeTracker = typeTracker
    }
    
    func setCategory(category: String?) {
        cellsTitle[0].discription = category
        delegate?.reloadTableView()
    }
    
    func setSchedule(schedule: String?) {
        cellsTitle[1].discription = schedule
        delegate?.reloadTableView()
    }
    
    private func cellConfig(cell: UITableViewCell) {
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.font = UIFont.ypRegularSize17
        cell.detailTextLabel?.font = UIFont.ypRegularSize17
        cell.detailTextLabel?.textColor = .ypGray
        cell.backgroundColor = .ypBackground
    }
}

extension SheduleCategoryTableViewHelper: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.hugHeight
    }
}

extension SheduleCategoryTableViewHelper: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch typeTracker {
        case .habit:
            return 2
        case .event:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cellConfig(cell: cell)
        cell.textLabel?.text = cellsTitle[safe: indexPath.row]?.name
        cell.detailTextLabel?.text = cellsTitle[safe: indexPath.row]?.discription
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            delegate?.showCategory()
        case 1:
            delegate?.showShedule()
        default:
            break
        }
    }
}
