//
//  AppDelegate.swift
//  CoolShots
//
//  Created by Joseph Kalash on 3/18/16.
//  Copyright © 2016 Joseph Kalash. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //Set tint colors
        UINavigationBar.appearance().barTintColor = UIColor.whiteColor()
        UIBarButtonItem.appearanceWhenContainedInInstancesOfClasses([UISearchBar.classForCoder()]).setTitleTextAttributes([NSForegroundColorAttributeName : Helper.appColor()], forState: UIControlState.Normal)
        UITextField.appearanceWhenContainedInInstancesOfClasses([UISearchBar.classForCoder()]).tintColor = Helper.appColor()
        self.window?.tintColor = Helper.appColor()
        
        return true
    }

}

