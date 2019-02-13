//
//  UserTableViewCellPresenter.swift
//  MVPDemo2
//
//  Created by Bibin on 08/02/19.
//  Copyright © 2019 Bibin. All rights reserved.
//

import Foundation

/// Presenter for UserTableViewCell
class UserTableViewCellPresenter: BasePresenter {
    
    typealias View = UserTableViewCell
    
    weak var view: UserTableViewCell!

    var user: User?

}

extension UserTableViewCellPresenter {
    
}
