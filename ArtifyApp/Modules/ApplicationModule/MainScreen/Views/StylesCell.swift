import UIKit
import SnapKit

final class StylesCell: UICollectionViewCell {
    static let identifier = "StylesCell"
    private let title = UILabel()
    private let imageView = UIImageView()
    
    public func configure(with style: StylesModel) {
        setupUI()
        title.text = style.styleName
        imageView.image = UIImage(named: style.styleImage)
    }
    
    private func setupUI() {
        self.backgroundColor = .clear
        
        
        self.addSubview(title)
        title.text = "Cyberpunk"
        title.font = .systemFont(ofSize: 16)
        
        self.addSubview(imageView)
        imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "cyberpunk_style")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        
        
        imageView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
        
        title.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.centerX.equalTo(self.snp.centerX)
        }
    }
    
    
    override var isSelected: Bool {
            didSet {
                if isSelected {
                    self.layer.shadowColor = UIColor.white.cgColor
                    self.layer.shadowOpacity = 0.8
                    self.layer.shadowRadius = 4
                } else {
                    self.layer.shadowColor = UIColor.clear.cgColor
                    self.layer.shadowOpacity = 0.3
                    self.layer.shadowRadius = 4
                }
            }
        }
}
