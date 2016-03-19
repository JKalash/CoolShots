//
//  ImageController.swift
//  CoolShots
//
//  Created by Joseph Kalash on 3/18/16.
//  Copyright © 2016 Joseph Kalash. All rights reserved.
//

import UIKit
import Alamofire

class ImageController: UIViewController {
    
    @IBOutlet weak var progressView : CoolProgressView!
    @IBOutlet weak var favButton: UIBarButtonItem!
    
    //Set by the presenting view controller
    var image : Image!
    var localFileURL : NSURL?
    var favorite = false
    
    //Keep a pointer to the request in order to cancel it in case we leave
    //Before fully loading the pic
    var request: Alamofire.Request?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Fav button
        favButton.tintColor = Helper.appColor()
        
        //Check if image is in downloads 
        if checkIfImageCached() {
            let img = UIImage(data: NSData(contentsOfURL: self.localFileURL!)!)
            let imageView = UIImageView(image: img)
            imageView.frame = self.view.frame
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
            self.progressView.hidden = true
            self.view.addSubview(imageView)
            favButton.image = UIImage(named: "like_filled.png")
            favorite = true
        }
        else {
            progressView.percent = 0
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //If leaving in middle of download, clear
        if request != nil && localFileURL == nil { request?.cancel() }
        
        //We can delete the image in case the user did not favorite it
        if !favorite && checkIfImageCached() {
            let favDirectory = ImgurHandler.downloadsDirectoryPath()
            let path = favDirectory.URLByAppendingPathComponent("\(image.imgid).jpg")
            var error: NSError?
            do {
                try NSFileManager.defaultManager().removeItemAtPath(path.path!)
            } catch let err as NSError {
                error = err
            }
            if error != nil {print(error?.localizedDescription)}
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //This means the file was already cached and retrieved
        if localFileURL != nil {return}
        
        //Load the image data and display in the view
        //Also show an animator
        request = ImgurHandler.fetchFullImageWithProgress(image.imgid, progressCallback: { (bytesRead, totalBytesRead, totalBytesExpectedToRead) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.progressView.percent = 100 * Int(totalBytesRead) / Int(totalBytesExpectedToRead)
                self.progressView.setNeedsDisplay()
            })
            }) { (request, response, data, imageURL, error) -> Void in
                if error != nil || imageURL == nil {
                    return
                }
                
                self.localFileURL = imageURL
                let img = UIImage(data: NSData(contentsOfURL: self.localFileURL!)!)
                let imageView = UIImageView(image: img)
                imageView.frame = self.view.frame
                imageView.contentMode = UIViewContentMode.ScaleAspectFit
                self.progressView.hidden = true
                self.view.addSubview(imageView)
                if self.favorite == false { self.changeFav()}
        }
    }
    
    func checkIfImageCached() -> Bool {
        let favDirectory = ImgurHandler.downloadsDirectoryPath()
        let path = favDirectory.URLByAppendingPathComponent("\(image.imgid).jpg")
        if NSFileManager.defaultManager().fileExistsAtPath(path.path!) {
            self.localFileURL = path
            return true
        }
        return false
    }
    
    @IBAction func changeFav() {
        favorite = !favorite
        if favorite {
            favButton.image = UIImage(named: "like_filled.png")
        }
        else {
            favButton.image = UIImage(named: "like.png")
        }
    }
    
}
