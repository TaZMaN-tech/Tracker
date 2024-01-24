import UIKit

final class ColorCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifire = "ColorCollectionViewCell"
    
    private struct ColorCollectionViewCellConstants {
        static let viewCornerRadius: CGFloat = 9
        static let edge: CGFloat = 5
    }
    
    var cellIsSelected = false {
        didSet {
            cellIsSelected ? showBorderCell() : hideBorderCell()
        }
    }

    private lazy var colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = ColorCollectionViewCellConstants.viewCornerRadius
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
    
    private func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        layer.cornerRadius = ColorCollectionViewCellConstants.viewCornerRadius
    }
    
    func config(color: UIColor?) {
        colorView.backgroundColor = color
    }
        
    private func addSubview() {
        contentView.addSubview(colorView)
    }
    
    private func showBorderCell() {
        layer.borderWidth = 3
        layer.borderColor = colorView.backgroundColor?.withAlphaComponent(0.3).cgColor
    }
    
    private func hideBorderCell() {
        layer.borderWidth = 0
        layer.borderColor = colorView.backgroundColor?.withAlphaComponent(0.3).cgColor
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: ColorCollectionViewCellConstants.edge),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ColorCollectionViewCellConstants.edge),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -ColorCollectionViewCellConstants.edge),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -ColorCollectionViewCellConstants.edge),
        ])
    }
}
