//
//  PhotoDataSource.swift
//  Photorama
//
//  Created by Jackie Zhang on 16/3/22.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import UIKit

class PhotoDataSource : NSObject, UICollectionViewDataSource {
    var photos = [Photo]()
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let identifier = "UICollectionViewCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath)
            as! PhotoCollectionViewCell
        let photo = photos[indexPath.row]
        cell.updateImage(photo.image)
        return cell
    }
    
}
