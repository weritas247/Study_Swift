//
//  Turn.swift
//  DesignPatternsInSwift
//
//  Created by MyMacBookPro on 2017. 2. 13..
//  Copyright © 2017년 RepublicOfApps, LLC. All rights reserved.
//

import Foundation

class Turn {
  let shapes: [Shape]
  var matched: Bool?
  
  init(shapes: [Shape]) {
    self.shapes = shapes
  }
  
  func turnCompletedWithTappedShape(tappedShape: Shape) {
    let maxArea = shapes.reduce(0){ $0 > $1.area ? $0 : $1.area}
//    print("maxArea: \(maxArea)")
    matched = tappedShape.area >= maxArea
  }
}
