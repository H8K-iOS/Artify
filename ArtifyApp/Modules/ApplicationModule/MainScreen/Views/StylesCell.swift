import UIKit
final class StylesCell: UICollectionViewCell {
    static let identifier = "StylesCell"
    private let title = UILabel()
    private let imageView = UIImageView()
    
    public func configure() {
        setupUI()
    }
    
    private func setupUI() {
        self.backgroundColor = .clear
        
        
        self.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Cyberpunk"
        title.font = .systemFont(ofSize: 16)
        
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "cyberpunk_style")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 16
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leftAnchor.constraint(equalTo: self.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: self.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            title.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 8),
            title.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    //
}
