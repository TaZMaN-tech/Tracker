import UIKit

final class SheduleCollectionViewCellHelper: NSObject {
    private let daysArray = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
    private(set) var selectedDates: Set<String> = []
}

extension SheduleCollectionViewCellHelper: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SheduleCollectionViewCell.reuseIdentifire,
            for: indexPath
        ) as? SheduleCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.config(day: daysArray[safe: indexPath.row])
        
        if indexPath.row == 0 {
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = Constants.cornerRadius
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }

        if indexPath.row == daysArray.count - 1 {
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = Constants.cornerRadius
            cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            cell.hideLineView()
        }

        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        daysArray.count
    }
}

extension SheduleCollectionViewCellHelper: UICollectionViewDelegateFlowLayout {
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

extension SheduleCollectionViewCellHelper: SheduleCollectionViewCellProtocol {
    func getSelectedDay(_ indexPath: IndexPath?, select: Bool) {
        guard let indexPath else { return }
        var index = indexPath.row + 1
        if index == Calendar.current.shortWeekdaySymbols.count { index = 0 }
        let day = Calendar.current.shortWeekdaySymbols[index]
        
        if select {
            selectedDates.insert(day)
        } else {
            selectedDates.remove(day)
        }
    }
}
