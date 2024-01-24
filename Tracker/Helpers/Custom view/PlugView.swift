import UIKit

final class PlugView: UIStackView {
    
    private lazy var plugImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var plugLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .ypBlack
        label.font = UIFont.ypMediumSize12
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    init(frame: CGRect, titleLabel: String, image: UIImage) {
        super.init(frame: frame)
        setupView()
        addSubview()
        plugLabel.text = titleLabel
        plugImageView.image = image
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(title: String, image: UIImage?) {
        plugLabel.text = title
        plugImageView.image = image
    }
    
    private func setupView() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        distribution = .fill
        axis = .vertical
        spacing = 8
        
    }
    
    private func addSubview() {
        addArrangedSubview(plugImageView)
        addArrangedSubview(plugLabel)
    }
}

