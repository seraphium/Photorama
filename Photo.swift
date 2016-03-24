//
//  Photo.swift
//  Photorama
//
//  Created by Jackie Zhang on 16/3/22.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//


import CoreData
import UIKit

class Photo: NSManagedObject {
    var image: UIImage?
    override func awakeFromInsert() {
        super.awakeFromInsert()
        //initalization of properties
        title = ""
        photoID = ""
        remoteURL = NSURL()
        photoKey = NSUUID().UUIDString
        dateTaken = NSDate()
    }
    
    func addTagObject(tag: NSManagedObject) {
        let currentTags = mutableSetValueForKey("tags")
        currentTags.addObject(tag)
        
    }
    
    func removeTagObject(tag: NSManagedObject) {
        let currentTags = mutableSetValueForKey("tags")
        currentTags.removeObject(tag)
        
    }
}
