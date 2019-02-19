//
//  HomeCoordinator.swift
//  MVPDemo2
//
//  Created by Bibin on 19/02/19.
//  Copyright © 2019 Bibin. All rights reserved.
//

import UIKit

class HomeCoordinator: BaseCoordinator {
    var navigationController: UINavigationController!
    
    required init(navigationController: UINavigationController!) {
        self.navigationController = navigationController
    }
    
    func start() {
        let homePresenter = HomePresenter()
        let homeVC = HomeViewController.instantiate()
        homePresenter.coordinator = self
        homeVC.homePresenter = homePresenter
        self.navigationController.pushViewController(homeVC, animated: true)
    }
    

}

extension HomeCoordinator: HomePresenterDelegate {}
