import CoreData
import Foundation

@objc(Photo)
public class Photo: NSManagedObject {}

extension Photo {
    @NSManaged public var id: Int16
    @NSManaged public var url: String?
    @NSManaged public var title: String
}

extension Photo: Identifiable {}
