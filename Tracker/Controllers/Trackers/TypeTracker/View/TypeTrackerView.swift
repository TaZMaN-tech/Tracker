import UIKit

protocol TypeTrackerViewDelegate: AnyObject {
    func showHabit()
    func showIirregularEvents()
}

final class TypeTrackerView: UIView {
    
    // MARK: -Delegate
    weak var delegate: TypeTrackerViewDelegate?
    
    // MARK: -TypeTrackerViewConstants
    private struct TypeTrackerViewConstants {
        static let habbitButtonTitle = "Привычка"
        static let eventButtonTitle = "Нерегулярные события"
        static let topAnchorConstant: CGFloat = 30
        static let spacingConstant: CGFloat = 16
        static let indentationFromEdges: CGFloat = 20
        static let buttonHeight: CGFloat = 60
    }
    
    // MARK: UI    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = TypeTrackerViewConstants.spacingConstant
        return stackView
    }()
    
    private lazy var habitButton: TrackerButton = {
        let button = TrackerButton(
            frame: .zero,
            title: TypeTrackerViewConstants.habbitButtonTitle
        )
        button.addTarget(
            self,
            action: #selector(habitButtonTapped),
            for: .touchUpInside
        )
        return button
    }()
    
    private lazy var eventButton: TrackerButton = {
        let button = TrackerButton(
            frame: .zero,
            title: TypeTrackerViewConstants.eventButtonTitle
        )
        button.addTarget(
            self,
            action: #selector(eventButtonTapped),
            for: .touchUpInside
        )
        return button
    }()
    
    // MARK: -Initialization
    init(
        frame: CGRect,
        delegate: TypeTrackerViewDelegate?
    ) {
        super.init(frame: frame)
        self.delegate = delegate
        setupView()
        addViews()
        activateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .ypWhite
    }
    
    private func addViews() {
        addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(habitButton)
        buttonsStackView.addArrangedSubview(eventButton)
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            buttonsStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            buttonsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: TypeTrackerViewConstants.indentationFromEdges),
            buttonsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -TypeTrackerViewConstants.indentationFromEdges),
            
            habitButton.heightAnchor.constraint(equalToConstant: TypeTrackerViewConstants.buttonHeight),
            eventButton.heightAnchor.constraint(equalToConstant: TypeTrackerViewConstants.buttonHeight)
        ])
    }
    
    @objc
    private func habitButtonTapped() {
        habitButton.showAnimation { [weak self] in
            guard let self = self else { return }
            self.delegate?.showHabit()
        }
    }
    
    @objc
    private func eventButtonTapped() {
        eventButton.showAnimation { [weak self] in
            guard let self = self else { return }
            self.delegate?.showIirregularEvents()
        }
    }
}
