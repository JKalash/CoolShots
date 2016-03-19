//
//  Image.swift
//  CoolShots
//
//  Created by Joseph Kalash on 3/18/16.
//  Copyright © 2016 Joseph Kalash. All rights reserved.
//

import UIKit

class Image: NSObject {
    
    var imgid: String! = ""
    var thumb_data : NSData? = nil
    
    init(id: String) {
        super.init()
        self.imgid = id
    }
    
}
