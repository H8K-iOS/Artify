import UIKit

final class PromptView: UIView {
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .darkGray.withAlphaComponent(0.4)
        tv.text = ""
        tv.font = .systemFont(ofSize: 18)
        tv.textColor = .lightGray
        tv.layer.cornerRadius = 15
        tv.tintColor = .darkGray
        tv.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return tv
    }()
    
    let hStack: UIStackView = {
        let hs = UIStackView()
        hs.translatesAutoresizingMaskIntoConstraints = false
        hs.axis = .horizontal
        hs.distribution = .fillEqually
        hs.spacing = 10
        return hs
    }()
    
    let qualityButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Good Quality", for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.tintColor = .white
        btn.backgroundColor = .darkGray.withAlphaComponent(0.5)
        btn.layer.cornerRadius = 15
        return btn
        
    }()
    
    
    let generateButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Inspire me", for: .normal)
        btn.setImage(#imageLiteral(resourceName: "randomIcon"), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.tintColor = .white
        btn.backgroundColor = .darkGray.withAlphaComponent(0.5)
        btn.layer.cornerRadius = 15
        return btn
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Prompt"
        label.textColor = .white
        label.font = .systemFont(ofSize: 22, weight: .medium)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        textView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(titleLabel)
        addSubview(textView)
        addSubview(hStack)
        addSubview(generateButton)
        hStack.addArrangedSubview(generateButton)
        hStack.addArrangedSubview(qualityButton)
        
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor),
            
            textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            textView.leftAnchor.constraint(equalTo: leftAnchor),
            textView.rightAnchor.constraint(equalTo: rightAnchor),
            textView.heightAnchor.constraint(equalToConstant: 140),
            
            
            hStack.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 8),
            hStack.leftAnchor.constraint(equalTo: leftAnchor),
            hStack.rightAnchor.constraint(equalTo: rightAnchor),
            hStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            generateButton.heightAnchor.constraint(equalToConstant: 40),
            
        ])
    }
}

extension PromptView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Describe your ideas: objects, colors, places, people..." {
            textView.text = ""
            textView.textColor = .white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Describe your ideas: objects, colors, places, people..."
            textView.textColor = .lightGray
        }
    }
    //
}
