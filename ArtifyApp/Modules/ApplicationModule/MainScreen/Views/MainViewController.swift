import UIKit
import SnapKit

final class MainViewController: UIViewController {
    //MARK: Constants
    private var loadingViewController: LoadingViewController?
    private let viewModel: MainScreenViewModel
    private let artifyLogoImageView = UIImageView()
    private let promptView = PromptView()
    private let collectionViewLabel = UILabel()
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
    private let imageOrientationState = ImageOrientation.landscape
    //MARK: Variables
    private var imageStyle: String?
    //TODO: -

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
        
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Buttons Action
    @objc private func generateButtonTapped() {
        generateImage()
    }
    
    @objc private func generateRandomPromtTapped() {
        randomPrompt()
    }
    
    @objc private func qualityButtonTapped() {
        print("qualityButtonTapped")
    }
    
    @objc private func seeAllStylesButtonTapped() {
        print("seeAllStylesButtonTapped")
    }
    
    //MARK: Methods
    private func bind() {
        viewModel.onUpdate = { [weak self] in
            guard let self = self else { return }
            hideLoadingView()
            
            guard let imageModel = self.viewModel.images.first else { return }
            
            let generatedImageVC = GeneratedImageViewController(imageURL: imageModel.url, imageOrientation: imageOrientationState)
            self.present(generatedImageVC, animated: true)
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
        loadingViewController?.dismiss(animated: true)
        loadingViewController = nil
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
        
        showLoadingView()
        let promt = viewModel.makePrompt(prompt: promptText, style: imageStyle ?? "")
        viewModel.fetchImage(for: promt)
    }
    
    private func randomPrompt() {
        let randomIndex = Int.random(in: 0..<viewModel.randomPrompts.count)
        let selectedPromt = viewModel.randomPrompts[randomIndex]
        promptView.textView.text = "\(selectedPromt)"
    }
}

//MARK: - Extensions
private extension MainViewController {
    func setupView() {
        self.view.addSubview(promptView)
//        self.view.addGestureRecognizer(tapGestuer)
        self.view.addSubview(artifyLogoImageView)
        artifyLogoImageView.image = #imageLiteral(resourceName: "artifyLogo")
        artifyLogoImageView.contentMode = .scaleAspectFill
        
        promptView.generateButton.addTarget(self, action: #selector(generateRandomPromtTapped), for: .touchUpInside)
        promptView.qualityButton.addTarget(self, action: #selector(qualityButtonTapped), for: .touchUpInside)
        
        self.view.addSubview(stylesCollectionView)
        
        
        self.view.addSubview(collectionHeaderHStack)
        
        promptView.textView.text = viewModel.promtText
        
        collectionHeaderHStack.addArrangedSubview(collectionViewLabel)
        collectionViewLabel.text = "Styles"
        collectionViewLabel.font = .systemFont(ofSize: 22)
        
        collectionHeaderHStack.addArrangedSubview(seeAllStylesButton)
        self.view.addSubview(generateButton)
    }
    
    func setupLayouts() {
        artifyLogoImageView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(16)
            make.height.equalTo(25)
            make.width.equalTo(87)
        }
        
        promptView.snp.makeConstraints { make in
            make.top.equalTo(artifyLogoImageView.snp.bottom).offset(36)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(16)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-16)
        }
        
        stylesCollectionView.snp.makeConstraints { make in
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(16)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-16)
            make.top.equalTo(promptView.snp.bottom).offset(40)
            make.height.equalTo(240)
        }
        
        collectionHeaderHStack.snp.makeConstraints { make in
            make.top.equalTo(stylesCollectionView.snp.top).offset(-8)
            make.left.equalTo(stylesCollectionView.snp.left)
            make.right.equalTo(stylesCollectionView.snp.right)
        }
        
        generateButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-26)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(16)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-16)
        }
    }
}


//MARK: - Styles Collection View Extensions
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedStyle = viewModel.styles[indexPath.item]
        imageStyle = selectedStyle.styleName
        
        if let cell = collectionView.cellForItem(at: indexPath) as? StylesCell {
            cell.isSelected = true
        }
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
        let size = (self.view.frame.width/2.7)
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
}
