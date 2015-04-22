//
//  DrawingView.swift
//  DrawingTest
//
//  Created by sakira on 2015/04/21.
//  Copyright (c) 2015年 sakira. All rights reserved.
//

import Foundation
import UIKit

class DrawingView : UIView {
  var canvas: UIImage = UIImage()
  var penColor: UIColor = UIColor.redColor()
  var currentPath: UIBezierPath = UIBezierPath()
  let penWidth: CGFloat = 5
  var updatingRect: CGRect = CGRectZero
  var image : UIImage {
    get {
      return getImage()
    }
  }
  
  required override init(frame: CGRect) {
    super.init(frame: frame)
    NSLog("DrawingView init(frame:)")
    
    self.opaque = false
    self.backgroundColor = UIColor.clearColor()
    
    currentPath.lineWidth = penWidth
    currentPath.lineCapStyle = kCGLineCapRound
    
    canvas = clearImageOfSize(frame.size)
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder:aDecoder)
    NSLog("DrawingView init(coder:)")
    self.backgroundColor = UIColor.clearColor()
  }
  
  private func clearImageOfSize(size: CGSize) -> UIImage {
    UIGraphicsBeginImageContext(size)
    UIColor.clearColor().set()
    UIRectFill(CGRectMake(0, 0, size.width, size.height))
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }

  var initialDrawRect = true
  override func drawRect(rect: CGRect) {
    NSLog("DrawingView drawRect()")
    if initialDrawRect {
      UIColor.clearColor().set()
      UIRectFill(self.frame)
      initialDrawRect = false
    }
    
    UIColor.clearColor().setFill()
    penColor.setStroke()
    canvas = imageDrawnPath(canvas, path: currentPath)
    let image = imageOfCanvas(rect)
    image.drawInRect(rect)
  }
  
  private func imageOfCanvas(rect :CGRect) -> UIImage {
    UIGraphicsBeginImageContext(rect.size)
    let opt = rect.origin
    canvas.drawAtPoint(CGPointMake(-opt.x, -opt.y))
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }
  
  private func imageDrawnPath(image: UIImage, path :UIBezierPath) -> UIImage {
    UIGraphicsBeginImageContext(canvas.size)
    canvas.drawAtPoint(CGPointZero)
    penColor.setStroke()
    path.stroke()
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }
  
  private func updateRectWithPoint(pt : CGPoint) {
    let rect = CGRectMake(pt.x - penWidth, pt.y - penWidth,
      penWidth * 2, penWidth * 2)
    updatingRect = CGRectUnion(updatingRect, rect)
  }
  
  private func getImage() -> UIImage {
    UIGraphicsBeginImageContext(self.frame.size)
    self.layer.drawInContext(UIGraphicsGetCurrentContext())
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }
  
  override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
    NSLog("touchesBegan")
    let t = touches.first as! UITouch
    let pt = t.locationInView(self)
    currentPath.moveToPoint(pt)
    updatingRect = CGRectMake(pt.x, pt.y, 0, 0)
    updateRectWithPoint(pt)
  }
  
  override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
    NSLog("touchesMoved")
    let t = touches.first as! UITouch
    let pt = t.locationInView(self)
    
    currentPath.addLineToPoint(pt)
    updateRectWithPoint(pt)
    
    self.setNeedsDisplayInRect(updatingRect)
  }
  
  override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
    NSLog("touchesEnded")
    currentPath.removeAllPoints()
    updatingRect = CGRectZero
  }
}