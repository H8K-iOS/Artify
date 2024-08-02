import UIKit
import SnapKit

final class MainViewController: UIViewController {
    //MARK: Constants
    private var loadingViewController: LoadingViewController?
    private let viewModel: MainScreenViewModel
    private let artifyLogoImageView = UIImageView()
    private let promptView = PromptView()
    private let collectionViewLabel = UILabel()
    private let noInternetLabel = UIImageView()
    private let stylesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.register(StylesCell.self, forCellWithReuseIdentifier: StylesCell.identifier)
        return cv
    }()
    private let seeAllStylesButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("See All", for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 18)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(seeAllStylesButtonTapped), for: .touchUpInside)
        return btn
    }()
    private let collectionHeaderHStack: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        return sv
    }()
    
    //MARK: Variables
    private lazy var tapGest: UITapGestureRecognizer = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        return tapGesture
    }()
    
   
    
    private lazy var generateButton = createButton(title: "Generate", selector: #selector(generateButtonTapped))
    
    //MARK: Lifecycle
    init(viewModel: MainScreenViewModel = MainScreenViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        setupView()
        setupLayouts()
        
        stylesCollectionView.delegate = self
        stylesCollectionView.dataSource = self
        showContextMenu()
        bind()
        
        checkInternetConnection()
        NotificationCenter.default.addObserver(self, selector: #selector(networkChanged), name: .networkChanged, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Buttons Action
    @objc private func networkChanged() {
        self.checkInternetConnection()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func generateButtonTapped() {
        generateImage()
    }
    
    @objc private func generateRandomPromtTapped() {
        promptView.textView.text = viewModel.createRandomPrompt()
    }
    
    @objc private func qualityButtonTapped() {
        showContextMenu()
    }
    
    @objc private func seeAllStylesButtonTapped() {
        print("seeAllStylesButtonTapped")
    }
    
    //MARK: Methods
    private func showContextMenu() {
        let squareRatio = UIAction(title: " Square (1:1)", image: UIImage(systemName: "square")) { _ in
            self.promptView.ratioButton.setTitle(" Square", for: .normal)
            self.promptView.ratioButton.setImage(UIImage(systemName: "square"), for: .normal)
            self.viewModel.imageRatioState = .square
        }
        
        let portaitRatio = UIAction(title: " Portait (3:4)", image: UIImage(systemName: "rectangle.portrait")) { _ in
            self.promptView.ratioButton.setTitle(" Portrait", for: .normal)
            self.promptView.ratioButton.setImage(UIImage(systemName: "rectangle.portrait"), for: .normal)
            self.viewModel.imageRatioState = .portrait
        }
        
        let landscapeRatio = UIAction(title: " Landscape (4:3)", image: UIImage(systemName: "rectangle")) { _ in
            self.promptView.ratioButton.setTitle(" Landscape", for: .normal)
            self.promptView.ratioButton.setImage(UIImage(systemName: "rectangle"), for: .normal)
            self.viewModel.imageRatioState = .landscape
        }
        
        let menu = UIMenu(title: "", children: [squareRatio, portaitRatio, landscapeRatio])
        promptView.ratioButton.menu = menu
        promptView.ratioButton.showsMenuAsPrimaryAction = true
    }
    
    private func bind() {
        viewModel.onUpdate = { [weak self] in
            guard let self = self else { return }
            hideLoadingView()
            
            guard let imageModel = self.viewModel.images.first else { return }
            DispatchQueue.main.async {
                let generatedImageVC = GeneratedImageViewController(imageURL: imageModel.url,
                                                                    promptText: self.viewModel.promptText ?? "",
                                                                    style: self.viewModel.imageStyle,
                                                                    imageRatio: self.viewModel.imageRatioState)
                self.present(generatedImageVC, animated: true)
            }
        }
    }
    
    private func showLoadingView() {
        let loadingVC = LoadingViewController()
        loadingVC.modalTransitionStyle = .crossDissolve
        loadingVC.modalPresentationStyle = .overFullScreen
        present(loadingVC, animated: true)
        loadingViewController = loadingVC
    }
    
    private func hideLoadingView() {
        DispatchQueue.main.async {[weak self] in
            self?.loadingViewController?.dismiss(animated: true)
            self?.loadingViewController = nil
        }
    }
    
    private func updatingProgress(_ progress: Float) {
        loadingViewController?.updateProgress(progress)
    }
    
    private func generateImage() {
        guard let promptText = promptView.textView.text,
              !promptText.isEmpty,
              promptText != viewModel.promtText else {
            AlertManager.showEmptyPromptAlert(on: self)
            return
        }
        self.viewModel.promptText = promptText
        
        let promt = viewModel.makePrompt(prompt: promptText, style: self.viewModel.imageStyle ?? "")
        viewModel.fetchImage(prompt: promt) { [weak self] in
            self?.showLoadingView()
        }
    }
    
    private func checkInternetConnection() {
        self.viewModel.checkInternetConnection { [weak self] error in
            if error != nil {
                DispatchQueue.main.async {
                    self?.noInternetLabel.isHidden = true
                    self?.generateButton.isEnabled = true
                    self?.generateButton.setTitleColor(.black, for: .normal)
                    self?.generateButton.backgroundColor = .white
                }
            } else {
                DispatchQueue.main.async {
                    self?.noInternetLabel.isHidden = false
                    self?.generateButton.setTitleColor(.gray, for: .normal)
                    self?.generateButton.backgroundColor = .darkGray.withAlphaComponent(0.5)
                    self?.generateButton.isEnabled = false
                }
            }
            
            DispatchQueue.main.async {
                self?.updateViewConstraints()
            }

        }
    }
}

//MARK: - Extensions
private extension MainViewController {
    func setupView() {
            self.navigationController?.navigationBar.isHidden = true
            self.view.addSubview(promptView)
            self.view.addSubview(artifyLogoImageView)
            artifyLogoImageView.image = #imageLiteral(resourceName: "artifyLogo")
            artifyLogoImageView.contentMode = .scaleAspectFill
            
            promptView.generateButton.addTarget(self, action: #selector(generateRandomPromtTapped), for: .touchUpInside)
            promptView.ratioButton.addTarget(self, action: #selector(qualityButtonTapped), for: .touchUpInside)
            
            self.view.addGestureRecognizer(tapGest)
            self.view.addSubview(stylesCollectionView)
            
            self.view.addSubview(collectionHeaderHStack)
            
            promptView.textView.text = viewModel.promtText
            
            collectionHeaderHStack.addArrangedSubview(collectionViewLabel)
            collectionViewLabel.text = "Styles"
            collectionViewLabel.font = .systemFont(ofSize: 22)
            
            collectionHeaderHStack.addArrangedSubview(seeAllStylesButton)
            self.view.addSubview(generateButton)
            self.view.addSubview(noInternetLabel)
            noInternetLabel.isHidden = true
            noInternetLabel.image = #imageLiteral(resourceName: "noIntternetToast")
            noInternetLabel.contentMode = .scaleAspectFill
        }
    
    func setupLayouts() {
            artifyLogoImageView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(56)
                make.left.equalToSuperview().offset(16)
                make.height.equalTo(25)
                make.width.equalTo(87)
            }
            
            noInternetLabel.snp.makeConstraints { make in
                make.top.equalTo(artifyLogoImageView.snp.bottom).offset(16)
                make.left.equalToSuperview().offset(16)
                make.right.equalToSuperview().inset(16)
                make.height.equalTo(47)
            }
            
            promptView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(16)
                make.right.equalToSuperview().offset(-16)
 
                if noInternetLabel.isHidden {
                    make.top.equalTo(artifyLogoImageView.snp.bottom).offset(30)
                } else {
                    make.top.equalTo(noInternetLabel.snp.bottom).offset(20)
                }
            }
            
            collectionHeaderHStack.snp.makeConstraints { make in
                make.top.equalTo(promptView.snp.bottom).offset(32)
                make.left.equalToSuperview().offset(16)
                make.right.equalToSuperview().offset(-16)
            }
            
            stylesCollectionView.snp.makeConstraints { make in
                make.top.equalTo(collectionHeaderHStack.snp.bottom).inset(40)
                make.left.equalToSuperview().offset(13)
                make.right.equalToSuperview()
                make.height.equalTo(230)
            }
            
            generateButton.snp.makeConstraints { make in
                make.bottom.equalToSuperview().inset(110)
                make.left.equalToSuperview().offset(16)
                make.right.equalToSuperview().offset(-16)
            }
        }
}

//MARK: - Styles Collection View Extensions
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedStyle = viewModel.styles[indexPath.item]
        self.viewModel.imageStyle = selectedStyle.styleName
        
        if let cell = collectionView.cellForItem(at: indexPath) as? StylesCell {
            cell.isSelected = true
        }
        
        viewModel.selectedIndexPath = indexPath
        self.stylesCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        self.stylesCollectionView.performBatchUpdates(nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? StylesCell {
            cell.isSelected = false
        }
        viewModel.selectedStyle = nil
        self.stylesCollectionView.performBatchUpdates(nil)
    }
}



extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.styles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StylesCell.identifier, for: indexPath) as? StylesCell else {
            return UICollectionViewCell()
        }
        
        let style = viewModel.styles[indexPath.item]
        cell.configure(with: style)
        
        return cell
    }
    
    
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath == viewModel.selectedIndexPath {
            let size = (self.view.frame.width/2.5)
            return CGSize(width: size, height: size)
        } else {
            let size = (self.view.frame.width/2.8)
            return CGSize(width: size, height: size)
        }
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
}
