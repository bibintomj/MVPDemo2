//
//  LoginUITests.swift
//  MVPDemo2UITests
//
//  Created by Bibin on 11/02/19.
//  Copyright © 2019 Bibin. All rights reserved.
//

import XCTest

class LoginUITests: XCTestCase {
    
    private var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()
    }

    override func tearDown() {}

}

//MARK:- Tests
extension LoginUITests {
    
    func testLogin_EmptyUsername() {
        
        let validPassword       = "1234"
        let elementsQuery       = app.scrollViews.otherElements
        let usernameTextField   = elementsQuery.textFields["Username"]
        let passwordTextField   = elementsQuery.secureTextFields["Password"]
        let loginButton         = elementsQuery.buttons["Login"]
        
        XCTAssertTrue(usernameTextField.exists)
        XCTAssertTrue(passwordTextField.exists)
        XCTAssertTrue(loginButton.exists)
        
        passwordTextField.tap()
        passwordTextField.typeText(validPassword)
        app.buttons["Done"].tap()
        
        loginButton.tap()

        XCTAssertTrue(app.alerts[testLoginBlankUsernameWarning].exists)
        
    }
    
    func testLogin_EmptyPassword() {
        
        let validUsername       = "John"
        let elementsQuery       = app.scrollViews.otherElements
        let usernameTextField   = elementsQuery.textFields["Username"]
        let passwordTextField   = elementsQuery.secureTextFields["Password"]
        let loginButton         = elementsQuery.buttons["Login"]
        
        
        XCTAssertTrue(usernameTextField.exists)
        XCTAssertTrue(passwordTextField.exists)
        XCTAssertTrue(loginButton.exists)
        
        usernameTextField.tap()
        usernameTextField.typeText(validUsername)
        
        app.buttons["Next"].tap()
        app.buttons["Done"].tap()
        
        loginButton.tap()
        
        XCTAssertTrue(app.alerts[testLoginBlankPasswordWarning].exists)
    }

    func testLogin_SuccessLogin() {
        let validUsername       = "John"
        let validPassword       = "1234"
        
        let elementsQuery       = app.scrollViews.otherElements
        let usernameTextField   = elementsQuery.textFields["Username"]
        let passwordTextField   = elementsQuery.secureTextFields["Password"]
        let loginButton         = elementsQuery.buttons["Login"]
        
        XCTAssertTrue(usernameTextField.exists)
        XCTAssertTrue(passwordTextField.exists)
        XCTAssertTrue(loginButton.exists)
        
        
        // Typing Username
        usernameTextField.tap()
        usernameTextField.typeText(validUsername)
        app.buttons["Next"].tap()
        
        
        // Typing Password
        passwordTextField.typeText(validPassword)
        app.buttons["Done"].tap()
        
        // Initiate Login
        loginButton.tap()
        
        // Ensure activity indicator is visible
        let inProgressElement = app.otherElements.containing(.activityIndicator, identifier:"In progress").element
        XCTAssertTrue(inProgressElement.exists)
        
        // Alert that appears when a success login
        let successAlert                = app.alerts["Hello"]
        
        //otherElements(matching: .any, identifier: homeRootViewIdentifier)
        
        
        
        wait(forElement: successAlert, timeout: 10) { loginError in
            XCTAssertNil(loginError)
            
            
            // Home View
            let homeRootViewAccessibilitydentifier      = "HomeRootView"
            let homeRootView = self.app.otherElements.element(matching: .any, identifier: homeRootViewAccessibilitydentifier)
            
            self.wait(forElement: homeRootView, timeout: 10, completion: { homeViewError in
                XCTAssertNil(homeViewError)
                
                
                print(self.app.debugDescription) // This will print out view heirarchy.
                
                homeRootView.swipeUp()  // scrolls the table view
                
                homeRootView.swipeDown()
                
            })
            
        }
    }
    
}
