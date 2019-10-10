//
//  GameViewController.swift
//  DesignPatternsInSwift
//
//  Created by Joel Shapiro on 9/23/14.
//  Copyright (c) 2014 RepublicOfApps, LLC. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class GameViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let squareShapeViewFactory = SquareShapeViewFactory(size: gameView.sizeAvailableForShapes())
    let squareShapeFactory = SquareShapeFactory(minProportion: 0.3, maxProportion: 0.8)
    let squareShapeViewBuilder = shapeViewBuilderForFactory(shapeViewFactory: squareShapeViewFactory)
    let squareTurnStrategy = BasicTurnStrategy(shapeFactory: squareShapeFactory, shapeViewBuilder: squareShapeViewBuilder)
    
    let circleShapeViewFactory = CircleShapeViewFactory(size: gameView.sizeAvailableForShapes())
    let circleShapeFactory = CircleShapeFactory(minProportion: 0.3, maxProportion: 0.8)
    let circleShapeViewBuilder = shapeViewBuilderForFactory(shapeViewFactory: circleShapeViewFactory)
    let circleTurnStrategy = BasicTurnStrategy(shapeFactory: circleShapeFactory, shapeViewBuilder: circleShapeViewBuilder)
    
    let randomTurnStrategy = RandomTurnStrategy(firstStrategy: squareTurnStrategy, secondStrategy: circleTurnStrategy)
    
//    shapeViewFactory = SquareShapeViewFactory(size: gameView.sizeAvailableForShapes())
//    shapeFactory = SquareShapeFactory(minProportion: 0.3, maxProportion: 0.8)
    
//    shapeViewFactory = CircleShapeViewFactory(size: gameView.sizeAvailableForShapes())
//    shapeFactory = CircleShapeFactory(minProportion: 0.3, maxProportion: 0.8)
    
    
//    shapeViewBuilder = ShapeViewBuilder(shapeViewFactory: shapeViewFactory)
//    shapeViewBuilder.fillColor = UIColor.blue
//    shapeViewBuilder.outlineColor = UIColor.red
   
//    turnController = TurnController(shapeFactory: shapeFactory, shapeViewBuilder: shaviewbuil)
    turnController = TurnController(turnStrategy: randomTurnStrategy)
    
    beginNextTurn()
  }

  override var prefersStatusBarHidden : Bool {
    return true
  }
  
  private func shapeViewBuilderForFactory(shapeViewFactory: ShapeViewFactory) -> ShapeViewBuilder {
    let shapeViewBuilder = ShapeViewBuilder(shapeViewFactory: shapeViewFactory)
    shapeViewBuilder.fillColor = UIColor.brown
    shapeViewBuilder.outlineColor = UIColor.orange
    
    return shapeViewBuilder
  }

  private func beginNextTurn() {
//    let shapes = shapeFactory.createShapes()
    let shapeViews = turnController.beginNewTurn()
    
//    let shapeViews = shapeViewFactory.makeShapeViewsForShapes(shapes: shapes)
//    let shapeViews = shapeViewBuilder.buildShapeViewForShapes(shapes: shapes)

//    shapeViews.0.tapHandler = {
//      a in
//      self.gameView.score += shapes.0.area >= shapes.1.area ? 1 : -1
//      self.beginNextTurn()
//    }
//    shapeViews.1.tapHandler = {
//      tappedView in
//      self.gameView.score += shapes.0.area >= shapes.1.area ? 1 : -1
//      self.beginNextTurn()
//    }

    shapeViews.0.tapHandler = {
      tappedView in
//      print("tappedView: \(tappedView)")
      self.gameView.score += self.turnController.endTurnWithTappedShape(tappedShape: tappedView.shape)
      self.beginNextTurn()
    }
    
    shapeViews.1.tapHandler = shapeViews.0.tapHandler
    
    gameView.addShapeViews(shapeViews)
  }

  private var gameView: GameView { return view as! GameView }
//  private var shapeViewFactory: ShapeViewFactory!
//  private var shapeFactory: ShapeFactory!
//  private var shapeViewBuilder: ShapeViewBuilder!
  private var turnController: TurnController!
}


