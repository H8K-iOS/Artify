//
//  Photo+CoreDataProperties.swift
//  
//
//  Created by Alexandr Alimov on 08/07/24.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }



}
