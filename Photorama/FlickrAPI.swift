//
//  FlickrAPI.swift
//  Photorama
//
//  Created by Jackie Zhang on 16/3/20.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import Foundation

enum Method :String {
    case RecentPhotos = "flickr.photos.getRecent"
}

enum PhotosResult {
    case success([Photo])
    case failure(ErrorType)
}

enum FlickrError:ErrorType {
    case InvalidJsonData
}

struct FlickrAPI {
    
    private static let baseURLString = "https://api.flickr.com/services/rest"
    private static let APIKey = "a6d819499131071f158fd740860a5a88"
    
    private static let dateFormatter : NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    
    private static func flickrURL(method method: Method, parameters:[String:String]?) -> NSURL {
        
        let components = NSURLComponents (string: baseURLString)!
        var queryItems = [NSURLQueryItem]()
        let baseParams = [
            "method" : method.rawValue,
            "format" : "json",
            "nojsoncallback" : "1",
            "api_key" : APIKey]
        
        for (key, value) in baseParams {
            let item = NSURLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let item = NSURLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        components.queryItems = queryItems
        
        return components.URL!
        
    }
    
    static func recentPhotoURL() -> NSURL {
        return flickrURL(method: .RecentPhotos, parameters: ["extra":"url_h,date_taken"])
    }
    
    static func photosFromJSONData(data: NSData) -> PhotosResult {
        do {
            let jsonObject : AnyObject = try NSJSONSerialization.JSONObjectWithData(data, options: [])
            
            guard let
                jsonDictionary = jsonObject as? [NSObject:AnyObject],
                photos = jsonDictionary["photos"] as? [String:AnyObject],
                photosArray = photos["photo"] as? [[String:AnyObject]] else {
                //json structure doesn't match our expectation
                return  .failure(FlickrError.InvalidJsonData)
            }
            
            var finalPhotos = [Photo]()

            for photoJSON in photosArray {
                if let photo = photosFromJSONObject(photoJSON) {
                    finalPhotos.append(photo)
                }
            }
            
            if finalPhotos.count == 0 && photosArray.count > 0 {
                //can't parse out any photo data , maybe format changed
                return .failure(FlickrError.InvalidJsonData)
            }
            
            return .success(finalPhotos)
        } catch let error {
            return .failure(error)
        }
    }
    
    static func photosFromJSONObject(json: [String:AnyObject]) -> Photo? {
        guard let
            photoID =  json["id"] as? String,
            title = json["title"] as? String,
            dateString = json["datetaken"] as? String,
            photoURLString = json["url_h"] as? String,
            url = NSURL(string: photoURLString),
            dateTaken = dateFormatter.dateFromString(dateString)
            else {
                return nil
        }
        return Photo(title: title, photoID: photoID, remoteURL: url, dateTaken: dateTaken)
    }
}