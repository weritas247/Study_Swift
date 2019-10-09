//
//  BullsEyeTests.swift
//  study_swiftTests
//
//  Created by MyMacBookPro on 09/10/2019.
//  Copyright © 2019 Maverick DevStudioa. All rights reserved.
//

import XCTest
@testable import study_swift

class BullsEyeTests: XCTestCase {
    
    var sut: BullsEyeGame! //  System Under Test (SUT)
    
    override func setUp() {
        super.setUp()
        sut = BullsEyeGame()
        sut.startNewGame()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testScoreIsComputedWhenGuessLTTarget() {
        // 1. given
        let guess = sut.targetValue - 5
        print("guess: \(guess)")
        
        // 2. when
        sut.check(guess: guess)
        
        print("sut.scoreRound: \(sut.scoreRound)")
        
        // 3. then
        XCTAssertEqual(sut.scoreRound, 95, "Score computed from guess is wrong")
    }
    
    func testScoreIsComputed() {
        // 1. given
        let guess = sut.targetValue + 5
        print("guess: \(guess)")
        
        // 2. when
        sut.check(guess: guess)
        
        print("sut.scoreRound: \(sut.scoreRound)")
        
        // 3. then
        XCTAssertEqual(sut.scoreRound, 95, "Score computed from guess is wrong")
    }
    
    
}
