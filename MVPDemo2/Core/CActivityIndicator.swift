//
//  CActivityIndicator.swift
//  MVPDemo2
//
//  Created by Bibin on 08/02/19.
//  Copyright © 2019 Bibin. All rights reserved.
//

import UIKit


/// Activity Indicator wrapper class
class CActivityIndicator {
    
    /// Duration for the overlay to appear
    private static let animationDuration: TimeInterval = 0.3
    
    /// Internal count to avoid multiple overlays if already added.
    private static var counter: Int = 0
    
    /// Spinning activity indicator
    private static let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .white)
        indicator.startAnimating()
        return indicator
    }()
    
    /// Overlay View
    private static let overlayView: UIView = {
        let view = UIView(frame: UIApplication.shared.keyWindow?.frame ?? .zero)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        activityIndicator.center = view.center
        
        view.addSubview(activityIndicator)
        return view
    }()
    
    /// Calling this function will increase the counter and show the overlay and activity indicator on top of the screen.
    /// Multiple calls to this function without calling hide() will only increase the counter with no visible changes.
    static func show() {
        counter += 1
        if counter == 1 {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                overlayView.alpha = 0
                UIApplication.shared.keyWindow?.addSubview(overlayView)
                
                UIView.animate(withDuration: animationDuration) {
                    overlayView.alpha = 1
                }
            }
        }
    }
    
    /// Calling this function will reduce the counter and hide the overlay if counter is zero
    static func hide() {
        counter = max(0, counter - 1)
        if counter == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                UIView.animate(withDuration: animationDuration, animations: {
                    overlayView.alpha = 0
                }) { status in
                    overlayView.removeFromSuperview()
                }
            }
        }
    }
}
