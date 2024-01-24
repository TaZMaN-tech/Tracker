import UIKit

final class CategoryCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifire = "CategoryCollectionViewCell"
    
    private struct CategoryCollectionViewCellConstants {
        static let checkmarkImageName = "checkmark"
    }
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.ypRegularSize17
        label.textColor = .ypBlack
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(
            named: CategoryCollectionViewCellConstants.checkmarkImageName
        )?.withRenderingMode(.alwaysOriginal)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        imageView.contentMode = .right
        return imageView
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .ypGray
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        addSubview()
        activateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        categoryLabel.text = nil
        checkmarkImageView.isHidden = true
        lineView.isHidden = false
    }
    
    private func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .ypBackground
    }
    
    func config(category: String?) {
        categoryLabel.text = category
    }
    
    func didSelect() {
        checkmarkImageView.isHidden = false
    }
    
    func didDeselect() {
        checkmarkImageView.isHidden = true
    }
    
    func hideLineView() {
        lineView.isHidden = true
    }
    
    
    private func addSubview() {
        contentView.addSubViews(
            categoryLabel,
            checkmarkImageView,
            lineView
        )
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            categoryLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.indentationFromEdges),
            categoryLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.75),
            
            checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.indentationFromEdges),
            checkmarkImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25),
            
            lineView.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: checkmarkImageView.trailingAnchor),
            lineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
}
