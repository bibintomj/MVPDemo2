//
//  LoginMocks.swift
//  MVPDemo2Tests
//
//  Created by Bibin on 11/02/19.
//  Copyright © 2019 Bibin. All rights reserved.
//

import XCTest
@testable import MVPDemo2


//MARK:- View Mocks
/// Mock for Login blank username warning
class MockLoginVC_NoUsername: LoginView {
    
    var presenter:      LoginPresenter!
    var expectation:    XCTestExpectation!
    
    init(presenter: LoginPresenter) {
        self.presenter = presenter
    }
    
    func showProgress() {}
    
    func hideProgress() {}
    
    func loginFailedWith(message: String) {
        XCTAssertEqual(message, testLoginBlankUsernameWarning)
        expectation.fulfill()
    }
    
    func loginSuccess(for user: User) {
        XCTFail()
    }
    
}

/// Mock for Login blank password warning
class MockLoginVC_NoPassword: LoginView {
    
    var presenter:      LoginPresenter!
    var expectation:    XCTestExpectation!
    
    init(presenter: LoginPresenter) {
        self.presenter = presenter
    }
    
    func showProgress() {}
    
    func hideProgress() {}
    
    func loginFailedWith(message: String) {
        XCTAssertEqual(message, testLoginBlankPasswordWarning)
        expectation.fulfill()
    }
    
    func loginSuccess(for user: User) {
        XCTFail()
    }
    
}

/// Mock for Login Server error occured
class MockLoginVC_ServerError: LoginView {
    
    var presenter:      LoginPresenter!
    var expectation:    XCTestExpectation!
    
    init(presenter: LoginPresenter) {
        self.presenter = presenter
    }
    
    func showProgress() {}
    
    func hideProgress() {}
    
    func loginFailedWith(message: String) {
        XCTAssertEqual(message, testUnexpectedServerError)
        expectation.fulfill()
    }
    
    func loginSuccess(for user: User) {
        XCTFail()
    }
    
}

/// Mock for Login No Server Response
class MockLoginVC_NoServerResponse: LoginView {
    
    var presenter:      LoginPresenter!
    var expectation:    XCTestExpectation!
    
    init(presenter: LoginPresenter) {
        self.presenter = presenter
    }
    
    func showProgress() {}
    
    func hideProgress() {}
    
    func loginFailedWith(message: String) {
        XCTAssertEqual(message, testNoResponseFromServerError)
        expectation.fulfill()
    }
    
    func loginSuccess(for user: User) {
        XCTFail()
    }
    
}

/// Mock for Login No User Found
class MockLoginVC_NoUser: LoginView {
    
    var presenter:      LoginPresenter!
    var expectation:    XCTestExpectation!
    
    init(presenter: LoginPresenter) {
        self.presenter = presenter
    }
    
    func showProgress() {}
    
    func hideProgress() {}
    
    func loginFailedWith(message: String) {
        XCTAssertEqual(message, testLoginNoUserFoundError)
        expectation.fulfill()
    }
    
    func loginSuccess(for user: User) {
        XCTFail()
    }
    
}

/// Mock for Login Successfull Login
class MockLoginVC_SuccessLogin: LoginView {
    
    var presenter:      LoginPresenter!
    var expectation:    XCTestExpectation!
    
    init(presenter: LoginPresenter) {
        self.presenter = presenter
    }
    
    func showProgress() {}
    
    func hideProgress() {}
    
    func loginFailedWith(message: String) {
        XCTFail()
    }
    
    func loginSuccess(for user: User) {
        expectation.fulfill()
    }
    
}


//MARK:- Network Mocks
/// Mock Login Network Server error occured
class MockLoginNetwork_ServerError: NetworkProtocol {
    func performGet(from path: String, completion: @escaping ((Data?, String?) -> ())) {
        let generalError = testUnexpectedServerError
        completion(nil, generalError)
    }
}

/// Mock Login Network No Server response
class MockLoginNetwork_NoServerResponse: NetworkProtocol {
    func performGet(from path: String, completion: @escaping ((Data?, String?) -> ())) {
        completion(nil, nil)
    }
}

/// Mock Login Network No User found
class MockLoginNetwork_NoUser: NetworkProtocol {
    func performGet(from path: String, completion: @escaping ((Data?, String?) -> ())) {
        let noUserResponseDict: [String: Any] = ["results": []]
        
        do {
            let data = try JSONSerialization.data(withJSONObject: noUserResponseDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            completion(data, nil)
        }
        catch let error {
            XCTFail()
            print(error)
        }
        
    }
}

/// Mock Login Network Successfull Login
class MockLoginNetwork_SuccessLogin: NetworkProtocol {
    func performGet(from path: String, completion: @escaping ((Data?, String?) -> ())) {

        let userDataDict: [String: Any] =   ["name": ["title": "mr", "first": "daniel", "last": "petersen"],
                                             "email": "daniel.petersen@example.com",
                                             "phone": "44369985",
                                             "picture": [
                                                "large": "https://randomuser.me/api/portraits/men/11.jpg",
                                                "medium": "https://randomuser.me/api/portraits/med/men/11.jpg",
                                                "thumbnail": "https://randomuser.me/api/portraits/thumb/men/11.jpg"
                                            ]]
        
        let results: [String: Any] = ["results": [userDataDict]]
        
        
        let data = try! JSONSerialization.data(withJSONObject: results, options: JSONSerialization.WritingOptions.prettyPrinted)
        completion(data, nil)
        
    }
}

