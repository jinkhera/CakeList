//
//  Cake_List_CakeAPI_Tests.swift
//  Cake ListTests
//
//  Created by Jatinder Pal Singh Khera on 07/10/2019.
//  Copyright © 2019 Stewart Hart. All rights reserved.
//

import XCTest
@testable import Cake_List

class Cake_List_CakeAPI_Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDownloadCakes() {
        // Create an expectation for a API call.
        let expectation = XCTestExpectation(description: "Fetch cakes")
        
        CakeList.loadCakes { (cakes) in
            if cakes?.count == 0 {
                XCTFail("Disaster! No cakes today")
            }
            
            // Fulfill the expectation to indicate that the background task has finished successfully.
            expectation.fulfill()
        }
        
        // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
        wait(for: [expectation], timeout: 10.0)
    } 
}
