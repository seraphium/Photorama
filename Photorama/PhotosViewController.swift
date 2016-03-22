//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Jackie Zhang on 16/3/20.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import UIKit


class PhotosViewController : UIViewController {
    
    @IBOutlet var collectionView : UICollectionView!
    var store: PhotoStore!
    let photoDataSource = PhotoDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = photoDataSource

        store.fetchRecentPhotos() {
            (photosResult) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                switch photosResult {
                case let .success(photos):
                    print ("success found \(photos.count) recent photos")
                    self.photoDataSource.photos = photos
                case let .failure(error):
                    self.photoDataSource.photos.removeAll()
                    print ("error fetching recent photos: \(error)")
                }
                self.collectionView.reloadSections(NSIndexSet(index:0))
            }
            
        }
    }
}
