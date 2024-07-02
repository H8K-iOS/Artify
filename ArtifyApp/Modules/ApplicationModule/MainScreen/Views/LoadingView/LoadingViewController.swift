import UIKit

final class LoadingViewController: UIViewController {
    private let activityIndicator = RotatingCirclesActivityView()
    private let progressLabel = UILabel()
    private let progressView = UIProgressView(progressViewStyle: .default)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        setupActivityIndicator()
        setupProgressLabel()
        setupProgressView()
    }
    
    private func setupActivityIndicator() {
        self.view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            activityIndicator.heightAnchor.constraint(equalToConstant: 100),
            activityIndicator.widthAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    private func setupProgressLabel() {
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        progressLabel.text = "Generating your image..."
        progressLabel.textColor = .white
            progressLabel.textAlignment = .center
            
            view.addSubview(progressLabel)
            
            NSLayoutConstraint.activate([
                progressLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                progressLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 20)
            ])
        }
    
    private func setupProgressView() {
            progressView.translatesAutoresizingMaskIntoConstraints = false
            progressView.progressTintColor = .white
            
            view.addSubview(progressView)
            
            NSLayoutConstraint.activate([
                progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                progressView.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 20)
            ])
        }
    
   public func updateProgress(_ progress: Float) {
            progressView.setProgress(progress, animated: true)
        }
}
