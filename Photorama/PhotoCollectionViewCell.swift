//
//  PhotoCollectionViewCell.swift
//  Photorama
//
//  Created by Jackie Zhang on 16/3/22.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell : UICollectionViewCell {
    @IBOutlet var imageView :UIImageView!
    @IBOutlet var spinner :UIActivityIndicatorView!
 
    func updateImage(image: UIImage?) {
        if let imageToDisplay = image {
            spinner.stopAnimating()
            imageView.image = imageToDisplay
        } else {
            spinner.startAnimating()
            imageView.image = nil
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateImage(nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        updateImage(nil)
    }
}
