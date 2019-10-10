//
//  ShapeViewBuilder.swift
//  DesignPatternsInSwift
//
//  Created by MyMacBookPro on 2017. 2. 11..
//  Copyright © 2017년 RepublicOfApps, LLC. All rights reserved.
//

import Foundation
import UIKit

class ShapeViewBuilder {
  var showFill = true
  var fillColor = UIColor.orange
  
  var showOutline = true
  var outlineColor = UIColor.gray
  
  init(shapeViewFactory: ShapeViewFactory) {
    self.shapeViewFactory = shapeViewFactory
  }
  
  func buildShapeViewForShapes(shapes: (Shape, Shape)) -> (ShapeView, ShapeView) {
    let shapeViews = shapeViewFactory.makeShapeViewsForShapes(shapes: shapes)
    
    configureShapeView(shapeView: shapeViews.0)
    configureShapeView(shapeView: shapeViews.1)
    
    return shapeViews
    
  }
  
  private func configureShapeView(shapeView: ShapeView) {
    shapeView.showFill = showFill
    shapeView.fillColor = fillColor
    shapeView.showOutline = showOutline
    shapeView.outlineColor = outlineColor
  }
  
  private var shapeViewFactory: ShapeViewFactory
}
