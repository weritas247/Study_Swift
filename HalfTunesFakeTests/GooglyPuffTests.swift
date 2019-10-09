//
//  GooglyPuffTests.swift
//  study_swift
//
//  Created by MyMacBookPro on 09/10/2019.
//  Copyright © 2019 Maverick DevStudioa. All rights reserved.
//

import XCTest
@testable import study_swift

private let defaultTimeoutLengthInSeconds: Int = 10 // 10 Seconds

class GooglyPuffTests: XCTestCase {

    func testLotsOfFacesImageURL() {
        downloadImageURL(withString: PhotoURLString.lotsOfFaces)
    }
    
    func testSuccessKidImageURL() {
        downloadImageURL(withString: PhotoURLString.successKid)
    }
    
    func testOverlyAttachedGirlfriendImageURL() {
        downloadImageURL(withString: PhotoURLString.overlyAttachedGirlfriend)
    }
    
    func downloadImageURL(withString urlString: String) {
        
        let url = URL(string: urlString)
        
        // 1 - You create a semaphore and set its start value. This represents the number of things that can access the semaphore without needing the semaphore to be incremented (note that incrementing a semaphore is known as signaling it).
        let semaphore = DispatchSemaphore(value: 0)
        let _ = DownloadPhoto(url: url!) { _, error in
            if let error = error {
                XCTFail("\(urlString) failed. \(error.localizedDescription)")
            }
            
            // 2 - You signal the semaphore in the completion closure. This increments the semaphore count and signals that the semaphore is available to other resources that want it.
            semaphore.signal()
        }
        let timeout = DispatchTime.now() + .seconds(defaultTimeoutLengthInSeconds)
        
        // 3 - You wait on the semaphore, with a given timeout. This call blocks the current thread until the semaphore is signaled. A non-zero return code from this function means that the timeout period expired. In this case, the test fails because the network should not take more than 10 seconds to return — a fair point!
        if semaphore.wait(timeout: timeout) == .timedOut {
            XCTFail("\(urlString) timed out")
        }
    }
   
}
