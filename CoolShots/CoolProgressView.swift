//
//  CoolProgressView.swift
//  CoolShots
//
//  Created by Joseph Kalash on 3/18/16.
//  Copyright © 2016 Joseph Kalash. All rights reserved.
//

import UIKit

class CoolProgressView: UIView {
    
    static let startAngle : CGFloat = CGFloat(M_PI) * 1.5
    static let endAngle : CGFloat = startAngle + CGFloat(M_PI) * 2
    var percent : Int = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
    }

    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    override func drawRect(rect: CGRect) {
        let bezierPath = UIBezierPath()
        bezierPath.addArcWithCenter(CGPointMake(rect.size.width / 2,rect.size.height / 2),
            radius: 130,
            startAngle: CoolProgressView.startAngle,
            endAngle: (CoolProgressView.endAngle - CoolProgressView.startAngle) * (CGFloat(percent) / 100.0) + CoolProgressView.startAngle,
            clockwise: true)
        
        // Set the display for the path, and stroke it
        bezierPath.lineWidth = 20;
        Helper.appColor().setStroke()
        bezierPath.stroke()
        
    }

}
