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
    
    let coreDataStack = CoreDataStack(modelName: "Photorama")
    
    let session: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
    }()
    
    func processRecentPhotosRequest(data data: NSData?, error:  NSError?) -> PhotosResult {
        guard let jsonData = data else {
            return .failure(error!)
        }
        return FlickrAPI.photosFromJSONData(jsonData, inContext:self.coreDataStack.mainQueueContext)
    }
    
    func fetchRecentPhotos(completion completion:(PhotosResult) -> Void) {
        let url = FlickrAPI.recentPhotoURL()
        let request = NSURLRequest(URL: url)
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            //debug output
            do {
                let jsonObject = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                print (jsonObject)

            }  catch let error {
                print(error)
            }
            //process photo request
            var result = self.processRecentPhotosRequest(data: data, error: error)
            if case let .success(photos) = result {
                do {
                    try self.coreDataStack.saveChanges()
                } catch let error {
                    result = .failure(error)
                }
            }
            completion(result)
        }
        task.resume()
    }
    
    func fetchImageForPhoto(photo: Photo, completion: (ImageResult) -> Void) {
        //image already downloaded
        if let image = photo.image {
            completion(.Success(image))
            return
        }
        
        let photoURL = photo.remoteURL
        let request = NSURLRequest(URL: photoURL)
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            let result = self.processImageRequest(data: data, error: error)
            if case let .Success(image) = result {
                photo.image = image
            }
            let urlResponse = response as! NSHTTPURLResponse?
            print ("status:\(urlResponse!.statusCode)")
            print ("\(urlResponse!.allHeaderFields)")
            completion(result)
        }
        task.resume()
        
    }
    
    func processImageRequest(data data: NSData?, error : NSError?) -> ImageResult {
        guard let
            imageData = data,
            image = UIImage(data: imageData) else {
                //could not create image data
                if data == nil {
                    return .Failure(error!)
                } else {
                    return .Failure(PhotoError.ImageCreationError)
                }
        }
        return .Success(image)
        
    }
}
