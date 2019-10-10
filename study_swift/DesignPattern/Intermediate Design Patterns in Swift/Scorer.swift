//
//  Scorer.swift
//  DesignPatternsInSwift
//
//  Created by MyMacBookPro on 2017. 2. 13..
//  Copyright © 2017년 RepublicOfApps, LLC. All rights reserved.
//

import Foundation

protocol Scorer {
  var nextScorer: Scorer? { get set }
  
    func computeScoreIncrement<S: Sequence>(pastTurnsReversed: S) -> Int where Turn == S.Iterator.Element
}

class MatchScorer: Scorer {
  var nextScorer: Scorer? = nil
  
    func computeScoreIncrement<S : Sequence>(pastTurnsReversed: S) -> Int where Turn == S.Iterator.Element {
    var scoreIncrement: Int?
    
    for turn in pastTurnsReversed {
      if scoreIncrement == nil {
        scoreIncrement = turn.matched! ? 1 : -1
        break
      }
    }
    
//    return scoreIncrement ?? 0
    return (scoreIncrement ?? 0) + (nextScorer?.computeScoreIncrement(pastTurnsReversed: pastTurnsReversed) ?? 0)
  }
}

class StreakScorer: Scorer {
  var nextScorer: Scorer? = nil
  
    func computeScoreIncrement<S : Sequence>(pastTurnsReversed: S) -> Int where Turn == S.Iterator.Element {
    var streakLength = 0
    
    for turn in pastTurnsReversed {
      if turn.matched! {
        streakLength += 1
      } else {
        break
      }
    }
    
    let streakBonus = streakLength >= 5 ? 10 : 0
    return streakBonus + (nextScorer?.computeScoreIncrement(pastTurnsReversed: pastTurnsReversed) ?? 0)
  }
}
