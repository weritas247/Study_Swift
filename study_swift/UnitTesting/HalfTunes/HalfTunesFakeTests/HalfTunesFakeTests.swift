//
//  HalfTunesFakeTests.swift
//  HalfTunesFakeTests
//
//  Created by MyMacBookPro on 09/10/2019.
//  Copyright © 2019 Maverick DevStudioa. All rights reserved.
//

import XCTest
@testable import study_swift

class HalfTunesFakeTests: XCTestCase {

    var sut: HalfTunesSearchViewController!
    
    override func setUp() {
        sut = UIStoryboard(name: "HalfTunes", bundle: nil)
            .instantiateInitialViewController() as? HalfTunesSearchViewController
        
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "abbaData", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
        
        let url = URL(string: "http://itunes.apple.com/search?media=music&entity=song&term=abba")
        let urlResponse = HTTPURLResponse(url: url!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let sessionMock = URLSessionMock(data: data, response: urlResponse, error: nil)
        sut.defaultSession = sessionMock
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_UpdateSearchResults_ParsesData() {
        // given
        let promise = expectation(description: "Status code: 200")
        
        // when
        XCTAssertEqual(sut.searchResults.count, 0, "searchResults should be empty before the task runs")
        
        let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=abba")
        let dataTask = sut.defaultSession.dataTask(with: url!) { data, response, error in
            // if HTTP request is successful, call updateSearchResults(_:)
            // which parses the response data into Tracks
            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                self.sut.updateSearchResults(data)
            }
            promise.fulfill()
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)
        
        // then
        XCTAssertEqual(sut.searchResults.count, 3, "Didn't parse3 items for fake response")
    }

}
