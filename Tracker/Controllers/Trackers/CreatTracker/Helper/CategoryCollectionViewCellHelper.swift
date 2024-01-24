import UIKit

protocol CategoryCollectionViewCellHelperDelegate: AnyObject {
    func editCategory(editCategoryString: String?)
    func deleteCategory(delete: String?)
    func updateCollectionView()
    func selectCategory(category: String?)
}

final class CategoryCollectionViewCellHelper: NSObject {
    
    weak var delegate: CategoryCollectionViewCellHelperDelegate?
    static let didChangeNotification = Notification.Name(rawValue: "CategoryDidChange")
    
    private var editCategoryServiceObserver: NSObjectProtocol?
    
    private let oldCategory: String?
    
    private(set) var categories = CategoryStorage.shared.category {
        didSet {
            if categories.isEmpty {
                NotificationCenter.default.post(
                    name: CategoryCollectionViewCellHelper.didChangeNotification,
                    object: self,
                    userInfo: nil)
            }
        }
    }
        
    init(delegate: CategoryCollectionViewCellHelperDelegate?, oldCategory: String?) {
        self.delegate = delegate
        self.oldCategory = oldCategory
        super.init()
        registerObserver()
    }
    
    private func createContextMenu(indexPath: IndexPath) -> UIContextMenuConfiguration {
        return UIContextMenuConfiguration(actionProvider: { [weak self] actions in
            guard let self = self,
                  let category = self.categories[safe: indexPath.row],
                  let string = category else { return UIMenu() }
    
            return UIMenu(children: [
                UIAction(title: "Редактировать") { _ in
                    self.delegate?.editCategory(editCategoryString: string)
                },
                UIAction(title: "Удалить", attributes: .destructive, handler: { _ in
                    self.delegate?.deleteCategory(delete: string)
                })
            ])
        })
    }
    
    private func registerObserver()  {
        editCategoryServiceObserver = NotificationCenter.default
            .addObserver(forName: EditCategoryView.didChangeNotification,
                         object: nil,
                         queue: .main,
                         using: { [weak self] _ in
                guard let self = self else { return }
                self.categories = CategoryStorage.shared.category
                
                DispatchQueue.main.async {
                    self.delegate?.updateCollectionView()
                }
            })
    }
    
    private func setCornerRadius(cell: CategoryCollectionViewCell, numberRow: Int) {
        cell.layer.masksToBounds = true
       
        switch CategoryStorage.shared.category.count {
        case 1:
            cell.layer.cornerRadius = Constants.cornerRadius
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            cell.hideLineView()
        default:
            if numberRow == 0 {
                cell.layer.cornerRadius = Constants.cornerRadius
                cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            }
            
            if numberRow == CategoryStorage.shared.category.count - 1 {
                cell.layer.cornerRadius = Constants.cornerRadius
                cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
                cell.hideLineView()
            }
        }
    }
    
    private func setSelectCell(collectionView: UICollectionView) {
        guard categories.contains(oldCategory) else { return }
        
        let index = categories.firstIndex(of: oldCategory)
        
        if let index {
            let indexPath = IndexPath(row: index, section: 0)
            let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell
            cell?.didSelect()
        }
    }
}

extension CategoryCollectionViewCellHelper: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CategoryCollectionViewCell.reuseIdentifire,
            for: indexPath
        ) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
    
        guard
            let category = categories[safe: indexPath.row],
            let string = category else { return UICollectionViewCell() }

        cell.config(category: string)
        setCornerRadius(cell: cell, numberRow: indexPath.row)
        setSelectCell(collectionView: collectionView)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CategoryStorage.shared.category.count
    }
}

extension CategoryCollectionViewCellHelper: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = CategoryStorage.shared.category[indexPath.row]
        delegate?.selectCategory(category: category)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard indexPaths.count > 0 else { return nil }
        let indexPath = indexPaths[0]
        return createContextMenu(indexPath: indexPath)
    }
}

extension CategoryCollectionViewCellHelper: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = UIScreen.main.bounds.width - Constants.indentationFromEdges * 2
        return CGSize(width: width, height: Constants.hugHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
