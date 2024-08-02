import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let firstLaunch = UserDefaults.standard.bool(forKey: "firstLaunch")

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        setScene(with: scene)
        
        
        if firstLaunch {
            animatedTransition(viewController: MainTabBarController())

        } else {
            animatedTransition(viewController: WelcomeViewController())
            UserDefaults.standard.set(true, forKey: "firstLaunch")
        }
    }

    private func setScene(with scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        self.window?.overrideUserInterfaceStyle = .dark
        self.window?.makeKeyAndVisible()
    }
    
    private func animatedTransition(viewController: UIViewController) {
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 0.25) {
                self?.window?.layer.opacity = 0
            } completion: { [weak self] _ in
                if let tabBarController = viewController as? UITabBarController {
                    self?.window?.rootViewController = tabBarController
                } else {
                    let nav = UINavigationController(rootViewController: viewController)
                    nav.modalPresentationStyle = .fullScreen
                    self?.window?.rootViewController = nav
                }

                UIView.animate(withDuration: 0.25) { [weak self] in
                    self?.window?.layer.opacity = 1
                }
            }
        }
    }
}
