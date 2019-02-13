//
//  LoginModel.swift
//  MVPDemo2
//
//  Created by Bibin on 11/02/19.
//  Copyright © 2019 Bibin. All rights reserved.
//

import UIKit

class LoginModel {
    private init() {}
    
    private static let sharedModel = LoginModel()
    class var shared: LoginModel {
        return sharedModel
    }
    
    var user: User!
    
}
