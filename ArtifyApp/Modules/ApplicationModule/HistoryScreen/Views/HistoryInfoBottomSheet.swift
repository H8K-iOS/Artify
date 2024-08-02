import UIKit
import SnapKit

final class HistoryInfoBottomSheetViewController: UIViewController {
    //MARK: Constants
    private let promptLabel = UILabel()
    private let infoLabel = UILabel()
    private let styleLabel = UILabel()
    private let ratioLabel = UILabel()
    private let viewModel: HistoryDetailScreenViewModel
    //MARK: Variables
    private lazy var closeButton = createBackButton(icon: UIImage(#imageLiteral(resourceName: "Close")),selector: #selector(closeButtonTapped))
    private lazy var hStack = createStackView(axis: .horizontal)
    
    //MARK: Lifecycle
    init(viewModel: HistoryDetailScreenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.1072011217, green: 0.1075766459, blue: 0.1186723337, alpha: 1)
        
        setViews()
        setLayots()
    }
    //MARK: Methods
    
    @objc func closeButtonTapped() {
        self.dismiss(animated: true)
    }
}

//MARK: - Extensions
private extension HistoryInfoBottomSheetViewController {
    func setViews() {
        self.view.addSubview(closeButton)
        self.view.addSubview(promptLabel)
        self.view.addSubview(infoLabel)
        self.view.addSubview(hStack)
        hStack.addArrangedSubview(styleLabel)
        hStack.addArrangedSubview(ratioLabel)
        
        infoLabel.text = "Info"
        infoLabel.font = .systemFont(ofSize: 24)
        
        promptLabel.attributedText = String.createInfoLabel(title: "Prompt:", value: self.viewModel.image.title ?? "")
        promptLabel.numberOfLines = 2
        
        styleLabel.attributedText = String.createInfoLabel(title: "Style:", value: self.viewModel.style ?? "Random")
        styleLabel.numberOfLines = 2
        
        ratioLabel.attributedText = String.createInfoLabel(title: "Ratio:", value: self.viewModel.ratio ?? "-")
        ratioLabel.numberOfLines = 2
    }
    
    func setLayots() {
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(34)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
        }
        
        promptLabel.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(22)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
        }
        
        hStack.snp.makeConstraints { make in
            make.top.equalTo(promptLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(130)
        }
    }
}
