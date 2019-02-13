//
//  CKeypadObserver.swift
//  General
//
//  Created by Bibin on 18/07/18.
//

import UIKit

public enum CKeypadEventType: Int {
    case willShow = 1
    case didShow = 2
    case willHide = 3
    case didHide = 4
}


public protocol CKeypadObserverDelegate: NSObjectProtocol {
    func keypadObserverDidReceiveEventType(_ eventType: CKeypadEventType)
}


open class CKeypadObserver: NSObject {
    
    open fileprivate(set) var keypadIsVisible: Bool = false
    open weak var delegate: CKeypadObserverDelegate?
    
    fileprivate(set) var keyboardRect: CGRect = CGRect.zero
    
    fileprivate var eventTypes: [CKeypadEventType]!
    fileprivate var observing: Bool = false
    
    public convenience init(delegate: CKeypadObserverDelegate?, observeForEventTypes eventTypes: [CKeypadEventType]) {
        self.init()
        self.delegate = delegate
        self.eventTypes = eventTypes
    }
    
    override fileprivate init() {
        super.init()
    }
    
    fileprivate func notificationTypeForEventType(_ eventType: CKeypadEventType) -> String{
        switch eventType {
        case .willShow:
            return UIResponder.keyboardWillShowNotification.rawValue
        case .didShow:
            return UIResponder.keyboardDidShowNotification.rawValue
        case .willHide:
            return UIResponder.keyboardWillHideNotification.rawValue
        case .didHide:
            return UIResponder.keyboardDidHideNotification.rawValue
        }
    }

    fileprivate func notificationActionForEventType(_ eventType: CKeypadEventType) -> Selector{
        switch eventType {
        case .willShow:
            return #selector(willShowKeypad(_:))
        case .didShow:
            return #selector(didShowKeypad(_:))
        case .willHide:
            return #selector(willHideKeypad(_:))
        case .didHide:
            return #selector(didHideKeypad(_:))
        }
    }
    
    open func startObservingKeypadEvents(){
        
        if observing{
            return
        }
        
        for eventType in eventTypes{
            NotificationCenter.default.addObserver(self,
                                                             selector: notificationActionForEventType(eventType),
                                                             name: NSNotification.Name(rawValue: notificationTypeForEventType(eventType)),
                                                             object: nil)
        }
        
        observing = true
    }
    
    open func stopObservingKeypadEvents(){
        
        if !observing{
            return
        }
        
        for eventType in eventTypes{
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: notificationTypeForEventType(eventType)), object: nil)
        }
        
        observing = false
    }
    
    @objc open func willShowKeypad(_ notification: Notification){
        if let value = (notification as NSNotification).userInfo?[UIResponder.keyboardFrameEndUserInfoKey]{
            if let _value = value as? NSValue{
                keyboardRect = _value.cgRectValue
            }
        }
        keypadIsVisible = true
        delegate?.keypadObserverDidReceiveEventType(.willShow)
    }
    
    @objc open func didShowKeypad(_ notification: Notification){
        if let value = (notification as NSNotification).userInfo?[UIResponder.keyboardFrameEndUserInfoKey]{
            if let _value = value as? NSValue{
                keyboardRect = _value.cgRectValue
            }
        }
        keypadIsVisible = true
        delegate?.keypadObserverDidReceiveEventType(.didShow)
    }
    
    @objc open func willHideKeypad(_ notification: Notification){
        keypadIsVisible = false
        delegate?.keypadObserverDidReceiveEventType(.willHide)
    }
    
    @objc open func didHideKeypad(_ notification: Notification){
        keypadIsVisible = false
        delegate?.keypadObserverDidReceiveEventType(.didHide)
    }
}
