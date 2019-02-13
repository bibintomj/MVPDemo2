//
//  AppDelegate.swift
//  MVPDemo2
//
//  Created by Bibin on 06/02/19.
//  Copyright © 2019 Bibin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let loginPresenter = LoginPresenter()
        let rootViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        loginPresenter.attach(view: rootViewController)
        
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.setNavigationBarHidden(true, animated: false)
        
        window?.rootViewController = navigationVC
        window?.makeKeyAndVisible()

        return true
    }



}

