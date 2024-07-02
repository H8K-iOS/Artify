import UIKit

final class RotatingCirclesActivityView: UIView {
    
    let circle1 = UIView(frame: CGRect(x: 20, y: 20, width: 60, height: 60))
    let circle2 = UIView(frame: CGRect(x: 120, y: 20, width: 60, height: 60))
    
    let positions: [CGRect] = [CGRect(x: 30, y: 20, width: 60, height: 60),
                               CGRect(x: 60, y: 15, width: 70, height: 70),
                               CGRect(x: 110, y: 20, width: 60, height: 60),
                               CGRect(x: 65, y: 25, width: 50, height: 50)]
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        config()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        circle1.backgroundColor = .gray.withAlphaComponent(0.5)
        circle1.layer.cornerRadius = circle1.frame.width/2
        circle1.layer.zPosition = 2
    
        circle2.backgroundColor = .darkGray.withAlphaComponent(0.5)
        circle2.layer.cornerRadius = circle1.frame.width/2
        circle2.layer.zPosition = 1
        
        self.addSubview(circle1)
        self.addSubview(circle2)
        
        
        self.animate(circle1, counter: 1)
        self.animate(circle2, counter: 3)
    }
    
    private func animate(_ circle: UIView, counter: Int) {
        var counter = counter
        
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveLinear, animations: {
            circle.frame = self.positions[counter]
            circle.layer.cornerRadius = circle.frame.width/2
            
            switch counter {
            case 1:
                if circle == self.circle1 { self.circle1.layer.zPosition = 2 }
            case 3: 
                if circle == self.circle1 { self.circle1.layer.zPosition = 0}
            default:
                print()
            }
        }) { (completed) in
            switch counter {
            case 0...2:
                counter += 1
            case 3:
                counter = 0
            default:
                print()
            }
            
            self.animate(circle, counter: counter)
        }
    }
}
