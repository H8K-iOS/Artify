import UIKit
final class StylesCell: UICollectionViewCell {
    static let identifier = "StylesCell"
    private let title = UILabel()
    
    public func configure() {
        setupUI()
    }
    
    private func setupUI() {
        self.backgroundColor = .blue
        self.layer.cornerRadius = 16
        
        self.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Cyberpunk"
        title.font = .systemFont(ofSize: 16)
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 8),
            title.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    //
}
