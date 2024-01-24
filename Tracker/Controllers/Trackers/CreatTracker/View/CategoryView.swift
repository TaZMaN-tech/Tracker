
import UIKit

enum EditCategory {
    case addCategory
    case editCategory
}

protocol CategoryViewDelegate: AnyObject {
    func showEditCategoryViewController(type: EditCategory, editCategoryString: String?)
    func showDeleteActionSheet(category: String?)
    func selectCategory(category: String?)
}

final class CategoryView: UIView {
    
    weak var delegate: CategoryViewDelegate?
    
    private var categoryCollectionViewCellHelperObserver: NSObjectProtocol?
    
    private struct CategoryViewConstant {
        static let collectionViewReuseIdentifier = "Cell"
        static let addButtontitle = "Добавить категорию"
        static let plugLabelText = """
            Привычки и события можно
            объединить по смыслу
        """
    }
    
    private var сategoryCollectionViewCellHelper: CategoryCollectionViewCellHelper?
    
    private lazy var plugView: PlugView = {
        let plugView = PlugView(
            frame: .zero,
            titleLabel: CategoryViewConstant.plugLabelText,
            image: UIImage(named: "plug") ?? UIImage()
        )
        plugView.isHidden = true
        return plugView
    }()
    
    private let categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: CategoryViewConstant.collectionViewReuseIdentifier
        )
        collectionView.register(
            CategoryCollectionViewCell.self,
            forCellWithReuseIdentifier: CategoryCollectionViewCell.reuseIdentifire
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private lazy var addButton: TrackerButton = {
        let button = TrackerButton(
            frame: .zero,
            title: CategoryViewConstant.addButtontitle
        )
        button.addTarget(
            self,
            action: #selector(addButtonTapped),
            for: .touchUpInside
        )
        return button
    }()
    
    init(
        frame: CGRect,
        delegate: CategoryViewDelegate?,
        category: String? = nil
    ) {
        self.delegate = delegate
        
        super.init(frame: frame)
        
        сategoryCollectionViewCellHelper = CategoryCollectionViewCellHelper(delegate: self, oldCategory: category)
        categoryCollectionView.delegate = сategoryCollectionViewCellHelper
        categoryCollectionView.dataSource = сategoryCollectionViewCellHelper
        
        if
            let сategoryCollectionViewCellHelper = сategoryCollectionViewCellHelper,
            сategoryCollectionViewCellHelper.categories.isEmpty {
            plugView.isHidden = false
        }
        
        categoryCollectionViewCellHelperObserver = NotificationCenter.default
            .addObserver(forName: CategoryCollectionViewCellHelper.didChangeNotification,
                         object: nil,
                         queue: .main,
                         using: { [weak self] _ in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.plugView.isHidden = true
                }
            })
        
        setupView()
        addSubviews()
        activateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadCollectionView() {
        categoryCollectionView.reloadData()
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .ypWhite
    }
    
    private func addSubviews() {
        addSubViews(
            categoryCollectionView,
            addButton,
            plugView
        )
    }
    
    private func activateConstraints() {
        
        let plugViewTopConstant = frame.height / 3.5
        
        NSLayoutConstraint.activate([
            categoryCollectionView.topAnchor.constraint(equalTo: topAnchor),
            categoryCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.indentationFromEdges),
            categoryCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.indentationFromEdges),
            categoryCollectionView.bottomAnchor.constraint(equalTo: addButton.topAnchor),
            
            addButton.heightAnchor.constraint(equalToConstant: Constants.hugHeight),
            addButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.indentationFromEdges),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.indentationFromEdges),
            addButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            
            plugView.topAnchor.constraint(equalTo: topAnchor, constant: plugViewTopConstant),
            plugView.leadingAnchor.constraint(equalTo: leadingAnchor),
            plugView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    @objc
    private func addButtonTapped() {
        addButton.showAnimation { [weak self] in
            guard let self = self else { return }
            self.delegate?.showEditCategoryViewController(type: .addCategory, editCategoryString: nil)
        }
    }
}

extension CategoryView: CategoryCollectionViewCellHelperDelegate {
    func selectCategory(category: String?) {
        delegate?.selectCategory(category: category)
    }
    
    func deleteCategory(delete: String?) {
        delegate?.showDeleteActionSheet(category: delete)
    }
    
    func updateCollectionView() {
        categoryCollectionView.reloadData()
    }
    
    func editCategory(editCategoryString: String?) {
        delegate?.showEditCategoryViewController(type: .editCategory, editCategoryString: editCategoryString)
    }
}
