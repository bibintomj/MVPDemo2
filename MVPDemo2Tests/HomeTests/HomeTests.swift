//
//  HomeTests.swift
//  MVPDemo2Tests
//
//  Created by Bibin on 11/02/19.
//  Copyright © 2019 Bibin. All rights reserved.
//

import XCTest
@testable import MVPDemo2

/**
 * This TestCase tests the HomePresenter
 */
class HomeTests: XCTestCase {

    private var homePresenterSUT: HomePresenter!
    
    override func setUp() {
        super.setUp()
        homePresenterSUT = HomePresenter()
    }

    override func tearDown() {
        homePresenterSUT.detachView()
        homePresenterSUT = nil
        super.tearDown()
    }
}

/// HARK:- Tests
extension HomeTests {
    
    func testHome_ServerError() {
        let expectation = self.expectation(description: "Testing home users fetch by server error")
        
        homePresenterSUT.network = MockHomeNetwork_ServerError()
        let mockVC = MockHomeVC_ServerError(presenter: homePresenterSUT)
        mockVC.expectation = expectation
        
        homePresenterSUT.attach(view: mockVC)

        homePresenterSUT.fetchUsers(limit: 5)
        wait(for: [expectation], timeout: 2)
    }
    
    func testHome_NoServerResponse() {
        let expectation = self.expectation(description: "Testing home users fetch by no server response")
        
        homePresenterSUT.network = MockHomeNetwork_NoServerResponse()
        let mockVC = MockHomeVC_NoServerResponse(presenter: homePresenterSUT)
        mockVC.expectation = expectation
        
        homePresenterSUT.attach(view: mockVC)
        
        homePresenterSUT.fetchUsers(limit: 5)
        wait(for: [expectation], timeout: 2)
    }
    
    
    func testHome_NoUsers() {
        let expectation = self.expectation(description: "Testing home users fetch by no users")
        
        homePresenterSUT.network = MockHomeNetwork_NoUsers()
        let mockVC = MockHomeVC_NoUsers(presenter: homePresenterSUT)
        mockVC.expectation = expectation
        
        homePresenterSUT.attach(view: mockVC)
        
        homePresenterSUT.fetchUsers(limit: 5)
        wait(for: [expectation], timeout: 2)
    }
    
    func testHome_UsersFetchSuccess() {
        let expectation = self.expectation(description: "Testing home users success fetch")
        
        homePresenterSUT.network = MockHomeNetwork_UsersFetchSuccess()
        let mockVC = MockHomeVC_UsersFetchSuccess(presenter: homePresenterSUT)
        mockVC.expectation = expectation
        
        homePresenterSUT.attach(view: mockVC)
        
        homePresenterSUT.fetchUsers(limit: 5)
        wait(for: [expectation], timeout: 2)
    }
}



