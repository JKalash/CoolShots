//
//  imgurHandler.swift
//  CoolShots
//
//  Created by Joseph Kalash on 3/18/16.
//  Copyright © 2016 Joseph Kalash. All rights reserved.
//

import UIKit
import Alamofire

class ImgurHandler: NSObject {
    
    static let base_api_url = "https://api.imgur.com/3/"
    static let client_id = "7afdbb643a40caf"
    static let client_secret = "87248c9baa129d8de145073e1bc0457d43d12642"
    
    static let headers = ["Authorization" : "CLIENT-ID \(client_id)"]
    static let search_url = base_api_url + "gallery/search/%0/?q="
    static let image_url = "http://i.imgur.com/%0.jpg"
    
    
    static func fetchImagesForQuery(query: String, offset : Int, callback: (Response<AnyObject, NSError>?) -> Void) -> Alamofire.Request? {
        
        let escapedQuery = query.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        if escapedQuery == nil { callback(nil); return nil}
        
        let constructedURL = search_url.stringByReplacingOccurrencesOfString("%0", withString: "\(offset)") + escapedQuery!
        
        return Alamofire.request(.GET, constructedURL, headers: headers)
            .responseJSON { response in callback(response) }
    }
    
    
    static func fetchFullImageWithProgress(imgID : String, progressCallback: (Int64, Int64, Int64) -> Void, responseCallback: (NSURLRequest?, NSHTTPURLResponse?, NSData?, NSURL?, NSError?) -> Void) -> Alamofire.Request {

        let constructed_url = image_url.stringByReplacingOccurrencesOfString("%0", withString: imgID)
        
        var imageURL : NSURL?
        
        return Alamofire.download(.GET, constructed_url, destination: { (temporaryURL, response) in
            let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
            let pathComponent = response.suggestedFilename
            
            imageURL = directoryURL.URLByAppendingPathComponent(pathComponent!)
            return imageURL!
        })
            .progress { bytesRead, totalBytesRead, totalBytesExpectedToRead in
                progressCallback(bytesRead, totalBytesRead, totalBytesExpectedToRead)
            }
            .response { u, h, d, e in
                responseCallback(u, h, d, imageURL, e)
            }
        
    }
    
    static func downloadsDirectoryPath() -> NSURL {
        let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        return directoryURL
    }
    
}
