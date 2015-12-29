//
//  AppDelegate.swift
//  BubbleCells
//
//  Created by Yury Korolev on 12/29/15.
//  Copyright © 2015 Yury Korolev. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.rootViewController = ViewController()
        window!.makeKeyAndVisible()
        
        return true
    }

}

