//
//  BaseCoordinator.swift
//  MVPDemo2
//
//  Created by Bibin on 19/02/19.
//  Copyright © 2019 Bibin. All rights reserved.
//

import UIKit

protocol BaseCoordinator {
    var navigationController: UINavigationController! { get set }
    
    init(navigationController: UINavigationController!)
    func start()
}

