//
//  SearchResultsManager.swift
//  CoolShots
//
//  Created by Joseph Kalash on 3/18/16.
//  Copyright © 2016 Joseph Kalash. All rights reserved.
//

import UIKit
import Alamofire

@objc protocol SearchResultsManagerDelegate {
    optional func resultsManagerDidFetchNewData(manager: SearchResultsManager)
}

class SearchResultsManager: NSObject {
    
    var images : [Image] = []
    var offset = 0
    var delegate : SearchResultsManagerDelegate!
    
    //Keep track of wether user is requesting a new search or more results of the previous search
    var lastQuery = ""
    
    //Make sure to cancel an old request before starting a new one
    //Unless it's a request for more data of the same query (paging)
    var loadingData = false
    
    //Keep a pointer to the request
    var fetchRequest : Alamofire.Request? = nil
    
    func searchForQuery(query : String?) {
        
        
        if query == lastQuery {
            //If calling for more images of the same query  and old not done, return
            if loadingData == true {return}
            //Load more images
            offset++
        }
        else {
            
            //New query
            offset = 0
            lastQuery = query!
            images.removeAll()
            self.delegate.resultsManagerDidFetchNewData?(self)
        }
        
        if query == nil || query == "" { return }
        
        loadingData = true
        
        //Cancel old one if not done
        fetchRequest?.cancel()
        
        fetchRequest = ImgurHandler.fetchImagesForQuery(query!, offset: offset) { (response) -> Void in
            
            //If error occured, don't parse
            if response?.result.error != nil { return }
            
            //Parsea
            if let value = response?.result.value as? NSDictionary {
                if let data = value.valueForKey("data") as? [NSDictionary] {
                    for record in data {
                        if let imageID = record.valueForKey("id") as? String {
                            self.images.append(Image(id: imageID))
                        }
                    }
                }
            }
            
            //Done fetching
            self.fetchRequest = nil
            self.loadingData = false
            
            //Update delegate to display new set of collection items
            self.delegate.resultsManagerDidFetchNewData?(self)
            
            //Download the images
            self.fetchImages()
        }
        
    }
    
    func fetchImages() {
        for image in images {
            if image.thumb_data == nil {
                dispatch_async(dispatch_queue_create("queue-\(image.imgid)", nil), { () -> Void in
                    let fetchurl = ImgurHandler.image_url.stringByReplacingOccurrencesOfString("%0", withString: "\(image.imgid)s")
                    if let d = NSData(contentsOfURL: NSURL(string: fetchurl)!) {
                        image.thumb_data = d
                        self.delegate.resultsManagerDidFetchNewData?(self)
                    }
                })
            }
        }
    }
    
}
