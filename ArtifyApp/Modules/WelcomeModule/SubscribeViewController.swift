import UIKit

final class SubscribeViewController: UIViewController {
    //MARK: Constants
    private let backgroundImage = UIImageView()
    private let artifyProLogo = UIImageView()
    private let whatsIncludeLabel = UILabel()
    
    private lazy var unlimetedImageLabel = createFeaturesLabel(title: "Unlimeted image creation")
    private lazy var stylesLabel = createFeaturesLabel(title: "Acces to all styles")
    private lazy var addFreeLabel = createFeaturesLabel(title: "Ad-free experience")
    

    
    //MARK: Variables
    private lazy var restoreButton = UIBarButtonItem(title: "Restore Purchase",
                                                     style: .plain,
                                                     target: self,
                                                     action: #selector(restoreButtonTapped))
    private lazy var closeVCButton = UIBarButtonItem(image: UIImage(systemName: "xmark.circle.fill"),
                                                     style: .plain,
                                                     target: self,
                                                     action: #selector(closeViewController))
    
    private lazy var featureVStack = createVStack()
    private lazy var getPremiumButton = createButton(title: "Go Premium for $5/mo", selector:
                                                        #selector(getPremiumButtonTapped))
    private lazy var termsTextView = createTermsTextView(for: .subscriptionScreen)
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        setupNavBar()
        setupBackground()
        setViews()
        setLayouts()
        
        termsTextView.delegate = self
    }
    
    //MARK: Methods
    @objc private func getPremiumButtonTapped() {
        print("getPremiumButtonTapped")
    }
    
    @objc private func restoreButtonTapped() {
        print("restoreButtonTapped")
    }
    
    @objc private func closeViewController() {
        self.present(MainViewController(), animated: true)
    }
}

//MARK: - Extensions
private extension SubscribeViewController {
    func setupNavBar() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .gray
        navigationItem.leftBarButtonItem = restoreButton
        navigationItem.rightBarButtonItem = closeVCButton
    }
    
    func setupBackground() {
        self.view.addSubview(backgroundImage)
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.image = #imageLiteral(resourceName: "subscribeBack")
        backgroundImage.alpha = 0.4
        
        NSLayoutConstraint.activate([
            backgroundImage.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            backgroundImage.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            backgroundImage.topAnchor.constraint(equalTo: self.view.topAnchor),
            backgroundImage.heightAnchor.constraint(equalToConstant: 640)
        ])
    }
    
    func setViews() {
        self.view.addSubview(artifyProLogo)
        artifyProLogo.translatesAutoresizingMaskIntoConstraints = false
        artifyProLogo.image = #imageLiteral(resourceName: "artifyProLogo")
        artifyProLogo.contentMode = .scaleAspectFill
        
        self.view.addSubview(whatsIncludeLabel)
        whatsIncludeLabel.translatesAutoresizingMaskIntoConstraints = false
        whatsIncludeLabel.text = "What's included:"
        whatsIncludeLabel.font = .systemFont(ofSize: 26, weight: .medium)
        
        self.view.addSubview(featureVStack)
        featureVStack.translatesAutoresizingMaskIntoConstraints = false
        
        featureVStack.addArrangedSubview(unlimetedImageLabel)
        featureVStack.addArrangedSubview(stylesLabel)
        featureVStack.addArrangedSubview(addFreeLabel)
        
        self.view.addSubview(getPremiumButton)
        getPremiumButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(termsTextView)
        termsTextView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setLayouts() {
        NSLayoutConstraint.activate([
            termsTextView.topAnchor.constraint(equalTo: getPremiumButton.bottomAnchor, constant: 16),
            termsTextView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            termsTextView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
        
            artifyProLogo.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            artifyProLogo.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            artifyProLogo.heightAnchor.constraint(equalToConstant: 25),
            artifyProLogo.widthAnchor.constraint(equalToConstant: 123),
            
            whatsIncludeLabel.topAnchor.constraint(equalTo: artifyProLogo.bottomAnchor, constant: 8),
            whatsIncludeLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            
            featureVStack.topAnchor.constraint(equalTo: whatsIncludeLabel.bottomAnchor, constant: 32),
            featureVStack.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 40),
            featureVStack.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            
            getPremiumButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -66),
            getPremiumButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            getPremiumButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            getPremiumButton.heightAnchor.constraint(equalToConstant: 55),
        ])
    }
}

//MARK: - UITextViewDelegate
extension SubscribeViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.scheme == "terms" {
            self.showWebViewerController(with: "https://policies.google.com/terms?hl=en")
        } else if URL.scheme == "privacy" {
            self.showWebViewerController(with: "https://policies.google.com/privacy?hl=en-US")
        }
        
        return true
    }
    
    func showWebViewerController(with urlString: String) {
        let vc = UINavigationController(rootViewController: WebViewerController(with: urlString))
        self.present(vc, animated: true)
    }
    //
}

