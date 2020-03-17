//
//  CircularProgressView.swift
//  Walk It Out
//
//  Created by James Barlian on 13/03/20.
//  Copyright © 2020 James Barlian. All rights reserved.
//

import SwiftUI

class CircularProgressView: UIView {
    
    // First create two layer properties
    public var circleLayer = CAShapeLayer()
    public var progressLayer = CAShapeLayer()

    override init(frame: CGRect) {
    super.init(frame: frame)
    createCircularPath()
    }

//    var circleColor = UIColor.white {
//        didSet {
//            circleLayer.strokeColor = circleColor.cgColor
//        }
//    }

    required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    createCircularPath()
    }

    func createCircularPath() {
    let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2), radius: (frame.size.width - 1.5)/2, startAngle: CGFloat(-0.5 * .pi), endAngle: CGFloat(1.5 * .pi), clockwise: true)

    circleLayer.path = circularPath.cgPath
    circleLayer.fillColor = UIColor.clear.cgColor
    circleLayer.lineCap = .round
    circleLayer.lineWidth = 15.0
    circleLayer.strokeColor = UIColor.black.cgColor


    progressLayer.path = circularPath.cgPath
    progressLayer.fillColor = UIColor.clear.cgColor
    progressLayer.lineCap = .round
    progressLayer.lineWidth = 10.0
    progressLayer.strokeEnd = 0
    progressLayer.strokeColor = UIColor.green.cgColor
    layer.addSublayer(circleLayer)
    layer.addSublayer(progressLayer)
    }

    func progressAnimation(duration: TimeInterval, value: Float) {
        
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.duration = duration
        circularProgressAnimation.toValue = value
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }
}
    


