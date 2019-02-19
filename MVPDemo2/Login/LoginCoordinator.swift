//
//  LoginCoordinator.swift
//  MVPDemo2
//
//  Created by Bibin on 19/02/19.
//  Copyright © 2019 Bibin. All rights reserved.
//

import UIKit



class LoginCoordinator: BaseCoordinator {
   
    var navigationController: UINavigationController!
    
    required init(navigationController: UINavigationController!) {
        self.navigationController = navigationController
    }
    
    func start() {
        let loginPresenter = LoginPresenter()
        loginPresenter.coordinator = self
        
        let loginVC = LoginViewController.instantiate()
        
        loginVC.loginPresenter = loginPresenter
        self.navigationController.pushViewController(loginVC, animated: true)
    }
    
}

extension LoginCoordinator: LoginPresenterDelegate {
    func login() {
        // navigate to home
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        homeCoordinator.start()
    }
}
