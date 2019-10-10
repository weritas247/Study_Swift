//
//  ShapeView.swift
//  DesignPatternsInSwift
//
//  Created by Joel Shapiro on 9/23/14.
//  Copyright (c) 2014 RepublicOfApps, LLC. All rights reserved.
//

import Foundation
import UIKit

class ShapeView: UIView {
  var shape: Shape!
  
  // 1
  var showFill: Bool = true {
    didSet {
      setNeedsDisplay()
    }
  }
  var fillColor: UIColor = UIColor.orange {
    didSet {
      setNeedsDisplay()
    }
  }
  
  // 2
  var showOutline: Bool = true {
    didSet {
      setNeedsDisplay()
    }
  }
  var outlineColor: UIColor = UIColor.gray {
    didSet {
      setNeedsDisplay()
    }
  }
  
  // 3
  var tapHandler: ((ShapeView) -> ())?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    // 4
    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShapeView.handleTap))
    addGestureRecognizer(tapRecognizer)
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
    @objc func handleTap() {
    // 5
    tapHandler?(self)
  }
  
  let halfLineWidth: CGFloat = 3.0
}

class SquareShapeView: ShapeView {
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    if showFill {
      fillColor.setFill()
      let fillPath = UIBezierPath(rect: bounds)
      fillPath.fill()
    }
    
    if showOutline {
      outlineColor.setStroke()
      
      let outlinePath = UIBezierPath(rect: CGRect(x: halfLineWidth, y: halfLineWidth, width: bounds.size.width - 2 * halfLineWidth, height: bounds.size.height - 2 * halfLineWidth))
      outlinePath.lineWidth = 2.0 * halfLineWidth
      outlinePath.stroke()
    }
  }
}


class CircleShapeView: ShapeView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    // 1
    self.isOpaque = false
    // 2
    self.contentMode = UIView.ContentMode.redraw
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    if showFill {
      fillColor.setFill()
      // 3
      let fillPath = UIBezierPath(ovalIn: self.bounds)
      fillPath.fill()
    }
    
    if showOutline {
      outlineColor.setStroke()
      // 4
      let outlinePath = UIBezierPath(ovalIn: CGRect(x: halfLineWidth, y: halfLineWidth, width: self.bounds.size.width - 2 * halfLineWidth, height: self.bounds.size.height - 2 * halfLineWidth))
      outlinePath.lineWidth = 2.0 * halfLineWidth
      outlinePath.stroke()
    }
  }
}
