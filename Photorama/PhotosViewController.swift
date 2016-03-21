//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Jackie Zhang on 16/3/20.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import UIKit


class PhotosViewController : UIViewController {
    
    @IBOutlet var imageView : UIImageView!
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        store.fetchRecentPhotos() {
            (photosResult) -> Void in
            
            switch(photosResult) {
            case let .success(photos) :
                print("successfully found \(photos.count) recent photos")
                if let firstPhoto = photos.first {
                    self.store.fetchImageForPhoto(firstPhoto) {
                        (imageResult) -> Void in
                        switch imageResult {
                        case let .Success(image):
                            NSOperationQueue.mainQueue().addOperationWithBlock({
                                self.imageView.image = image
                            })
                        case let .Failure(error):
                            print ("Error downloading image :\(error)")
                        }
                    }
                }
            case let .failure(error) :
                print("Error fetching recent photos: \(error)")
            }
        }
    }
}
