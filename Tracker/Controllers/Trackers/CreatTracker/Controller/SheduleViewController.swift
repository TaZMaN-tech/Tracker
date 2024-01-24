import UIKit

protocol SheduleViewControllerDelegate: AnyObject {
    func setSelectedDates(dates: [String])
}

final class SheduleViewController: UIViewController {

    private var sheduleView: SheduleView!
   
    weak var delegate: SheduleViewControllerDelegate?
    
    private struct SheduleViewControllerConstants {
        static let title = "Расписание"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sheduleView = SheduleView(
            frame: view.bounds,
            delegate: self
        )
        setupView()
    }
    
    private func setupView() {
        title =  SheduleViewControllerConstants.title
        view.backgroundColor = .clear
        addScreenView(view: sheduleView)
    }
    
    deinit {
        print("SheduleViewController deinit")
    }
}

extension SheduleViewController: SheduleViewDelegate {
    func setDates(dates: [String]?) {
        guard let dates, !dates.isEmpty else { return }
        delegate?.setSelectedDates(dates: dates)
    }
}
