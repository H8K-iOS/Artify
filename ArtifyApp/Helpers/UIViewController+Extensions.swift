import UIKit
enum TermsState {
    case welcomeScreen
    case subscriptionScreen
}

extension UIViewController {
    func createButton(title: String, selector: Selector) -> UIButton{
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .white
        
        btn.layer.cornerRadius = 20
        btn.heightAnchor.constraint(equalToConstant: 55).isActive = true
        btn.addTarget(self, action: selector, for: .touchUpInside)
        return btn
    }
    
    
    
    func createTermsTextView(for state: TermsState) -> UITextView {
        var attributedString = NSMutableAttributedString()
        switch state {
            
        case .welcomeScreen:
            attributedString = NSMutableAttributedString(string: "By tapping on GET STARTED, you agree \n to our Terms and Privacy Policy")
        case .subscriptionScreen:
            attributedString = NSMutableAttributedString(string: "Cancel anytime. Terms and Privacy Policy")
        }
            
        let termsRange = (attributedString.string as NSString).range(of: "Terms")
        attributedString.addAttribute(.link, value: "terms://Terms", range: termsRange)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: termsRange)

        let privacyRange = (attributedString.string as NSString).range(of: "Privacy Policy")
        attributedString.addAttribute(.link, value: "privacy://PrivacyPolicy", range: privacyRange)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: privacyRange)
        
        let tv = UITextView()
        tv.linkTextAttributes = [.foregroundColor: UIColor.gray]
        tv.attributedText = attributedString
        tv.backgroundColor = .clear
        tv.isSelectable = true
        tv.isEditable = false
        tv.isScrollEnabled = false
        tv.textColor = .lightGray.withAlphaComponent(1)
        tv.delaysContentTouches = false
        tv.font = .systemFont(ofSize: 14)
        tv.textAlignment = .center
        
        return tv
    }
}


//MARK: - WelcomeScreen
extension WelcomeViewController {
    
    func createElementImageView() -> UIView {
        let viewW = UIView()
        viewW.translatesAutoresizingMaskIntoConstraints = false
        
        let backView = UIView()
        backView.translatesAutoresizingMaskIntoConstraints = false
        backView.backgroundColor = UIColor(white: 0.9, alpha: 0.7)
        backView.layer.cornerRadius = 20
        backView.layer.masksToBounds = true
        
        
        let innerView = UIView()
        innerView.translatesAutoresizingMaskIntoConstraints = false
        innerView.backgroundColor = UIColor.white
        innerView.layer.cornerRadius = 12
        innerView.layer.masksToBounds = true
        

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "a standing cat wearing hoodie|"
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20)
        
        backView.addSubview(innerView)
        viewW.addSubview(backView)
        viewW.addSubview(label)
        
        NSLayoutConstraint.activate([
    
            backView.leadingAnchor.constraint(equalTo: viewW.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: viewW.trailingAnchor),
            backView.topAnchor.constraint(equalTo: viewW.topAnchor),
            backView.bottomAnchor.constraint(equalTo: viewW.bottomAnchor),
            backView.heightAnchor.constraint(equalToConstant: 44),
            
            innerView.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 8),
            innerView.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -8),
            innerView.topAnchor.constraint(equalTo: backView.topAnchor, constant: 8),
            innerView.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -8),
            
            label.leftAnchor.constraint(equalTo: innerView.leftAnchor, constant: 16),
            label.rightAnchor.constraint(equalTo: innerView.rightAnchor, constant: -16),
            label.centerYAnchor.constraint(equalTo: innerView.centerYAnchor)
        ])
        
        return viewW
    }
    
}

extension SubscribeViewController {
    func createVStack() -> UIStackView {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 15
        sv.alignment = .leading
        return sv
    }
    
    func createFeaturesLabel(title: String) -> UILabel {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "checkmark.circle.fill")
        image.tintColor = .white
        
        let lb = UILabel()
        lb.addSubview(image)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = title
        lb.font = .systemFont(ofSize: 22, weight: .light)
        
        
        NSLayoutConstraint.activate([
            image.rightAnchor.constraint(equalTo: lb.leftAnchor, constant: -4),
            image.centerYAnchor.constraint(equalTo: lb.centerYAnchor)
        
        ])
        return lb
    }
}

//MARK: - MainViewController
extension MainViewController {
 
}

//MARK: - GeneratedImageViewController
extension GeneratedImageViewController {
    enum ButtonType {
        case info
        case download
        case regenerate
    }
    
    func createGenerateScreenButton(type: ButtonType, title: String?, image: UIImage?, selector: Selector) -> UIButton {
        let mainBtnsWidth = (self.view.frame.width/2.8)
        let btnHeight = (self.view.frame.width/6.7)
        let btn = UIButton()
        btn.titleLabel?.font = .systemFont(ofSize: 20)
        
        btn.imageView?.tintColor = .white
        btn.imageView?.backgroundColor = .clear
        btn.layer.cornerRadius = 22
        btn.heightAnchor.constraint(equalToConstant: btnHeight).isActive = true
        switch type {
            
        case .info:
            btn.widthAnchor.constraint(equalTo: btn.heightAnchor).isActive = true
            btn.backgroundColor = .gray.withAlphaComponent(0.4)
        case .regenerate:
            btn.widthAnchor.constraint(equalToConstant: mainBtnsWidth).isActive = true
            btn.backgroundColor = .gray.withAlphaComponent(0.4)
            btn.setTitleColor(.white, for: .normal)
        case .download:
            btn.widthAnchor.constraint(equalToConstant: mainBtnsWidth).isActive = true
            btn.backgroundColor = .white
            btn.setTitleColor(.black, for: .normal)
        }
        
        if let title {
            btn.setTitle(title, for: .normal)
        } else {
            btn.setTitle("", for: .normal)
        }
        
        if let image {
            btn.setImage(image, for: .normal)
        } else {
            btn.setImage(nil, for: .normal)
        }
        
        btn.addTarget(self, action: selector, for: .touchUpInside)
        return btn
    }
    
    func createDoneButton(selector: Selector) -> UIButton {
        let btn = UIButton()
        btn.setTitle("Done", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        btn.backgroundColor = .gray.withAlphaComponent(0.4)
        btn.layer.cornerRadius = 20
        
        let btnHeight = (self.view.frame.width/10)
        btn.heightAnchor.constraint(equalToConstant: btnHeight).isActive = true
        btn.widthAnchor.constraint(equalToConstant:btnHeight * 1.6).isActive = true
        
        btn.addTarget(self, action: selector, for: .touchUpInside)
        return btn
    }
    //
}
