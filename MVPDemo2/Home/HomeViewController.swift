//
//  HomeViewController.swift
//  MVPDemo2
//
//  Created by Bibin on 06/02/19.
//  Copyright © 2019 Bibin. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
    
    var homePresenter = HomePresenter()
    
    @IBOutlet private weak var usersTableView: UITableView!
    
    @IBOutlet private weak var loggedInUserImageView: UIImageView!
    @IBOutlet private weak var loggedInUsernameLabel: UILabel!
    @IBOutlet private weak var loggedInPhoneLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        homePresenter.attach(view: self)
        homePresenter.fetchUsers(limit: 20)
        
        usersTableView.dataSource = self
        
        configureUI()
    }

    private func configureUI() {
        usersTableView.tableFooterView = UIView()
        usersTableView.contentInset.bottom = 50
        usersTableView.accessibilityIdentifier = "HomeUsersTableView"
        usersTableView.isAccessibilityElement = true
        
        loggedInUserImageView.clipsToBounds = true
        loggedInUserImageView.layer.cornerRadius = loggedInUserImageView.frame.height/2
        loggedInUserImageView.layer.borderWidth = 3
        loggedInUserImageView.layer.borderColor = UIColor.white.cgColor
        loggedInUserImageView.image = #imageLiteral(resourceName: "Contact")
        
        let imageURL = LoginModel.shared.user.imageURL.thumbnail
        loggedInUserImageView.load(url: URL(string: imageURL)!) { (image) in
            LoginModel.shared.user.image = image
        }
        loggedInUsernameLabel.text = LoginModel.shared.user.name.full.capitalized
        loggedInPhoneLabel.text = LoginModel.shared.user.phone
        
    }
}

//MARK:- Presenter Delegates
extension HomeViewController: HomeView {
    
    func showProgress() {
        CActivityIndicator.show()
    }
    
    func hideProgress() {
        CActivityIndicator.hide()
    }
    
    
    func fetchDidComplete(error: Network.ErrorDescription?) {
        guard error == nil else {
            self.autoDismissAlert(title: error!, message: nil)
            return
        }
        
        usersTableView.reloadData()
    }
}


//MARK: TableView Datasource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homePresenter.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "UserTableViewCell"
        
        // Creates a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! UserTableViewCell
        
        // Creates a cell presenter and assigns presenter to the cell
        let presenterForUserCell = homePresenter.preparePresenterForUserCell(at: indexPath)
        cell.presenter = presenterForUserCell
        
        return cell
    }
    
    
}


