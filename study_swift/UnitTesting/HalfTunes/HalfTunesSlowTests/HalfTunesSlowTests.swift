//
//  HalfTunesSlowTests.swift
//  BullsEyeTests
//
//  Created by MyMacBookPro on 09/10/2019.
//  Copyright © 2019 Maverick DevStudioa. All rights reserved.
//

import XCTest
@testable import study_swift

class HalfTunesSlowTests: XCTestCase {

    var sut: URLSession!
    
    override func setUp() {
        super.setUp()
        sut = URLSession(configuration: URLSessionConfiguration.default)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testCallToiTunesCompletes() {
        // given
        let url =
            URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=abba")
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?
        
        // when
        let dataTask = sut.dataTask(with: url!) { data, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            promise.fulfill()
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)
        
        // then
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
    
    // Asynchronous test: success fast, failure slow
    func testValidCallToiTunesGetHTTPStatusCode200() {
        // given
        let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=abba")
        
        // 1 - expectation(description:): Returns an XCTestExpectation object, stored in promise. The description parameter describes what you expect to happen.
        let promise = expectation(description: "Status code: 200")

        // when
        let dataTask = sut.dataTask(with: url!) { data, response, error in
            // then
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    // 2 - promise.fulfill(): Call this in the success condition closure of the asynchronous method’s completion handler to flag that the expectation has been met.
                    promise.fulfill()
                } else {
                    XCTFail("StatusCode: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        // 3 - wait(for:timeout:): Keeps the test running until all expectations are fulfilled, or the timeout interval ends, whichever happens first.
        wait(for: [promise], timeout: 5)
    }
}
