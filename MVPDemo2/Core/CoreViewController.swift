//
//  CoreViewController.swift
//  General
//
//  Created by Bibin on 18/07/18.
//

import UIKit

open class CoreViewController: UIViewController, CKeypadObserverDelegate, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet fileprivate(set) weak var scrollView: UIScrollView!
    
    fileprivate(set) var keypadObserver: CKeypadObserver?
    fileprivate var activeInputView: UIView?
    
    fileprivate var activeInputViewFrame: CGRect {
        if let activeInputView = activeInputView {
            return activeInputView.frame
        }
        
        return CGRect.zero
    }
    
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        if self.viewControllerShouldObserveForKeypadChanges() {
            keypadObserver = CKeypadObserver(delegate: self, observeForEventTypes: [.didShow, .willHide])
        }
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Start observing keypad events
        keypadObserver?.startObservingKeypadEvents()
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Stops observing keypad events
        keypadObserver?.stopObservingKeypadEvents()
    }
    
    
    
    /* KEYPAD OBSERVER CHANGES */
    
    func setActiveInputView(_ inputView: UIView?){
        activeInputView = inputView
        
        var keypadIsVisible = false
        if let _keypadIsVisible = keypadObserver?.keypadIsVisible{
            keypadIsVisible = _keypadIsVisible
        }
        
        /* Required if the navigation between input fields are enabled.
         * Since the textFieldDidBeginEdit is called after the keypad is
         */
        if inputView != nil && keypadIsVisible{
            keypadObserverDidReceiveEventType(.didShow)
        }
    }
    
    
}

// Functions to Override
extension CoreViewController{
    
    @objc func viewControllerShouldObserveForKeypadChanges() -> Bool{
        return false
    }
    
    @objc func shouldHaveInputAccessoryViewForInputView(_ view: UIView) -> Bool{
        return false
    }
    
    @objc func inputAccessoryViewForInputView(_ view: UIView) -> UIToolbar{

        let keyboardToolBar = UIToolbar()
        keyboardToolBar.sizeToFit()
        
        keyboardToolBar.barTintColor = .white
        keyboardToolBar.isTranslucent = true
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem:
            UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem:
            UIBarButtonItem.SystemItem.stop, target: self, action: #selector(handlerInputAccessoryViewDone(_:)) )
        
        keyboardToolBar.setItems([flexibleSpace, doneButton], animated: true)
        
        return keyboardToolBar
        
    }
    
    @objc final func handlerInputAccessoryViewDone(_ sender: AnyObject){
        self.view.endEditing(true)
    }
}


//MARK:- Private Functions
extension CoreViewController{
   
    private func keypadDidShow(){
        
        var rect: CGRect = self.scrollView?.bounds ?? self.view.frame
        var keyboardRect = CGRect.zero
        var activeInputViewFrameInView: CGRect = CGRect.zero
        
        if let _ = keypadObserver{
            keyboardRect = keypadObserver!.keyboardRect
        }
        
        if let activeInputView = self.activeInputView{
            activeInputViewFrameInView = activeInputView.convert(activeInputView.bounds, to: self.scrollView)
            
            if (self.activeInputView?.isKind(of: UITextView.self) ?? false){
                activeInputViewFrameInView.size.height /= 2
            }
        }
        
        let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardRect.height, right: 0.0);
        
        rect.size.height -= (keyboardRect.height + activeInputViewFrameInView.height)
        if !rect.contains(activeInputViewFrameInView){
            self.scrollView?.contentInset = contentInsets
            self.scrollView?.scrollIndicatorInsets = contentInsets;
            self.scrollView?.scrollRectToVisible(activeInputViewFrameInView, animated: true)
        }
    }
    
    private func keypadWillHide(){
        let contentInsets: UIEdgeInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets;
        scrollView?.scrollIndicatorInsets = contentInsets;
    }
}


//MARK:- Keypad Observer Delegate
extension CoreViewController {
    open func keypadObserverDidReceiveEventType(_ eventType: CKeypadEventType) {
        switch eventType {
        case .didShow:
            keypadDidShow()
            break
        case .willHide:
            keypadWillHide()
            break
        default: ()
        }
    }
}

//MARK:- TextField Delegates
extension CoreViewController {
    open func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.inputAccessoryView = nil
        if self.shouldHaveInputAccessoryViewForInputView(textField){
            textField.inputAccessoryView = self.inputAccessoryViewForInputView(textField)
        }
        setActiveInputView(textField)
    }
    
    open func textFieldDidEndEditing(_ textField: UITextField) {
        textField.inputAccessoryView = nil
        setActiveInputView(nil)
    }
}

//MARK:- TextView Delegates
extension CoreViewController {
    open func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.inputAccessoryView = nil
        if self.shouldHaveInputAccessoryViewForInputView(textView){
            textView.inputAccessoryView = self.inputAccessoryViewForInputView(textView)
        }
        return true
    }
    
    open func textViewDidBeginEditing(_ textView: UITextView) {
        setActiveInputView(textView)
    }
    
    open func textViewDidEndEditing(_ textView: UITextView) {
        textView.inputAccessoryView = nil
        setActiveInputView(nil)
    }
}
