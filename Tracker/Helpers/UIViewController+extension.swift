import UIKit

extension UIViewController {
    func addScreenView(view: UIView) {
        self.view.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            view.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            view.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
}
