import UIKit
import CoreData

final public class CoreDataManager: NSObject {
    private let identifier = "Photo"
    
    public static let shared = CoreDataManager()
    
    private override init() {}
    
    private var appDelegate: AppDelegate {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unable to retrieve AppDelegate")
        }
        return delegate
    }
    
    private var context: NSManagedObjectContext {
        let context = appDelegate.persistentContainer.viewContext
        guard context != nil else {
            fatalError("NSManagedObjectContext is nil")
        }
        return context
    }
    
    // MARK: - Create
    public func createPhoto(_ id: Int16, imageUrl: String?, title: String) {
        guard let photoEntityDescription = NSEntityDescription.entity(forEntityName: identifier, in: context) else {
            fatalError("Could not find entity description")
        }
        let photo = Photo(entity: photoEntityDescription, insertInto: context)
        photo.id = id
        photo.url = imageUrl
        photo.title = title
        
        appDelegate.saveContext()
    }
    
    // MARK: - Read
    public func fetchPhotos() -> [Photo]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: identifier)
        do {
            return try context.fetch(fetchRequest) as? [Photo]
        } catch {
            print("Failed to fetch photos: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: Photo by id
    public func fetchPhoto(_ id: Int16) -> Photo? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: identifier)
        do {
            let photos = try context.fetch(fetchRequest) as? [Photo]
            return photos?.first(where: { $0.id == id })
        } catch {
            print("Failed to fetch photo: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: - Update
    public func updatePhoto(with id: Int16, newUrl: String?) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: identifier)
        do {
            guard let photos = try context.fetch(fetchRequest) as? [Photo],
                  let photo = photos.first(where: { $0.id == id }) else { return }
            
            photo.url = newUrl
            appDelegate.saveContext()
        } catch {
            print("Failed to update photo: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Delete
    public func deletePhotos() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: identifier)
        do {
            let photos = try context.fetch(fetchRequest) as? [Photo]
            photos?.forEach { context.delete($0) }
            appDelegate.saveContext()
        } catch {
            print("Failed to delete photos: \(error.localizedDescription)")
        }
    }
    
    public func deletePhoto(with id: Int16) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: identifier)
        do {
            guard let photos = try context.fetch(fetchRequest) as? [Photo],
                  let photo = photos.first(where: { $0.id == id }) else { return }
            context.delete(photo)
            appDelegate.saveContext()
        } catch {
            print("Failed to delete photo: \(error.localizedDescription)")
        }
    }
}
