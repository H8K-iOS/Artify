import UIKit
import SnapKit

final class HistoryCell: UICollectionViewCell {
    static let identifier = "RecentCreationCell"
    
    private let imageView = UIImageView()
    
    public func configure(with image: UIImage) {
        setupUI()
        self.imageView.image = image
    }
}

private extension HistoryCell {
    func setupUI() {
        self.addSubview(imageView)
        imageView.snp.makeConstraints {$0.edges.equalToSuperview()}
    }
}
