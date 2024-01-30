import UIKit

protocol CreateTrackerViewDelegate: AnyObject {
    func sendTrackerSetup(nameTracker: String?, color: UIColor, emoji: String)
    func cancelCreate()
    func showCategory()
    func showShedule()
}

final class CreateTrackerView: UIView {
    
    // MARK: -Delegate
    weak var delegate: CreateTrackerViewDelegate?
    
    // MARK: -CreateTrackerViewConstants
    private struct CreateTrackerViewConstants {
        static let cancelButtonTitle = "Отменить"
        static let createButtonTitle = "Создать"
        static let errorLabelText = "Ограничение 38 символов"
        static let textFieldPlaceholder = "Введите название трекера"
        static let standartCellIdentifire = "cell"
        static let spacingConstant: CGFloat = 8
    }
    
    // MARK: -Private properties
    private var typeTracer: TypeTracker
    private var contentSize: CGSize {
        CGSize(width: frame.width, height: 931)
    }
    
    private var emojiCollectionViewHelper: ColorAndEmojiCollectionViewHelper
    private var sheduleCategoryTableViewHelper: SheduleCategoryTableViewHelper
    private var nameTrackerTextFieldHelper =  NameTrackerTextFieldHelper()
    
    private var emoji: String?
    private var color: UIColor?
    
    private var topViewConstraint: NSLayoutConstraint!
    
