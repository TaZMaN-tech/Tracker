import UIKit

protocol SheduleViewDelegate: AnyObject {
    func setDates(dates: [String]?)
}

final class SheduleView: UIView {
    
    weak var delegate: SheduleViewDelegate?
    
    private struct SheduleViewConstant {
        static let collectionViewReuseIdentifier = "cell"
        static let addButtontitle = "Готово"
    }
    
    private var sheduleCollectionViewCellHelper: SheduleCollectionViewCellHelper?
    
    private let sheduleCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: SheduleViewConstant.collectionViewReuseIdentifier
        )
        collectionView.register(
            SheduleCollectionViewCell.self,
            forCellWithReuseIdentifier: SheduleCollectionViewCell.reuseIdentifire
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private lazy var addButton: TrackerButton = {
        let button = TrackerButton(
            frame: .zero,
            title: SheduleViewConstant.addButtontitle
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
        delegate: SheduleViewDelegate?
    ) {
        self.delegate = delegate
       
        super.init(frame: frame)
        
        sheduleCollectionViewCellHelper = SheduleCollectionViewCellHelper()
        sheduleCollectionView.delegate = sheduleCollectionViewCellHelper
        sheduleCollectionView.dataSource = sheduleCollectionViewCellHelper
        
        setupView()
        addSubviews()
        activateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .ypWhite
    }
    
    private func addSubviews() {
        addSubViews(
            sheduleCollectionView,
            addButton
        )
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            sheduleCollectionView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            sheduleCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.indentationFromEdges),
            sheduleCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.indentationFromEdges),
            sheduleCollectionView.bottomAnchor.constraint(equalTo: addButton.topAnchor),
            
            addButton.heightAnchor.constraint(equalToConstant: Constants.hugHeight),
            addButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.indentationFromEdges),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.indentationFromEdges),
            addButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
        ])
    }
    
    @objc
    private func addButtonTapped() {
        addButton.showAnimation { [weak self] in
            guard let self = self else { return }
            let weeDayNumber = [ "Пн": 0, "Вт": 1, "Ср": 2, "Чт": 3, "Пт": 4, "Сб": 5, "Вс": 6]
            let sortDays = self.sheduleCollectionViewCellHelper?.selectedDates.sorted(by: { weeDayNumber[$0] ?? 7 < weeDayNumber[$1] ?? 7
            })
            self.delegate?.setDates(dates: sortDays)
        }
    }
}
