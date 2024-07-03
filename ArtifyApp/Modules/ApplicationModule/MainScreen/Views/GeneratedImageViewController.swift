import UIKit

final class GeneratedImageViewController: UIViewController {
    //MARK: Constants
    private let viewModel: DetailScreenViewModel
    private let imageURLString: String
    private let imageView = UIImageView()
    private let buttonsHStack: UIStackView = {
        let hs = UIStackView()
        hs.axis = .horizontal
        hs.distribution = .equalSpacing
        hs.spacing = 4
        return hs
    }()
    private lazy var doneButton = createDoneButton(selector: #selector(doneButtonTapped))
    

    
    //MARK: Variables
    private lazy var downloadButton = createGenerateScreenButton(type: .download,
                                                                 title: "Download",
                                                                 image: nil,
                                                                 selector: #selector(downloadButtonTapped))
    private lazy var regenerateButton = createGenerateScreenButton(type: .regenerate,
                                                                   title: "Regenerate",
                                                                   image: nil,
                                                                   selector: #selector(regenerateButtonTapped))
    private lazy var infoButton = createGenerateScreenButton(type: .info,
                                                             title: nil,
                                                             image: UIImage(systemName: "info.circle"),
                                                             selector: #selector(infoButtonTapped))
    
    //MARK: Lifecycle
    init(imageURL: String,
         viewModel: DetailScreenViewModel = DetailScreenViewModel()) {
        self.viewModel = viewModel
        self.imageURLString = imageURL
        super.init(nibName: nil, bundle: nil)
        
        self.modalPresentationStyle = .fullScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .black
        setupViews()
        setupLayots()
        setupImageView()
        loadImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: Methods
    private func loadImage() {
        viewModel.loadImage(imageUrl: imageURLString) { [weak self] image in
            self?.imageView.image = image
        }
    }
    
    
    @objc private func downloadButtonTapped() {
        print("downloadButtonTapped")
    }
    
    @objc private func regenerateButtonTapped() {
        print("regenerateButtonTapped")
    }
    
    @objc private func infoButtonTapped() {
        print("infoButtonTapped")
    }
    
    @objc private func doneButtonTapped() {
        self.dismiss(animated: true)
    }
}

//MARK: - Extensions
private extension GeneratedImageViewController {
    func setupViews() {
        self.view.addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
    
        self.view.addSubview(buttonsHStack)
        buttonsHStack.translatesAutoresizingMaskIntoConstraints = false
        buttonsHStack.backgroundColor = .clear
        
        buttonsHStack.addArrangedSubview(infoButton)
        buttonsHStack.addArrangedSubview(regenerateButton)
        buttonsHStack.addArrangedSubview(downloadButton)
    
    }
    
    func setupLayots() {
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            doneButton.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -4),
            
            buttonsHStack.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            buttonsHStack.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            buttonsHStack.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -16),
        
        ])
    }
    
    func setupImageView() {
        self.view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .gray.withAlphaComponent(0.1)
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            imageView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
    }
    //
}
