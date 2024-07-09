//
//  Image+CoreDataClass.swift
//  
//
//  Created by Alexandr Alimov on 08/07/24.
//
//

import Foundation
import CoreData

@objc(Image)
public class Image: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image")
    }

    @NSManaged public var title: String?
    @NSManaged public var image: Data?
    @NSManaged public var width: Int16
    @NSManaged public var height: Int16
    
}

extension Image: Identifiable {}
