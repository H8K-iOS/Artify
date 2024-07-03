import UIKit

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
    //MARK: Variables
    private var imageStyle: String?
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
            viewModel.saveImage(url: imageModel.url, title: promptView.textView.text)
            let generatedImageVC = GeneratedImageViewController(imageURL: imageModel.url)
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
            print("promptText is empty")
            return }
        showLoadingView()
        viewModel.fetchImage(for: "(\(promptText). style: \(imageStyle ?? "")")
    }
    
    private func randomPrompt() {
        let randomIndex = Int.random(in: 0..<viewModel.randomPromts.count)
        let selectedPromt = viewModel.randomPromts[randomIndex]
        promptView.textView.text = "\(selectedPromt)"
    }
}

//MARK: - Extensions
private extension MainViewController {
    func setupView() {
        self.view.addSubview(promptView)
        promptView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(artifyLogoImageView)
        artifyLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        artifyLogoImageView.image = #imageLiteral(resourceName: "artifyLogo")
        artifyLogoImageView.contentMode = .scaleAspectFill
        
        promptView.generateButton.addTarget(self, action: #selector(generateRandomPromtTapped), for: .touchUpInside)
        promptView.qualityButton.addTarget(self, action: #selector(qualityButtonTapped), for: .touchUpInside)
        
        self.view.addSubview(stylesCollectionView)
        stylesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(collectionHeaderHStack)
        
        promptView.textView.text = viewModel.promtText
        
        collectionHeaderHStack.addArrangedSubview(collectionViewLabel)
        collectionViewLabel.text = "Styles"
        collectionViewLabel.font = .systemFont(ofSize: 22)
        
        
        collectionHeaderHStack.addArrangedSubview(seeAllStylesButton)
        
        
        self.view.addSubview(generateButton)
        generateButton.translatesAutoresizingMaskIntoConstraints = false
        
        
    }
    
    func setupLayouts() {
        NSLayoutConstraint.activate([
            artifyLogoImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            artifyLogoImageView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            artifyLogoImageView.heightAnchor.constraint(equalToConstant: 25),
            artifyLogoImageView.widthAnchor.constraint(equalToConstant: 87),
            
            promptView.topAnchor.constraint(equalTo: artifyLogoImageView.bottomAnchor, constant: 36),
            promptView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            promptView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            
            
            stylesCollectionView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            stylesCollectionView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            stylesCollectionView.topAnchor.constraint(equalTo: promptView.bottomAnchor, constant: 40),
            stylesCollectionView.heightAnchor.constraint(equalToConstant: 170),
            
//            collectionViewLabel.topAnchor.constraint(equalTo: stylesCollectionView.topAnchor, constant: -8),
//            collectionViewLabel.leftAnchor.constraint(equalTo: stylesCollectionView.leftAnchor),
            
            collectionHeaderHStack.topAnchor.constraint(equalTo: stylesCollectionView.topAnchor, constant: -8),
            collectionHeaderHStack.leftAnchor.constraint(equalTo: stylesCollectionView.leftAnchor),
            collectionHeaderHStack.rightAnchor.constraint(equalTo: stylesCollectionView.rightAnchor),
            
            generateButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -26),
            generateButton.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            generateButton.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -16),
        ])
    }
}

//MARK: - Styles Collection View Extensions
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedStyle = viewModel.styles[indexPath.item]
        imageStyle = selectedStyle
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StylesCell.identifier, for: indexPath) as? StylesCell else { return UICollectionViewCell()}
        cell.configure()
        return cell
    }
    
    
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (self.view.frame.width/3.4)
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    //
}
