//
//  SemiCirleView.swift
//  MCounter
//
//  Created by apple on 4/12/20.
//  Copyright © 2020 WeOverOne. All rights reserved.
//

import Foundation
import UIKit

class SemiCirleView: UIView {

    var semiCirleLayer: CAShapeLayer!
    var clockWise = true
    var colorForLayer = UIColor.red.cgColor

    override func layoutSubviews() {
        super.layoutSubviews()

        if semiCirleLayer == nil {
            let arcCenter = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
            let circleRadius = bounds.size.width / 2
            let circlePath = UIBezierPath(arcCenter: arcCenter, radius: circleRadius, startAngle: CGFloat.pi, endAngle: CGFloat.pi * 2, clockwise: clockWise)

            semiCirleLayer = CAShapeLayer()
            semiCirleLayer.path = circlePath.cgPath
            semiCirleLayer.fillColor = colorForLayer
            layer.addSublayer(semiCirleLayer)

            // Make the view color transparent
            backgroundColor = UIColor.clear
        }
        else {
            semiCirleLayer.removeFromSuperlayer()
            let arcCenter = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
            let circleRadius = bounds.size.width / 2
            let circlePath = UIBezierPath(arcCenter: arcCenter, radius: circleRadius, startAngle: CGFloat.pi, endAngle: CGFloat.pi * 2, clockwise: clockWise)

            semiCirleLayer = CAShapeLayer()
            semiCirleLayer.path = circlePath.cgPath
            semiCirleLayer.fillColor = colorForLayer
            layer.addSublayer(semiCirleLayer)

            // Make the view color transparent
            backgroundColor = UIColor.clear
        }
    }
}
