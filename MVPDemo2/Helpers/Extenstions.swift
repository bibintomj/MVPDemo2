//
//  Extenstions.swift
//  MVPDemo2
//
//  Created by Bibin on 06/02/19.
//  Copyright © 2019 Bibin. All rights reserved.
//

import UIKit

extension UIViewController {
    
    
    /**
     Creats an alert and presents it to user. Dismisses after specified TimeInterval. Default 1 second.
     - parameters:
        - title: Alert title
        - message: Alert message
        - seconds: TimeInterval after the alert should dismiss
        - completion: Completion handler after alert is dismissed
     */
    func autoDismissAlert(title: String?, message: String?, dismissAfter seconds: TimeInterval = 1, completion: (() -> ())? = nil) {
        
        let executeBlock = {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            self.present(alert, animated: true) {
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: {
                    alert.dismiss(animated: true) { completion?() }
                })
            }
        }

        
        
        if Thread.isMainThread {
            executeBlock()
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: {
                executeBlock()
            })
        }
        
    }
    
}


extension UIImageView {
    
    /**
     Loads an image from URL asynchrounsly
     - parameters:
        - url: Remote URL of image
     */
    func load(url: URL, completion: ((UIImage?)->())?) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                        completion?(image)
                    }
                }
                else {
                    completion?(nil)
                }
            }
            else {
                completion?(nil)
            }
        }
    }
}
