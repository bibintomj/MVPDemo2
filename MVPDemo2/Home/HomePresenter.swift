//
//  HomePresenter.swift
//  MVPDemo2
//
//  Created by Bibin on 07/02/19.
//  Copyright © 2019 Bibin. All rights reserved.
//

import Foundation

protocol HomeView: BaseView {
    /**
     This function gets called when fetch is completed. Use this function to update UI
     - parameters:
        - error: Error description if fetch fails
     */
    func fetchDidComplete(error: NetworkProtocol.ErrorDescription?)
    
}

class HomePresenter: BasePresenter {
    
    typealias View = HomeView
    
    weak var view: HomeView!
    
    var network: NetworkProtocol = Network.shared
        
    private(set) var users: [User] = []
    
}

//MARK:- Core Functions
extension HomePresenter {

    /// Fetch users from remote
    func fetchUsers(limit: Int) {

        let APIPath         = "https://randomuser.me/api/?results=" + String(limit)
        
        self.view.showProgress()
        network.performGet(from: APIPath) { (data, error) in
            self.view.hideProgress()
            
            guard error == nil else {
                self.view.fetchDidComplete(error: error?.description)
                print(#file, #line, error ?? "")
                return
            }
            
            guard let data = data else {
                self.view.fetchDidComplete(error: noResponseFromServerError)
                print(#file, #line, "Response is nil")
                return
            }
            
            
            guard let responseDictionary = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Dictionary<String, Any> else {
                self.view.fetchDidComplete(error: unknownServerResponseError)
                print(#file, #line, unknownServerResponseError)
                return
            }
            
            let userList = responseDictionary?["results"] as? [[String: Any]] ?? []
            guard !userList.isEmpty else {
                self.view.fetchDidComplete(error: noUsersFoundWarning)
                return
            }
            
            self.users = []
            
            let jsonData = try! JSONSerialization.data(withJSONObject: userList)
            do {
                let decoder = JSONDecoder()
                self.users += try decoder.decode([User].self, from: jsonData)
            }
            catch let error {
                print(#file, #line, error)
            }
            
            self.view.fetchDidComplete(error: nil)
        }

    }
    
    /// Creastes a userCellPresenter for a cell with details of the User at specified index.
    func preparePresenterForUserCell(at indexPath: IndexPath) -> UserTableViewCellPresenter {
        let presenter = UserTableViewCellPresenter()
        presenter.user = self.users[indexPath.row]
        return presenter
    }
}
