import UIKit

final class MainTabBarController: UITabBarController {
    
    //MARK: Lifecycle
     override func viewDidLoad() {
         super.viewDidLoad()
         
         setupTabBar()
         drawTabBar()
     }
}

//MARK: - Extensions
private extension MainTabBarController {
    func setupTabBar() {
        self.viewControllers = [
        generateVC(for: MainViewController(), icon: #imageLiteral(resourceName: "mainTab")),
        generateVC(for: HistoryViewController(), icon: #imageLiteral(resourceName: "historyTab")),
        generateVC(for: MainViewController(), icon: #imageLiteral(resourceName: "settingTab")),
        ]
    }
    
    func generateVC(for vc: UIViewController, icon: UIImage?) -> UIViewController {
        let vc = vc
        vc.tabBarItem.image = icon
        return vc
    }
    
    func drawTabBar() {
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        tabBar.backgroundColor = .black.withAlphaComponent(0.9)
        tabBar.tintColor = .white
    }
    //
}
