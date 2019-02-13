//
//  Generals.swift
//  MVPDemo2
//
//  Created by Bibin on 06/02/19.
//  Copyright © 2019 Bibin. All rights reserved.
//

import Foundation

/**
 A base protocol to unify common functions
 used to communicate with the view.
 */
protocol BaseView: class {
    /**
     Use this to communicate to the View to show activity indicator
     when an asynchrounous action is performed. (eg, Network call loader)
     */
    func showProgress()
    
    /**
     Use this to communicate to the View to hide activity indicator
     when an asynchrounous action is performed. (eg, Network call loader)
     */
    func hideProgress()
}


/**
 A base presenter to unify common functions used to communicate to the presenter
 */
protocol BasePresenter: class {
    
    /**
     A placeholder type for the view. Classes which implement this protocol can have their own view type.
     */
    associatedtype View
    
    var view: View! { get set }
    
    func attach(view: View)
    func detachView()
    
}

extension BasePresenter {
    func attach(view: View) {
        self.view = view
    }
    
    func detachView() {
        self.view = nil
    }
}
