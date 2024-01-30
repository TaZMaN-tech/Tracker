import UIKit

protocol ColorAndEmojiCollectionViewHelperDelegate: AnyObject {
    func sendSelectedEmoji(_ emoji: String?)
    func sendSelectedColor(_ color: UIColor?)
}

final class ColorAndEmojiCollectionViewHelper: NSObject {
    
    weak var delegate: ColorAndEmojiCollectionViewHelperDelegate?
    
    private let emoji = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝️", "😪"
    ]
    
    private let emojiSectionTitle = "Emoji"
    private let colorsSectionTitle = "Цвет"
    
    private let colors = [
        UIColor.ypColorSelection1,
        UIColor.ypColorSelection2,
        UIColor.ypColorSelection3,
        UIColor.ypColorSelection4,
        UIColor.ypColorSelection5,
        UIColor.ypColorSelection6,
        UIColor.ypColorSelection7,
        UIColor.ypColorSelection8,
        UIColor.ypColorSelection9,
        UIColor.ypColorSelection10,
        UIColor.ypColorSelection11,
        UIColor.ypColorSelection12,
        UIColor.ypColorSelection13,
        UIColor.ypColorSelection14,
        UIColor.ypColorSelection15,
        UIColor.ypColorSelection16,
        UIColor.ypColorSelection17,
        UIColor.ypColorSelection18,
    ].compactMap { color in
        if let color { return color }
        return nil
    }
    
    private var emojiSelectedItem: Int?
    private var colorSelectedItem: Int?
    private var selectedItem: IndexPath?
}

extension ColorAndEmojiCollectionViewHelper: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        let cell: UICollectionViewCell
        
        switch indexPath.section {
        case 0:
            cell = createEmojiCell(collectionView, cellForItemAt: indexPath)
        default:
            cell = createColorCell(collectionView, cellForItemAt: indexPath)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return emoji.count
        case 1: return colors.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view: UICollectionReusableView
        
        switch indexPath.section {
        case 0:
            view = createReusableView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath, title: emojiSectionTitle)
        case 1:
            view = createReusableView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath, title: colorsSectionTitle)
        default: view = UICollectionReusableView()
        }
        
        return view
    }
}

extension ColorAndEmojiCollectionViewHelper: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        selectedItem = indexPath
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            let cell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell
            cell?.cellIsSelected = true
            emojiSelectedItem = indexPath.item
            
            guard let emojiSelectedItem else { return }
            delegate?.sendSelectedEmoji(emoji[safe: emojiSelectedItem])
            
        case 1:
            let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell
            cell?.cellIsSelected = true
            colorSelectedItem = indexPath.item
            
            guard let colorSelectedItem else { return }
            delegate?.sendSelectedColor(colors[safe: colorSelectedItem])
        default: break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        guard let section = selectedItem?.section else { return }
        
        switch section {
        case 0:
            guard let item = emojiSelectedItem,
                  let cell = collectionView.cellForItem(at: IndexPath(item: item, section: section)) as? EmojiCollectionViewCell
            else { return }
            cell.cellIsSelected = false
        case 1:
            guard let item = colorSelectedItem,
                  let cell = collectionView.cellForItem(at: IndexPath(item: item, section: section)) as? ColorCollectionViewCell
            else { return }
            cell.cellIsSelected = false
        default: break
        }
    }
}

extension ColorAndEmojiCollectionViewHelper: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - (Constants.indentationFromEdges * 2)) / 6
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height / 9
        
        return CGSize(width: width, height: height)
    }
}

extension ColorAndEmojiCollectionViewHelper {
    func createEmojiCell(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: EmojiCollectionViewCell.reuseIdentifire,
            for: indexPath
        ) as? EmojiCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.config(emoji: emoji[safe: indexPath.row])
        return cell
    }
    
    func createColorCell(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ColorCollectionViewCell.reuseIdentifire,
            for: indexPath
        ) as? ColorCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.config(color: colors[safe: indexPath.row])
        return cell
    }
    
    func createReusableView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath,
        title: String
    ) -> UICollectionReusableView {
        
        guard
            kind == UICollectionView.elementKindSectionHeader,
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderReusableView.reuseIdentifier,
                for: indexPath) as? HeaderReusableView
        else {
            return UICollectionReusableView()
        }
        
        switch indexPath.section {
        case 0: view.config(title: emojiSectionTitle)
        case 1: view.config(title: colorsSectionTitle)
        default: break
        }
        
        return view
    }
}





