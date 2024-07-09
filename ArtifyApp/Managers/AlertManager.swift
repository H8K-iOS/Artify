import UIKit

final class AlertManager {

    private static func showAlert(on vc: UIViewController,
                           title: String,
                           message: String?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        vc.present(alert, animated: true)
    }
    
}

//MARK: - Extensions
    //MARK: - MainViewController
extension AlertManager {
    public static func showEmptyPromptAlert(on vc: UIViewController) {
        self.showAlert(on: vc, title: "Emty prompt", message: "To generate a photo, u have to describe your ideas")
    }
    
    public static func showEmptyPromptAlert(on vc: UIViewController, with error: Error) {
        self.showAlert(on: vc, title: "Invalid prompt", message: "\(error.localizedDescription)")
    }
}
    //MARK: - GeneratedImageViewController
extension AlertManager {
    public static func showUnableToSavePhotoAlert(on vc: UIViewController) {
        self.showAlert(on: vc, title: "Unable to save photo", message: "Try to save your photo later, from Prompts History")
    }
    
    public static func showUnableToSavePhotoAlert(on vc: UIViewController, with error: Error) {
        self.showAlert(on: vc, title: "Unable to save photo", message: "Try to save your photo later, from Prompts History\nError: \(error.localizedDescription)")
    }
    
    public static func showSuccsessToSavePhoto(on vc: UIViewController) {
        self.showAlert(on: vc, title: "Succsess", message: "Photo has been added to the gallery")
    }
}
    //MARK: - 111

