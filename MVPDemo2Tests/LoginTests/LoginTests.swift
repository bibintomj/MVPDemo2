//
//  LoginTest.swift
//  MVPDemo2Tests
//
//  Created by Bibin on 07/02/19.
//  Copyright © 2019 Bibin. All rights reserved.
//

import XCTest
@testable import MVPDemo2


/**
 * This TestCase tests the LoginPresenter
 */

class LoginTests: XCTestCase {
    
    private var loginPresenterSUT:  LoginPresenter!
    
    private let validUsername   = "john"
    private let validPassword   = "1234"

    override func setUp() {
        super.setUp()
        loginPresenterSUT       = LoginPresenter()
    }
    
    override func tearDown() {
        loginPresenterSUT.detachView()
        loginPresenterSUT       = nil
        super.tearDown()
    }
}

//MARK:- Tests
extension LoginTests {
    
    func testLogin_EmptyUserName() {
        let expectation             = self.expectation(description: "Testing Empty Username validation message")
        
        let mockLoginVC             = MockLoginVC_NoUsername(presenter: loginPresenterSUT)
        loginPresenterSUT.attach(view: mockLoginVC)
        mockLoginVC.expectation     = expectation
        
        loginPresenterSUT.authenticate(username: "", password: validPassword)
        wait(for: [expectation], timeout: 1)
    }
    
    
    func testLogin_EmptyPassword() {
        let expectation             = self.expectation(description: "Testing Empty Username validation message")
        
        let mockLoginVC             = MockLoginVC_NoPassword(presenter: loginPresenterSUT)
        loginPresenterSUT.attach(view: mockLoginVC)
        mockLoginVC.expectation     = expectation
        
        loginPresenterSUT.authenticate(username: validUsername, password: "")
        wait(for: [expectation], timeout: 1)
    }
    
    
    func testLogin_ServerError() {
        
        let expectation         = self.expectation(description: "Testing Login failure by server error")
        
        let mockLoginVC = MockLoginVC_ServerError(presenter: loginPresenterSUT)
        mockLoginVC.expectation = expectation
        loginPresenterSUT.attach(view: mockLoginVC)
        
        loginPresenterSUT.network = MockLoginNetwork_ServerError()
        loginPresenterSUT.authenticate(username: validUsername, password: validPassword)
        
        wait(for: [expectation], timeout: 2)
    }
    
    
    func testLogin_NoServerResponse() {
        
        let expectation         = self.expectation(description: "Testing Login failure by no server response")
        
        let mockLoginVC = MockLoginVC_NoServerResponse(presenter: loginPresenterSUT)
        mockLoginVC.expectation = expectation
        loginPresenterSUT.attach(view: mockLoginVC)
        
        loginPresenterSUT.network = MockLoginNetwork_NoServerResponse()
        loginPresenterSUT.authenticate(username: validUsername, password: validPassword)
        
        wait(for: [expectation], timeout: 2)
    }
    
    
    func testLogin_NoUser() {
        let expectation         = self.expectation(description: "Testing Login Failure by no user found")
        
        let mockLoginVC = MockLoginVC_NoUser(presenter: loginPresenterSUT)
        mockLoginVC.expectation = expectation
        loginPresenterSUT.attach(view: mockLoginVC)
        
        loginPresenterSUT.network = MockLoginNetwork_NoUser()
        loginPresenterSUT.authenticate(username: validUsername, password: validPassword)
        
        wait(for: [expectation], timeout: 2)
    }
    
    
    func testLogin_SuccessLogin() {
        let expectation         = self.expectation(description: "Testing Login Success by valid credentials")

        let mockLoginVC = MockLoginVC_SuccessLogin(presenter: loginPresenterSUT)
        mockLoginVC.expectation = expectation
        loginPresenterSUT.attach(view: mockLoginVC)
        
        loginPresenterSUT.network = MockLoginNetwork_SuccessLogin()
        loginPresenterSUT.authenticate(username: validUsername, password: validPassword)
        wait(for: [expectation], timeout: 2)
    }

}




