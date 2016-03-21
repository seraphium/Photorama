//
//  Photo.swift
//  Photorama
//
//  Created by Jackie Zhang on 16/3/21.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import Foundation

class Photo {
    let title: String
    let remoteURL : NSURL
    let photoID : String
    let dateTaken :  NSDate
    
    init(title: String, photoID: String, remoteURL: NSURL, dateTaken: NSDate) {
        self.title = title
        self.photoID = photoID
        self.remoteURL = remoteURL
        self.dateTaken = dateTaken
    }
    
}