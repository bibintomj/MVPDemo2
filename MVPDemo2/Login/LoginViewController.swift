//
//  LoginViewController.swift
//  MVPDemo2
//
//  Created by Bibin on 06/02/19.
//  Copyright © 2019 Bibin. All rights reserved.
//

import UIKit


/**
 Storyboard: Main.
 This class handles the UI and user interaction for login screen
 */
class LoginViewController: BaseViewController {
    
    @IBOutlet private weak var loginFormTop: NSLayoutConstraint!
    @IBOutlet private weak var loginFormStackView: UIStackView!
    
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var modeLabel: UILabel!
    
    /// Presenter for this class. All business logic will be handled by this class.
    var loginPresenter: LoginPresenter!
    
    /// This calculates the inset from login form to the top of the screen.
    private var calculatedLoginFormTop: CGFloat {
        if #available(iOS 11.0, *) {
            return self.view.safeAreaLayoutGuide.layoutFrame.height - loginFormStackView.frame.height
        }
        else {
            return self.view.frame.height - loginFormStackView.frame.height
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginPresenter.attach(view: self)
        configureUI()
    }
    
    /// Handles the keyboard auto scroll when keyboard appears.
    override func viewControllerShouldObserveForKeypadChanges() -> Bool {
        return true
    }
    
}



//MARK:- Private Functions
extension LoginViewController {
    
    ///Configure the Login UI
    private func configureUI() {
        self.loginFormTop.constant = abs(calculatedLoginFormTop)
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .interactive
        modeLabel.isHidden = true
        
        #if DEBUG   // This check is neeeded if a macOS app. Else real users can test mode.
        modeLabel.isHidden = !CommandLine.arguments.contains("enable-testing")
        #endif
    }
}

//MARK:- TextField Delegates
extension LoginViewController {
    /// This is called When the return button is tapped. Focuses next textfield if exists, else dismisses keyboard.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let tag = textField.tag + 1
        let nextTextField = self.view.viewWithTag(tag) as? UITextField
        
        if nextTextField != nil {
            nextTextField?.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        return false
    }
}

//MARK:- Event Handlers
extension LoginViewController {
    /// When the User taps the login button this function is called.
    @IBAction private func handleLoginTap(_ sender: UIButton) {
        self.loginPresenter.authenticate(username: usernameTextField.text ?? "",
                                  password: passwordTextField.text ?? "")
        self.view.resignFirstResponder()
    }
}

//MARK- Presenter Delegates
extension LoginViewController: LoginView {
    func showProgress() {
        CActivityIndicator.show()
    }
    func hideProgress() {
        CActivityIndicator.hide()
    }
    func loginFailedWith(message: String) {
        self.autoDismissAlert(title: message, message: nil)
        print(#file, #line, message)
    }
    
    func loginSuccess(for user: User) {
        self.autoDismissAlert(title: "Hello" , message: user.name.full.capitalized, dismissAfter: 2) {
            self.loginPresenter.navigateToHome()
        }
    }
}


//MARK: Storyboarded Conformance
extension LoginViewController: Storyboarded {
    static var storyboardName: String {
        return mainStoryboardName
    }
}
