//
//  SLAnimationHelper.swift
//  SLAnimation
//
//  Created by liusilan on 16/5/24.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

import Foundation
import UIKit

class SLAnimationHelper: NSObject {

    var fromPoint: CGPoint
    var toPoint: CGPoint
    var radius: CGFloat

    var animationLayer: CAShapeLayer?
    var block: ()->() = {
        
    }

    init(fromPoint: CGPoint = CGPointZero, toPoint: CGPoint  = CGPointZero, radius: CGFloat = 0, animationLayer: CAShapeLayer? = nil) {
        self.fromPoint = fromPoint
        self.toPoint = toPoint
        self.radius = radius
        self.animationLayer = animationLayer
    }

    // 总长度，两个圆圈+中间距离
    func totalLength() -> CGFloat {
        return fabs(toPoint.x - fromPoint.x) + 2 * 2 * CGFloat(M_PI) * radius
    }

    // 一个圆圈+中间距离
    func distance() -> CGFloat {
        return fabs(toPoint.x - fromPoint.x) + 2 * CGFloat(M_PI) * radius
    }

    func animationBezierPath() -> UIBezierPath {

        let bezierPath = UIBezierPath()
        // true--顺时针
        let clockwise: Bool = fromPoint.x > toPoint.x

        // first circle
        bezierPath.addArcWithCenter(fromPoint, radius: radius, startAngle: CGFloat(M_PI_2), endAngle: CGFloat(M_PI), clockwise: clockwise)
        bezierPath.addArcWithCenter(fromPoint, radius: radius, startAngle: CGFloat(M_PI), endAngle: CGFloat(M_PI_2), clockwise: clockwise)

        // line
        bezierPath.moveToPoint(CGPointMake(fromPoint.x, fromPoint.y + radius))
        bezierPath.addLineToPoint(CGPointMake(toPoint.x, toPoint.y + radius))

        // second circle
        bezierPath.addArcWithCenter(toPoint, radius: radius, startAngle: CGFloat(M_PI_2), endAngle: CGFloat(M_PI), clockwise: clockwise)
        bezierPath.addArcWithCenter(toPoint, radius: radius, startAngle: CGFloat(M_PI), endAngle: CGFloat(M_PI_2), clockwise: clockwise)

        return bezierPath
    }

    func createAnimationLayer(containerView: UIView, fromPoint: CGPoint, toPoint: CGPoint, radius: CGFloat) {

        self.fromPoint = fromPoint
        self.toPoint = toPoint
        self.radius = radius

        if animationLayer == nil {
            let shapeLayer = CAShapeLayer()
            
            shapeLayer.fillColor = UIColor.clearColor().CGColor
            shapeLayer.strokeColor = UIColor.redColor().CGColor
            shapeLayer.lineWidth = 1
            
            animationLayer = shapeLayer
            
            containerView.layer.addSublayer(shapeLayer)
        }
        
        animationLayer?.path = animationBezierPath().CGPath

        animationLayer?.opacity = 1
    }

    func createAnimation(completion: () -> ()) -> CAAnimationGroup {

        let duration: CFTimeInterval = 0.75
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")

        strokeStartAnimation.duration = duration
        strokeStartAnimation.fromValue = 0
        strokeStartAnimation.toValue = distance() / totalLength()

        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")

        strokeEndAnimation.duration = duration
        strokeEndAnimation.fromValue = 0.1
        strokeEndAnimation.toValue = 1

        let animationGroup: CAAnimationGroup = CAAnimationGroup()

        animationGroup.duration = duration;
        animationGroup.animations = [strokeStartAnimation, strokeEndAnimation]
        animationGroup.delegate = self
        animationGroup.fillMode = kCAFillModeBoth;
        animationGroup.removedOnCompletion = false

        return animationGroup
    }
    
    func startAnimation(completion: () -> ()) {
        let animation = createAnimation({})
    
        block = {
            completion()
            
            self.animationLayer?.opacity = 0
            self.animationLayer?.removeAllAnimations()
        }
        
        CATransaction.begin()
        CATransaction.setCompletionBlock(block)
        
        animationLayer?.addAnimation(animation, forKey: "animation")

        CATransaction.commit()
    }
}