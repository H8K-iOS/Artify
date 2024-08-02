import UIKit
import SnapKit

final class HistoryDetailViewController: UIViewController {
    //MARK: Constants
    
    private let buttonsHStack: UIStackView = {
        let hs = UIStackView()
        hs.axis = .horizontal
        hs.distribution = .equalSpacing
        hs.spacing = 4
        return hs
    }()
    
    private let viewModel: HistoryDetailScreenViewModel
    
    //MARK: Variables
    private lazy var backButton = createBackButton(selector: #selector(backButtonTapped))
    private lazy var regenerateButton = createGenerateScreenButton(type: .download,
                                                                 title: "Regenerate",
                                                                 image: nil,
                                                                 selector: #selector(regenerateButtonTapped))
    private lazy var usePromptButton = createGenerateScreenButton(type: .regenerate,
                                                                   title: "Use Prompt",
                                                                   image: nil,
                                                                   selector: #selector(usePromptButtonTapped))
    private lazy var infoButton = createGenerateScreenButton(type: .info,
                                                             title: nil,
                                                             image: UIImage(systemName: "info.circle"),
                                                             selector: #selector(infoButtonTapped))
    private lazy var imageView = createImageView()
    //MARK: Lifecycle
    init(viewModel: HistoryDetailScreenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        setViews()
        setLayouts()
        setImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: Methods
    
    @objc private func backButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc private func regenerateButtonTapped() {
        print("regenerateButtonTapped")
    }
    
    @objc private func infoButtonTapped() {
        let vc = HistoryInfoBottomSheetViewController(viewModel: viewModel)
        vc.isModalInPresentation = true
        
        if let sheet = vc.sheetPresentationController {
            sheet.preferredCornerRadius = 35
            sheet.detents = [.custom(resolver: { context in
                0.25 * context.maximumDetentValue
            })]
        } else {
            present(vc, animated: true)
        }
        present(vc, animated: true)
    }
    
    @objc private func usePromptButtonTapped() {
        
    }
}

//MARK: - Extensions
private extension HistoryDetailViewController {
    func setViews() {
        self.view.addSubview(imageView)
        self.view.addSubview(backButton)
        self.view.addSubview(buttonsHStack)
        buttonsHStack.addArrangedSubview(infoButton)
        buttonsHStack.addArrangedSubview(usePromptButton)
        buttonsHStack.addArrangedSubview(regenerateButton)
    }
    
    func setLayouts() {
        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().inset(8)
            make.height.equalTo(self.viewModel.height)
        }
        
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(69)
            make.height.width.equalTo(33)
        }
        
        buttonsHStack.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(44)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
        }
    }
    
    func setImage() {
        let image = UIImage(data: self.viewModel.imageData)
        self.imageView.image = image
    }
    
}
