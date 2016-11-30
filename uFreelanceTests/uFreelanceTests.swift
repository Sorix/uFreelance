//
//  uFreelanceTests.swift
//  uFreelanceTests
//
//  Created by Vasily Ulianov on 30.11.16.
//  Copyright © 2016 Vasily Ulianov. All rights reserved.
//

import XCTest
import Upwork

@testable import uFreelance

class uFreelanceTests: XCTestCase {
	static let savedCredentials = OAuthCredentials(token: "2f5eba6d8425692fc88526455298835b", tokenSecret: "296e1a1b6425ddf5")
	
	override class func setUp() {
		super.setUp()
		
		UpworkAuthorization.setOAuthCredentials(credentials: savedCredentials)
	}
	
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func newExpectation(functionName: String = #function) -> XCTestExpectation {
		return expectation(description: functionName)
	}
	
	func testAuthSetCredentials() {
		UpworkAuthorization.setOAuthCredentials(credentials: uFreelanceTests.savedCredentials)
		
		let oauthCredentials = UpworkAuthorization.oauth.client.credential
		
		XCTAssert(oauthCredentials.oauthToken == uFreelanceTests.savedCredentials.token)
		XCTAssert(oauthCredentials.oauthTokenSecret == uFreelanceTests.savedCredentials.tokenSecret)
	}
	
	func testMetadataSkills() {
		let myExpectation = newExpectation()
		
		DispatchQueue.global().async {
			let possibleSkills = UpworkService.upworkAPI.metadata.listSkills()
			
			guard let skills = possibleSkills.valid else {
				XCTFail(possibleSkills.error.description)
				myExpectation.fulfill()
				return
			}
			
			XCTAssert((skills.count > 3100) && (skills.count < 5000))

			myExpectation.fulfill()
		}
		
		self.waitForExpectations(timeout: 5) { (error) in
			
		}

	}
	
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
