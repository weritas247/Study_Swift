//
//  TrunController.swift
//  DesignPatternsInSwift
//
//  Created by MyMacBookPro on 2017. 2. 13..
//  Copyright © 2017년 RepublicOfApps, LLC. All rights reserved.
//

import Foundation

class TurnController {
  var currentTurn: Turn?
  var pastTurns: [Turn] = [Turn]()

  init(turnStrategy: TurnStrategy) {
    self.turnStrategy = turnStrategy
    self.scorer = MatchScorer()
    self.scorer.nextScorer = StreakScorer()
  }
  
//  init(shapeFactory: ShapeFactory, shapeViewBuilder: ShapeViewBuilder) {
//    self.shapeFactory = shapeFactory
//    self.shapeViewBuilder = shapeViewBuilder
//  }
  
  func beginNewTurn() -> (ShapeView, ShapeView) {
//    let shapes = shapeFactory.createShapes()
//    let shapeViews = shapeViewBuilder.buildShapeViewForShapes(shapes: shapes)
    let shapeViews = turnStrategy.makeShapeViewsForNextTurnGivenPastTurns(pastTurns: pastTurns)
    
    currentTurn = Turn(shapes: [shapeViews.0.shape, shapeViews.1.shape])
    
    return shapeViews
  }
  
  func endTurnWithTappedShape(tappedShape: Shape) -> Int {
    currentTurn!.turnCompletedWithTappedShape(tappedShape: tappedShape)
    pastTurns.append(currentTurn!)
    
//    let scoreIncrement = currentTurn!.matched! ? 1 : -1
    let scoreIncrement = scorer.computeScoreIncrement(pastTurnsReversed: pastTurns.reversed())
    
    return scoreIncrement
  }
  
//  private let shapeFactory: ShapeFactory
//  private var shapeViewBuilder: ShapeViewBuilder
  private let turnStrategy: TurnStrategy
    private var scorer: Scorer
}