    // MARK: UI
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        scrollView.contentSize = contentSize
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        contentView.frame.size = contentSize
        return contentView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    private lazy var nameTrackerTextField: TrackerTextField = {
        let textField = TrackerTextField(
            frame: .zero,
            placeholderText: CreateTrackerViewConstants.textFieldPlaceholder
        )
        textField.addTarget(self, action: #selector(textFieldChangeed), for: .editingChanged)
        return textField
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.ypRegularSize17
        label.textColor = .ypRed
        label.text = CreateTrackerViewConstants.errorLabelText
        label.textAlignment = .center
        label.alpha = 0
        return label
    }()
    
    private lazy var sheduleCategoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: CreateTrackerViewConstants.standartCellIdentifire
        )
        tableView.backgroundColor = .clear
        tableView.layer.cornerRadius = Constants.cornerRadius
        return tableView
    }()
    
    private let colorAndEmojiCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: "emojiCell"
        )
        collectionView.register(
            EmojiCollectionViewCell.self,
            forCellWithReuseIdentifier: EmojiCollectionViewCell.reuseIdentifire
        )
        collectionView.register(
            HeaderReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderReusableView.reuseIdentifier)
        collectionView.register(
            ColorCollectionViewCell.self,
            forCellWithReuseIdentifier: ColorCollectionViewCell.reuseIdentifire)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = CreateTrackerViewConstants.spacingConstant
        return stackView
    }()
    
    private lazy var cancelButton: TrackerButton = {
        let button = TrackerButton(
            frame: .zero,
            title: CreateTrackerViewConstants.cancelButtonTitle
        )
        button.addTarget(
            self,
            action: #selector(cancelButtonTapped),
            for: .touchUpInside
        )
        button.setTitleColor(.ypRed, for: .normal)
        button.backgroundColor = .ypWhite
        button.layer.borderColor = UIColor.ypRed?.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    private lazy var createButton: TrackerButton = {
        let button = TrackerButton(
            frame: .zero,
            title: CreateTrackerViewConstants.createButtonTitle
        )
        button.addTarget(
            self,
            action: #selector(createButtonTapped),
            for: .touchUpInside
        )
        button.backgroundColor = .ypGray
        button.isEnabled = false
        return button
    }()
    
    // MARK: -Initialization
    init(
        frame: CGRect,
        delegate: CreateTrackerViewDelegate?,
        typeTracker: TypeTracker
    ) {
        self.delegate = delegate
        self.typeTracer = typeTracker
        emojiCollectionViewHelper = ColorAndEmojiCollectionViewHelper()
        sheduleCategoryTableViewHelper = SheduleCategoryTableViewHelper(typeTracker: typeTracker)
        super.init(frame: frame)
        
        colorAndEmojiCollectionView.dataSource = emojiCollectionViewHelper
        colorAndEmojiCollectionView.delegate = emojiCollectionViewHelper
        
        sheduleCategoryTableView.dataSource = sheduleCategoryTableViewHelper
        sheduleCategoryTableView.delegate = sheduleCategoryTableViewHelper
        
        nameTrackerTextField.delegate = nameTrackerTextFieldHelper
        emojiCollectionViewHelper.delegate = self
        
        nameTrackerTextFieldHelper.delegate = self
        sheduleCategoryTableViewHelper.delegate = self
        
        setupView()
        addViews()
        activateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCategory(with category: String?) {
        sheduleCategoryTableViewHelper.setCategory(category: category)
    }
    
    func setShedule(with shedule: String?) {
        sheduleCategoryTableViewHelper.setSchedule(schedule: shedule)
    }
    
    // MARK: - Private methods
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .ypWhite
    }
    
    private func addViews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubViews(
            nameTrackerTextField,
            errorLabel,
            stackView,
            buttonStackView
        )
        
        stackView.addArrangedSubview(sheduleCategoryTableView)
        stackView.addArrangedSubview(colorAndEmojiCollectionView)
        
        buttonStackView.addArrangedSubview(cancelButton)
        buttonStackView.addArrangedSubview(createButton)
    }
    
    private func activateConstraints() {
        
        var tableViewHeight: CGFloat = Constants.hugHeight
        
        switch typeTracer {
        case .habit:
            tableViewHeight *= 2
        case .event:
            break
        }
        
        let buttonHeight: CGFloat = 60
        let verticalAxis: CGFloat = 10
        let edge = Constants.indentationFromEdges
        
        let insetBetweenNameTextFieldAndStackView: CGFloat = 24
        
        topViewConstraint = stackView.topAnchor.constraint(equalTo: nameTrackerTextField.bottomAnchor, constant: insetBetweenNameTextFieldAndStackView)
        topViewConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            nameTrackerTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalAxis),
            nameTrackerTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: edge),
            nameTrackerTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -edge),
            nameTrackerTextField.heightAnchor.constraint(equalToConstant: Constants.hugHeight),
            
            errorLabel.leadingAnchor.constraint(equalTo: nameTrackerTextField.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: nameTrackerTextField.trailingAnchor),
            errorLabel.topAnchor.constraint(equalTo: nameTrackerTextField.bottomAnchor, constant: 8),
            
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: edge),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -edge),
            stackView.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor, constant: -10),
            
            buttonStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            buttonStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: edge),
            buttonStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -edge),
            buttonStackView.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            sheduleCategoryTableView.heightAnchor.constraint(equalToConstant: tableViewHeight),
        ])
    }
    
    @objc
    private func createButtonTapped() {
        createButton.showAnimation { [weak self] in
            guard
                let self = self,
                self.nameTrackerTextField.text != "",
                let selectedEmoji = self.emoji,
                let selectedColor = self.color else { return }
            self.delegate?.sendTrackerSetup(
                nameTracker: self.nameTrackerTextField.text,
                color: selectedColor,
                emoji: selectedEmoji
            )
        }
    }
    
    @objc private func textFieldChangeed() {
        if nameTrackerTextField.text?.isEmpty == false {
            createButton.backgroundColor = .ypBlack
            createButton.isEnabled = true
        } else {
            createButton.backgroundColor = .ypGray
            createButton.isEnabled = false
        }
    }
    
    @objc
    private func cancelButtonTapped() {
        cancelButton.showAnimation { [weak self] in
            guard let self = self else { return }
            self.delegate?.cancelCreate()
        }
    }
}

extension CreateTrackerView: NameTrackerTextFieldHelperDelegate {
    func noLimitedCharacters() {
        topViewConstraint.constant = 24
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.errorLabel.alpha = 0
            self.layoutIfNeeded()
        }
    }
    
    func askLimitedCharacter() {
        topViewConstraint.constant = 40
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.errorLabel.alpha = 1
            self.layoutIfNeeded()
        }
    }
}

extension CreateTrackerView: SheduleCategoryTableViewHelperDelegate {
    func reloadTableView() {
        sheduleCategoryTableView.reloadData()
    }
    
    func showShedule() {
        delegate?.showShedule()
    }
    
    func showCategory() {
        delegate?.showCategory()
    }
}

extension CreateTrackerView: ColorAndEmojiCollectionViewHelperDelegate {
    func sendSelectedEmoji(_ emoji: String?) {
        self.emoji = emoji
    }
    
    func sendSelectedColor(_ color: UIColor?) {
        self.color = color
    }
}
