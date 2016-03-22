//
//  Photo.swift
//  Photorama
//
//  Created by Jackie Zhang on 16/3/21.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import UIKit

class Photo {
    let title: String
    let remoteURL : NSURL
    let photoID : String
    let dateTaken :  NSDate
    var image : UIImage!
    init(title: String, photoID: String, remoteURL: NSURL, dateTaken: NSDate) {
        self.title = title
        self.photoID = photoID
        self.remoteURL = remoteURL
        self.dateTaken = dateTaken
    }
}

extension Photo: Equatable {}

func == (lhs: Photo, rhs: Photo) -> Bool {
    return lhs.photoID == rhs.photoID
}
    