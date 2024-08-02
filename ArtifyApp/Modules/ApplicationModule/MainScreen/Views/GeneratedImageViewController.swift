import UIKit

final class GeneratedImageViewController: UIViewController {
    //MARK: Constants
    private let viewModel: DetailScreenViewModel
    private let imageURLString: String
    private let promptText: String
    private let style: String?
    private var imageRatio: ImageRatio

    private let buttonsHStack: UIStackView = {
        let hs = UIStackView()
        hs.axis = .horizontal
        hs.distribution = .equalSpacing
        hs.spacing = 4
        return hs
    }()

    
    //MARK: Variables
    private lazy var imageView = createImageView()
    
    private var heightForImage: CGFloat {
           switch imageRatio {
           case .square:
               return view.frame.height / 2.5
           case .portrait:
               return view.frame.height / 1.5
           case .landscape:
               return view.frame.height / 3.4
           }
       }
    
    private lazy var doneButton = createDoneButton(selector: #selector(doneButtonTapped))
    
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
    init(imageURL: String, promptText: String, style: String?, imageRatio: ImageRatio,
         viewModel: DetailScreenViewModel = DetailScreenViewModel()) {
        self.viewModel = viewModel
        self.promptText = promptText
        self.style = style
        self.imageURLString = imageURL
        self.imageRatio = imageRatio
        
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
    
    deinit {
        print("DEINITED")
    }
    
    //MARK: Methods
    //TODO: -
    private func loadImage() {
        viewModel.loadImage(imageUrl: imageURLString) { [weak self] image in
                DispatchQueue.main.async {
                    if let image = image {
                        self?.imageView.image = image
                        let height = Int16(self?.heightForImage ?? 0)
                        let prompt = self?.promptText ?? ""
                        let style = self?.style ?? "Random"
                        let ratio = self?.imageRatio as? String?
                        self?.viewModel.saveImageWithCoreData(prompt: prompt, image: image, ratio: ratio ?? "Square", style: style, height: height)
                    } else {
                        print("Failed to load image from url: \(String(describing: self?.imageURLString))")
                    }
                }
            }
    }
    
    @objc private func downloadButtonTapped() {
        guard let image = imageView.image else { return }
        self.viewModel.saveImage(image: image) { error in
            if let error {
                AlertManager.showUnableToSavePhotoAlert(on: self, with: error)
            } else {
                AlertManager.showSuccsessToSavePhoto(on: self)
            }
        }
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
        self.imageView.backgroundColor = .darkGray.withAlphaComponent(0.1)
        
        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(heightForImage)
        }
    }
    //
}
