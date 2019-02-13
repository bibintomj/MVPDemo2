//
//  HomeMocks.swift
//  MVPDemo2Tests
//
//  Created by Bibin on 11/02/19.
//  Copyright © 2019 Bibin. All rights reserved.
//

import XCTest
@testable import MVPDemo2


//MARK:- View Mocks
/// Mock for Home Server error occured
class MockHomeVC_ServerError: HomeView {
    
    var presenter:      HomePresenter!
    var expectation:    XCTestExpectation!
    
    init(presenter: HomePresenter) {
        self.presenter = presenter
    }
    
    func showProgress() {}
    
    func hideProgress() {}
    
    func fetchDidComplete(error: String?) {
        XCTAssertNotNil(error)
        XCTAssertEqual(error!, testUnexpectedServerError)
        expectation.fulfill()
    }
    
}

/// Mock for Home No Server response
class MockHomeVC_NoServerResponse: HomeView {
    
    var presenter:      HomePresenter!
    var expectation:    XCTestExpectation!
    
    init(presenter: HomePresenter) {
        self.presenter = presenter
    }
    
    func showProgress() {}
    
    func hideProgress() {}
    
    func fetchDidComplete(error: String?) {
        XCTAssertNotNil(error)
        XCTAssertEqual(error!, testNoResponseFromServerError)
        expectation.fulfill()
    }
    
}

///  Mock for Home No users found
class MockHomeVC_NoUsers: HomeView {
    
    var presenter:      HomePresenter!
    var expectation:    XCTestExpectation!
    
    init(presenter: HomePresenter) {
        self.presenter = presenter
    }
    
    func showProgress() {}
    
    func hideProgress() {}
    
    func fetchDidComplete(error: String?) {
        XCTAssertNotNil(error)
        XCTAssertEqual(error!, testLoginNoUsersFoundError)
        expectation.fulfill()
    }
    
}

///Mock for Home success users fetch
class MockHomeVC_UsersFetchSuccess: HomeView {
    
    var presenter:      HomePresenter!
    var expectation:    XCTestExpectation!
    
    init(presenter: HomePresenter) {
        self.presenter = presenter
    }
    
    func showProgress() {}
    
    func hideProgress() {}
    
    func fetchDidComplete(error: String?) {
        XCTAssertNil(error)
        XCTAssertFalse(presenter.users.isEmpty)
        expectation.fulfill()
    }
    
}





//MARK:- Network Mocks
/// Mock Home Network Server error occured
class MockHomeNetwork_ServerError: NetworkProtocol {
    func performGet(from path: String, completion: @escaping ((Data?, String?) -> ())) {
        let generalError = testUnexpectedServerError
        completion(nil, generalError)
    }
}

/// Mock Home Network No Server response
class MockHomeNetwork_NoServerResponse: NetworkProtocol {
    func performGet(from path: String, completion: @escaping ((Data?, String?) -> ())) {
        completion(nil, nil)
    }
}

/// Mock Home Network No User found
class MockHomeNetwork_NoUsers: NetworkProtocol {
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

/// Mock Home Network Successfull Login
class MockHomeNetwork_UsersFetchSuccess: NetworkProtocol {
    func performGet(from path: String, completion: @escaping ((Data?, String?) -> ())) {
        let userDataDict: [String: Any] =   ["name": ["title": "mr", "first": "daniel", "last": "petersen"],
                                             "email": "daniel.petersen@example.com",
                                             "phone": "44369985",
                                             "picture": [
                                                "large": "https://randomuser.me/api/portraits/men/11.jpg",
                                                "medium": "https://randomuser.me/api/portraits/med/men/11.jpg",
                                                "thumbnail": "https://randomuser.me/api/portraits/thumb/men/11.jpg"
            ]]
        
        let results: [String: Any] = ["results": [userDataDict, userDataDict, userDataDict]]
        
        
        let data = try! JSONSerialization.data(withJSONObject: results, options: JSONSerialization.WritingOptions.prettyPrinted)
        completion(data, nil)
    }
}



