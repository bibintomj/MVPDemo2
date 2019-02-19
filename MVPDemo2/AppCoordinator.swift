//
//  MainCoordinator.swift
//  MVPDemo2
//
//  Created by Bibin on 19/02/19.
//  Copyright © 2019 Bibin. All rights reserved.
//

import UIKit


class AppCoordinater: BaseCoordinator {
    
    var navigationController: UINavigationController!
    
    required init(navigationController: UINavigationController!) {
        self.navigationController = navigationController
    }
    
    func start() {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        (UIApplication.shared.delegate as! AppDelegate).window = window
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        let loginCoordinator = LoginCoordinator(navigationController: self.navigationController)
        loginCoordinator.start()
        
    }
    
}
