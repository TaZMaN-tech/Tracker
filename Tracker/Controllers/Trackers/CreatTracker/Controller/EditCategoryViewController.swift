import UIKit

final class EditCategoryViewController: UIViewController {

    private var editCategoryView: EditCategoryView!
    private var editCategoryText: String?
    
    private struct CategoryViewControllerConstants {
        static let newCategoryTitle = "Новая категория"
        static let editCategoryTitle = "Редактирование категории"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editCategoryView = EditCategoryView(
            frame: view.bounds,
            delegate: self
        )
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .clear
        addScreenView(view: editCategoryView)
        editCategoryView.setTextFieldText(text: editCategoryText)
    }
    
    func setEditType(type: EditCategory, editCategoryString: String?) {
        switch type {
        case .addCategory:
            title = CategoryViewControllerConstants.newCategoryTitle
        case .editCategory:
            title = CategoryViewControllerConstants.editCategoryTitle
            editCategoryText = editCategoryString
        }
    }
    
    deinit {
        print("EditCategoryViewController deinit")
    }
}

extension EditCategoryViewController: EditCategoryViewDelegate {
    func editCategory(category: String?) {
        print("изменили или создали категорию \(category ?? "Error")")
        dismiss(animated: true)
    }
}
