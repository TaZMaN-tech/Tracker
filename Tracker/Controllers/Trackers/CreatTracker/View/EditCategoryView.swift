
import UIKit

protocol EditCategoryViewDelegate: AnyObject {
    func editCategory(category: String?)
}

final class EditCategoryView: UIView {
    
    weak var delegate: EditCategoryViewDelegate?
    
    static let didChangeNotification = Notification.Name(rawValue: "CategoryDidChange")
    
    private struct CategoryViewConstant {
        static let editButtonTitle = "Готово"
        static let editCategoryTextFieldPlaceholderText = "Введите название категории"
    }
    
    private var editCategoryViewTextFieldHelper = EditCategoryViewTextFieldHelper()
    private let categoryStorage = CategoryStorage.shared
    private var oldCategoryName: String?
    
    private lazy var editCategoryTextField: TrackerTextField = {
        let textField = TrackerTextField(
            frame: .zero,
            placeholderText: CategoryViewConstant.editCategoryTextFieldPlaceholderText
        )
        textField.addTarget(self, action: #selector(textFieldChangeed), for: .editingChanged)
        return textField
    }()
    
    
    private lazy var editButton: TrackerButton = {
        let button = TrackerButton(
            frame: .zero,
            title: CategoryViewConstant.editButtonTitle
        )
        button.addTarget(
            self,
            action: #selector(editButtonTapped),
            for: .touchUpInside
        )
        button.backgroundColor = .ypGray
        button.isEnabled = false
        return button
    }()
    
    init(
        frame: CGRect,
        delegate: EditCategoryViewDelegate?
    ) {
        self.delegate = delegate
        super.init(frame: frame)
        
        editCategoryTextField.delegate = editCategoryViewTextFieldHelper
        
        setupView()
        addSubviews()
        activateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTextFieldText(text: String?) {
        oldCategoryName = text
        editCategoryTextField.text = text
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .ypWhite
    }
    
    private func addSubviews() {
        addSubViews(
            editCategoryTextField,
            editButton
        )
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            editCategoryTextField.heightAnchor.constraint(equalToConstant: Constants.hugHeight),
            editCategoryTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.indentationFromEdges),
            editCategoryTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.indentationFromEdges),
            editCategoryTextField.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            
            editButton.heightAnchor.constraint(equalToConstant: Constants.hugHeight),
            editButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.indentationFromEdges),
            editButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.indentationFromEdges),
            editButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
        ])
    }
    
    @objc
    private func editButtonTapped() {
        editButton.showAnimation { [weak self] in
            guard let self = self else { return }
            self.editCategory()
        }
    }
    
    @objc private func textFieldChangeed() {
        if editCategoryTextField.text?.isEmpty == false {
            editButton.backgroundColor = .ypBlack
            editButton.isEnabled = true
        } else {
            editButton.backgroundColor = .ypGray
            editButton.isEnabled = false
        }
    }
    
    private func editCategory() {
        guard editCategoryTextField.text != "",
              let categoryName = editCategoryTextField.text
        else { return }
        
        if categoryStorage.category.contains(oldCategoryName) {
            guard let index = categoryStorage.category.firstIndex(of: oldCategoryName) else { return }
            categoryStorage.category[index] = categoryName
        } else {
            categoryStorage.category.append(categoryName)
        }
        
        NotificationCenter.default.post(
            name: EditCategoryView.didChangeNotification,
            object: self,
            userInfo: nil)
        delegate?.editCategory(category: categoryName)
    }
}

