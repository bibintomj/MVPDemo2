//
//  NetworkManager.swift
//  MVPDemo2
//
//  Created by Bibin on 07/02/19.
//  Copyright © 2019 Bibin. All rights reserved.
//

import UIKit


protocol NetworkProtocol {
    typealias ErrorDescription = String
    func performGet(from path: String, completion: @escaping ((Data?, Self.ErrorDescription?) ->()))
}


/*
 * Sample get using URLSession
 */
class Network {
}

extension Network: NetworkProtocol {
    
    class var shared: Network {
        return Network()
    }
    
    func performGet(from path: String, completion: @escaping ((Data?, Network.ErrorDescription?) -> ())) {
        let generalError = "Unexpected error occured"
        
        guard let url = URL(string: path) else {
            assertionFailure("\(#file) \(#line) Failed to convert \(path) to URL")
            return
        }
        
        DispatchQueue.main.async {
           UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            
            guard error == nil else {
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                    completion(nil, error?.localizedDescription ?? generalError)
                })
                return
            }
            
            guard data != nil else {
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                    completion(nil, generalError)
                })
                return
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                completion(data, nil)
            })
        }
        
        task.resume()
    }
}
