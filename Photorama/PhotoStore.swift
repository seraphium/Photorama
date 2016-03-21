//
//  PhotoStore.swift
//  Photorama
//
//  Created by Jackie Zhang on 16/3/20.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import UIKit

enum ImageResult {
    case Success(UIImage)
    case Failure(ErrorType)
}

enum PhotoError:ErrorType {
    case ImageCreationError
}

class PhotoStore {
    let session: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
    }()
    
    func processRecentPhotosRequest(data data: NSData?, error:  NSError?) -> PhotosResult {
        guard let jsonData = data else {
            return .failure(error!)
        }
        return FlickrAPI.photosFromJSONData(jsonData)
    }
    
    func fetchRecentPhotos(completion completion:(PhotosResult) -> Void) {
        let url = FlickrAPI.recentPhotoURL()
        let request = NSURLRequest(URL: url)
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            do {
                let jsonObject = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                print (jsonObject)

            }  catch let error {
                print(error)
            }
            
            let result = self.processRecentPhotosRequest(data: data, error: error)
            completion(result)
        }
        task.resume()
    }
    
}
