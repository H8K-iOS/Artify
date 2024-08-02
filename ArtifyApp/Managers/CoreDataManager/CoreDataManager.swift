import UIKit
import CoreData


final class CoreDataManager: NSObject {
    private let identifier = "Image"
    
    public static let shared = CoreDataManager()
    
    private override init() {}
    
    private var appDelegate: AppDelegate {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        
        return delegate
    }
    
    private var context: NSManagedObjectContext {
        let context = appDelegate.persistentContainer.viewContext
        guard context != nil else {
            fatalError("context nil")
        }
        return context
    }
    
    //MARK: - Add
    
    public func addImage(prompt: String, image: UIImage, style: String?, ratio: String?, height: Int16) {
        guard let imageEntityDescr = NSEntityDescription.entity(forEntityName: identifier, in: context) else {
            fatalError("no entity descript")
        }
        
        let imageData = image.pngData()
        let newImage = Image(entity: imageEntityDescr, insertInto: context)
        
        newImage.image = imageData
        newImage.title = prompt
        newImage.style = style
        newImage.ratio = ratio
        newImage.height = height

        appDelegate.saveContext()
        
        NotificationCenter.default.post(name: .saveImage, object: nil)
    }
    
    //MARK: - Fetch
    public func fetchImages(completion: @escaping([Image]) -> Void) {
        let fetchReq = NSFetchRequest<Image>(entityName: identifier)
        
        do {
            let result = try context.fetch(fetchReq)
           completion(result)
        } catch {
            print("failed fetch")
            completion([])
        }
    }
}

extension Notification.Name {
    static let saveImage = Notification.Name("saveImage")
}

