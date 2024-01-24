import UIKit

protocol CreateTrackerViewControllerDelegate: AnyObject {
    func dismissViewController(_ viewController: UIViewController)
    func creatTrackerCategory(_ trackerCategory: TrackerCategory?)
}

final class CreateTrackerViewController: UIViewController {
    
    var typeTracker: TypeTracker?
    weak var delegate: CreateTrackerViewControllerDelegate?
    
    private enum SheduleCategory {
        case shedule
        case category
    }
    
    private struct CreateTrackerViewControllerConstants {
        static let habitTitle = "Новая привычка"
        static let eventTitle = "Новое нерегулярное событие"
    }
    
    private var categoryString: String?
    private var selectedDates: [String]?
    
    private var stringSelectedDates: String {
        if selectedDates?.count == 7 {
            return "Каждый день"
        } else {
            return selectedDates?.joined(separator: ", ") ?? ""
        }
    }
    
    private var trackerCategory: TrackerCategory?
    private var tracker: Tracker?
    
    private var createTrackerView: CreateTrackerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let typeTracker else {
            dismiss(animated: true)
            return
        }
        
        createTrackerView = CreateTrackerView(
            frame: view.bounds,
            delegate: self,
            typeTracker: typeTracker
        )
        
        switch typeTracker {
        case .habit:
            setupView(with: CreateTrackerViewControllerConstants.habitTitle)
        case .event:
            setupView(with: CreateTrackerViewControllerConstants.eventTitle)
        }
    }
    
    private func setupView(with title: String) {
        view.backgroundColor = .clear
        self.title = title
        addScreenView(view: createTrackerView)
    }
    
    deinit {
        print("CreateTrackerViewController deinit")
    }
    
}

extension CreateTrackerViewController: CreateTrackerViewDelegate {
    func sendTrackerSetup(nameTracker: String?, color: UIColor, emoji: String) {
        guard
            let nameTracker,
            let categoryString,
            selectedDates != nil
        else { return }
        tracker = Tracker(id: UUID().uuidString, name: nameTracker, color: color, emoji: emoji, schedule: selectedDates)
        guard let tracker = tracker else { return }
        trackerCategory = TrackerCategory(title: categoryString, trackers: [tracker])
        delegate?.creatTrackerCategory(trackerCategory)
    }
    
    func showShedule() {
        let viewController = createViewController(type: .shedule)
        present(viewController, animated: true)
    }
    
    func showCategory() {
        let viewController = createViewController(type: .category)
        present(viewController, animated: true)
    }

    func cancelCreate() {
        delegate?.dismissViewController(self)
    }
}

// MARK: create CategoryViewController
extension CreateTrackerViewController {
    private func createViewController(type: SheduleCategory) -> UINavigationController {
        let viewController: UIViewController
        
        switch type {
        case .shedule:
            let sheduleViewController = SheduleViewController()
            sheduleViewController.delegate = self
            viewController = sheduleViewController
        case .category:
            let categoryViewController = CategoryViewController()
            categoryViewController.delegate = self
            viewController = categoryViewController
            
            if let categoryString {
                categoryViewController.category = categoryString
            }
        }
        
        let navigationViewController = UINavigationController(rootViewController: viewController)
        return navigationViewController
    }
}

extension CreateTrackerViewController: CategoryViewControllerDelegate {
    func setCategory(category: String?) {
        categoryString = category
        createTrackerView.setCategory(with: category)
        dismiss(animated: true)
    }
}

extension CreateTrackerViewController: SheduleViewControllerDelegate {
    func setSelectedDates(dates: [String]) {
        selectedDates = dates
        createTrackerView.setShedule(with: stringSelectedDates)
        dismiss(animated: true)
    }
}
