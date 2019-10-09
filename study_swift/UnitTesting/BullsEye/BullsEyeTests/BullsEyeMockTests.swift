//
//  BullsEyeMockTests.swift
//  study_swift
//
//  Created by MyMacBookPro on 09/10/2019.
//  Copyright © 2019 Maverick DevStudioa. All rights reserved.
//

import XCTest
@testable import study_swift

class MockUserDefaults: UserDefaults {
    var gameStyleChanged = 0
    override func set(_ value: Int, forKey defaultName: String) {
        if defaultName == "gameStyle" {
            gameStyleChanged += 1
        }
    }
}

class BullsEyeMockTests: XCTestCase {

    var sut: BullsEyeGameViewController!
    var mockUserDefaults: MockUserDefaults!
    
    override func setUp() {
        sut = UIStoryboard(name: "BullsEyeGame", bundle: nil).instantiateInitialViewController() as? BullsEyeGameViewController
        mockUserDefaults = MockUserDefaults(suiteName: "testing")
        sut.defaults = mockUserDefaults
    }

    override func tearDown() {
        sut = nil
        mockUserDefaults = nil
        super.tearDown()
    }
    
    func testGameStyleCanBeChanged() {
        // given
        let segmentedControl = UISegmentedControl()
        
        // when
        XCTAssertEqual(mockUserDefaults.gameStyleChanged, 0, "gameStyleChanged should be 0 before sendActions")
        segmentedControl.addTarget(sut, action: #selector(BullsEyeGameViewController.chooseGameStyle(_:)), for: .valueChanged)
        
        // then
        XCTAssertEqual(mockUserDefaults.gameStyleChanged, 1, "gameStyle user default wasn't changed")
    }
 

}
