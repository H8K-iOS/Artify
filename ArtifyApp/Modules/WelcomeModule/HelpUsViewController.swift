import UIKit

final class HelpUsViewController: UIViewController {
    //MARK: Constants
    private let backgroundImage = UIImageView()
    private let ratingImageView = UIImageView()
    private let mainLabel = UILabel()
    
    //MARK: Variables
    private lazy var continueButton = createButton(title: "Continue", selector: #selector(continueButtonTapped))
    
    //MARK: Lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .black
        setupBackground()
        setupViews()
        setupLayots()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    //MARK: Methods
    
    @objc private func continueButtonTapped() {
        navigationController?.pushViewController(SubscribeViewController(), animated: true)
    }
}

//MARK: - Extensions
private extension HelpUsViewController {
    func setupBackground() {
        self.view.addSubview(backgroundImage)
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.image = #imageLiteral(resourceName: "galleryScreen")
        backgroundImage.alpha = 0.4
        
        NSLayoutConstraint.activate([
            backgroundImage.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            backgroundImage.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            backgroundImage.topAnchor.constraint(equalTo: self.view.topAnchor),
            backgroundImage.heightAnchor.constraint(equalToConstant: 640)
        ])
    }
    
    func setupViews() {
        self.view.addSubview(continueButton)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(mainLabel)
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.text = "Help us make AI more accessible"
        mainLabel.numberOfLines = 2
        mainLabel.font = .systemFont(ofSize: 34, weight: .medium)
        
        self.view.addSubview(ratingImageView)
        ratingImageView.translatesAutoresizingMaskIntoConstraints = false
        ratingImageView.image = #imageLiteral(resourceName: "ratingView")
        ratingImageView.layer.cornerRadius = 35
        ratingImageView.clipsToBounds = true
    }
    
    func setupLayots() {
        NSLayoutConstraint.activate([
            ratingImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            ratingImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -40),
            ratingImageView.heightAnchor.constraint(equalToConstant: 298),
            ratingImageView.widthAnchor.constraint(equalToConstant: 329),
            
            mainLabel.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -24),
            mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            
            continueButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -66),
            continueButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            continueButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            continueButton.heightAnchor.constraint(equalToConstant: 55),
            
        ])
    }
    //
}
