//
//  SLAnimationItemView.swift
//  SLAnimation
//
//  Created by liusilan on 16/5/24.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class SLAnimationItemView: UIButton {

    let margin: CGFloat = 8.0

    private var innerSelectStatus: Bool = false

    private var normalImageView: UIImageView?
    private var selectedImageView: UIImageView?

    @IBInspectable var selectedImage: UIImage? {
        get {
            return selectedImageView?.image
        }

        set {
            selectedImageView?.image = newValue
        }
    }

    @IBInspectable var normalImage: UIImage? {
        get {
            return normalImageView?.image
        }

        set {
            normalImageView?.image = newValue
        }
    }

    @IBInspectable var selectStatus: Bool {
        get {
            return innerSelectStatus
        }

        set {
            innerSelectStatus = newValue
            normalImageView?.alpha = newValue ? 0 : 1
            showOutLineLayer(newValue)
        }
    }

    // MARK: OutCircleLayer
    lazy private var outCircleLayer: CAShapeLayer = {
        let layer = CAShapeLayer()

        layer.path = self.outCirclePath().CGPath
        layer.fillColor = UIColor.clearColor().CGColor
        layer.strokeColor = UIColor.redColor().CGColor
        layer.lineWidth = 1

        self.layer.addSublayer(layer)

        return layer
    }()
    
    private func outCirclePath() -> UIBezierPath {
        let path = UIBezierPath()

        path.addArcWithCenter(centerPoint(), radius: radius(), startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: false)

        return path
    }

    // MARK: setup

    init(frame: CGRect, normalImage: UIImage?, selectedImage: UIImage?) {

        super.init(frame: frame)

        commonInit()
        normalImageView?.image = normalImage
        selectedImageView?.image = selectedImage
    }

    required override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {

        selectedImageView = UIImageView()
        selectedImageView!.contentMode = .ScaleAspectFit
        addSubview(selectedImageView!)

        normalImageView = UIImageView()
        normalImageView!.contentMode = .ScaleAspectFit
        addSubview(normalImageView!)
    }

    func centerPoint() -> CGPoint {

        let r = self.frame.size.width / 2
        return CGPointMake(r, r)
    }

    func radius() -> CGFloat {
        return self.frame.size.width / 2 - 2;
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let frame = CGRectMake(0, 0, self.frame.size.width - margin * 2, self.frame.size.width - margin * 2)

        if let selectedImageView = selectedImageView {
            selectedImageView.frame = frame
            selectedImageView.center = centerPoint()
        }

        if let normalImageView = normalImageView {
            normalImageView.frame = frame
            normalImageView.center = centerPoint()
        }
    }
    
    // MARK: show/hide
    func showOutLineLayer(show: Bool) {
        
        UIView.animateWithDuration(0.3, animations: {
            
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            self.outCircleLayer.opacity = show ? 1 : 0
            
            CATransaction.commit()
            
            self.normalImageView?.alpha = show ? 0 : 1

            }) { (flag) in
        }
    }
}