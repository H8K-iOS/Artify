import UIKit
import SnapKit

final class FirstPromptView: UIView {
    private let letsCreateLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Let's create your first AI image"
        lb.textAlignment = .center
        lb.font = .systemFont(ofSize: 17)
        return lb
    }()
    
    private let emptyCollectionViewImageView: UIImageView = {
     let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "emptyView")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    public let createFirstPromptButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Create", for: .normal)
        btn.backgroundColor = .white
        btn.layer.zPosition = 1
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        btn.layer.cornerRadius = 20
        return btn
    }()
    
    private let vStack: UIStackView = {
        let vs = UIStackView()
        vs.axis = .vertical
        vs.distribution = .equalSpacing
        return vs
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

private extension FirstPromptView {
    func setupView() {
        self.addSubview(emptyCollectionViewImageView)
        self.addSubview(letsCreateLabel)
        self.addSubview(createFirstPromptButton)
        self.snp.makeConstraints { make in
            make.height.equalTo(500)
        }
        
        emptyCollectionViewImageView.snp.makeConstraints { make in
            make.top.equalTo(snp.top)
            make.left.equalTo(snp.left)
            make.right.equalTo(snp.right)
            make.height.equalTo(350)
        }
        
        letsCreateLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyCollectionViewImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        
        createFirstPromptButton.snp.makeConstraints { make in
            make.top.equalTo(letsCreateLabel.snp.bottom).offset(32)
            make.height.equalTo(54)
            make.centerX.equalToSuperview()
            make.width.equalTo(249)
        }
    }
}
