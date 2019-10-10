//
//  ShapeFactory.swift
//  DesignPatternsInSwift
//
//  Created by MyMacBookPro on 2017. 2. 11..
//  Copyright © 2017년 RepublicOfApps, LLC. All rights reserved.
//

import Foundation
import UIKit

protocol ShapeFactory {
  func createShapes() -> (Shape, Shape)
}

class SquareShapeFactory: ShapeFactory {
  var minProportion: CGFloat
  var maxProportion: CGFloat
  
  init(minProportion: CGFloat, maxProportion: CGFloat) {
    self.minProportion = minProportion
    self.maxProportion = maxProportion
  }
  
  func createShapes() -> (Shape, Shape) {
    let shape1 = SquareShape()
    shape1.sideLength = RaywenderlichUtils.randomBetweenLower(minProportion, andUpper: maxProportion)
    
    let shape2 = SquareShape()
    shape2.sideLength = RaywenderlichUtils.randomBetweenLower(minProportion, andUpper: maxProportion)
    
    return (shape1, shape2)
  }
}

class CircleShapeFactory: ShapeFactory {
  var minProportion: CGFloat
  var maxProportion: CGFloat
  
  init(minProportion: CGFloat, maxProportion: CGFloat) {
    self.minProportion = minProportion
    self.maxProportion = maxProportion
  }
  
  func createShapes() -> (Shape, Shape) {
    let shape1 = CircleShape()
    shape1.diameter = RaywenderlichUtils.randomBetweenLower(minProportion, andUpper: maxProportion)
    
    let shape2 = CircleShape()
    shape2.diameter = RaywenderlichUtils.randomBetweenLower(minProportion, andUpper: maxProportion)
    
    return (shape1, shape2)
  }
}

