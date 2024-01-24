import UIKit

final class TabBarController: UITabBarController {
    
    private enum TabBarItem {
        case tracker
        case statistic
        
        var title: String {
            switch self {
            case .tracker:
                return "Трекеры"
            case .statistic:
                return "Статистика"
            }
        }
        
        var image: UIImage? {
            switch self {
            case .tracker:
                return UIImage(named: "record.circle")
            case .statistic:
                return UIImage(named: "hare")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    func setupTabBar() {
        let tabBarItems: [TabBarItem] = [.tracker, .statistic]
        tabBar.tintColor = .ypBlue
        tabBar.unselectedItemTintColor = .ypGray
        
        viewControllers = tabBarItems.compactMap({ item in
            switch item {
            case .tracker:
                let viewController = TrackersViewController()
                return creatNavigationController(vc: viewController, title: item.title)
            case .statistic:
                let viewController = StatisticViewController()
                return creatNavigationController(vc: viewController, title: item.title)
            }
        })
        
        viewControllers?.enumerated().forEach({ (index, vc) in
            vc.tabBarItem.title = tabBarItems[index].title
            vc.tabBarItem.image = tabBarItems[index].image
        })
    }
    
    private func creatNavigationController(vc: UIViewController, title: String) -> UINavigationController {
        vc.title = title
        let navVC = UINavigationController(rootViewController: vc)
        navVC.navigationItem.largeTitleDisplayMode = .always
        navVC.navigationBar.prefersLargeTitles = true
        return navVC
    }
}
    
