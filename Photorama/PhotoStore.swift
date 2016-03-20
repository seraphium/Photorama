//
//  PhotoStore.swift
//  Photorama
//
//  Created by Jackie Zhang on 16/3/20.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import Foundation

class PhotoStore {
    let session: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
    }()
    
    func fetchRecentPhotos() {
        let url = FlickrAPI.recentPhotoURL()
        let request = NSURLRequest(URL: url)
        let task = session.dataTaskWithRequest(request, completionHandler: {
            (data, response, error) -> Void in
            if let jsonData = data {
                if let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) {
                    print (jsonString)
                }
            }
            else if let requestError = error {
                print ("error fetching photos : \(requestError)")
            } else {
                print ("unexpected error happened with request")
            }

        })
        task.resume()
    }
    
}
