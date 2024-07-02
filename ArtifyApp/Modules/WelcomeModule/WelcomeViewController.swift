import UIKit

final class WelcomeViewController: UIViewController {
    //MARK: Constants
    private let mainLabel = UILabel()
    
    private let backgroundImage = UIImageView()
    
    private let shadowView = UIView()

    
    //MARK: Variables
    private lazy var getStartedButton = createButton(title: "Get Started", selector: #selector(getStartedButtonTapped))
    private lazy var termsTextView = createTermsTextView(for: .welcomeScreen)
    private lazy var elementImageView = createElementImageView()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        self.view.backgroundColor = .black
        setBackground()
        setViews()
        setLayouts()
        
        self.termsTextView.delegate = self
    }
    //MARK: Methods
    
    @objc private func getStartedButtonTapped() {
        self.navigationController?.pushViewController(GaleryViewController(), animated: true)
    }
}

//MARK: - Extensions
private extension WelcomeViewController {
    func setBackground() {
        self.view.addSubview(backgroundImage)
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.image = #imageLiteral(resourceName: "welcomeKitty")
        backgroundImage.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
           
            backgroundImage.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            backgroundImage.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            backgroundImage.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -20),
        
        ])
    }
    
    func setViews() {
        self.view.addSubview(mainLabel)
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.text = "Turn your words into stunning visual art"
        mainLabel.numberOfLines = 2
        mainLabel.font = .systemFont(ofSize: 34, weight: .medium)
        
        self.view.addSubview(getStartedButton)
        getStartedButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(elementImageView)
        elementImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(termsTextView)
        termsTextView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(elementImageView)
        elementImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setLayouts() {
        NSLayoutConstraint.activate([
            elementImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            elementImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            elementImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            
            termsTextView.topAnchor.constraint(equalTo: getStartedButton.bottomAnchor, constant: 16),
            termsTextView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            termsTextView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            
            getStartedButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -66),
            getStartedButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            getStartedButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            //TODO:
            getStartedButton.heightAnchor.constraint(equalToConstant: 55),
            
            mainLabel.bottomAnchor.constraint(equalTo: getStartedButton.topAnchor, constant: -24),
            mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            mainLabel.heightAnchor.constraint(equalToConstant: 82),
            
            
            elementImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            elementImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            elementImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            //TODO:
            elementImageView.heightAnchor.constraint(equalToConstant: 67),
        ])
    }
}

extension WelcomeViewController: UITextViewDelegate {
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
