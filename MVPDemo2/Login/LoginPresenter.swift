//
//  LoginPresenter.swift
//  MVPDemo2
//
//  Created by Bibin on 06/02/19.
//  Copyright © 2019 Bibin. All rights reserved.
//

import UIKit


protocol LoginPresenterDelegate: class {
    func login()
}

protocol LoginView: BaseView {
    /**
     Called when login fails due to validation or wrong credentials
     - parameters:
        - message: Error description for login failure
    */
    func loginFailedWith(message: String)
    
    /**
     Called when the login is successfull.
     - parameters:
        - user: Logged in User
    */
    func loginSuccess(for user: User)
}



/**
 Presenter for the Login. Write all business logic and UI independant codes in this class
*/
class LoginPresenter: BasePresenter {    
    
    /**
     Setting a type for placeholder type.
     */
    typealias View = LoginView
    
    /// Specifying weak explicitly to avoid retain cycles
    weak var view: LoginView!
    
    
    var network: NetworkProtocol = Network.shared
    
    var coordinator: LoginPresenterDelegate?

    /**
     Validates and logs in with specified credentials
     - parameters:
        - username: Username assciated with user account
        - password: Password of the user account
     */
    func authenticate(username: String, password: String) {
        guard !username.isEmpty else {
            self.view.loginFailedWith(message: loginBlankUsernameWarning)
            return
        }
        
        guard !password.isEmpty else {
            self.view.loginFailedWith(message: loginBlankPasswordWarning)
            return
        }
        
        let APIPath = "https://randomuser.me/api/"

        view.showProgress()
        
        network.performGet(from: APIPath) { (data, error) in
            self.view.hideProgress()
            
            guard error == nil else {
                print(#file, #line, error ?? "")
                self.view.loginFailedWith(message: error!)
                return
            }
            
            guard let data = data else {
                print(#file, #line, "Response is nil")
                self.view.loginFailedWith(message: noResponseFromServerError)
                return
            }
            
            
            guard let responseDictionary = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Dictionary<String, Any> else {
                print(#file, #line, "Failed to convert")
                self.view.loginFailedWith(message: unknownServerResponseError)
                return
            }
            
            let userList = responseDictionary?["results"] as? [[String: Any]] ?? []
            guard !userList.isEmpty else {
                self.view.loginFailedWith(message: noUserFoundWarning)
                return
            }
            
            let userDetails = userList.first!
            
            let jsonData = try! JSONSerialization.data(withJSONObject: userDetails)
            
            do {
                let decoder = JSONDecoder()
                LoginModel.shared.user = try decoder.decode(User.self, from: jsonData)
                self.view.loginSuccess(for: LoginModel.shared.user)
            }
            catch let error {
                print(#file, #line, error)
            }
        }
        
    }
    
    func navigateToHome() {
        self.coordinator!.login()
    }
}



