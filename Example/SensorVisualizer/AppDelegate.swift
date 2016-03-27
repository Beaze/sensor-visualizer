//
//  AppDelegate.swift
//  SensorVisualizer
//
//  Created by Joe Blau on 03/22/2016.
//  Copyright (c) 2016 Joe Blau. All rights reserved.
//

import UIKit
import SensorVisualizer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = {
        return AppWindow(frame: UIScreen.mainScreen().bounds)
    }()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
    }
}
