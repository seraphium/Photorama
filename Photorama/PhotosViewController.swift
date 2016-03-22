//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Jackie Zhang on 16/3/20.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import UIKit


class PhotosViewController : UIViewController, UICollectionViewDelegate {
    
    @IBOutlet var collectionView : UICollectionView!
    var store: PhotoStore!
    let photoDataSource = PhotoDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = photoDataSource
        collectionView.delegate = self
        
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
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let photo = photoDataSource.photos[indexPath.row]
        
        //download photo which takes some time
        store.fetchImageForPhoto(photo) {
            (result) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                //the index path may changed during request start and end ,
                //so find the most recent index path
                let photoIndex = self.photoDataSource.photos.indexOf(photo)!
                let photoIndexPath = NSIndexPath(forRow: photoIndex, inSection: 0)
                
                //when request finished, only update image if still visible
                if let cell = self.collectionView.cellForItemAtIndexPath(photoIndexPath)
                as? PhotoCollectionViewCell {
                    cell.updateWithImage(photo.image)
                }
            }
        }
    }
    
}
