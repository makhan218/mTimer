//
//  DIYCalendarCell.swift
//  MCounter
//
//  Created by apple on 1/31/20.
//  Copyright © 2020 WeOverOne. All rights reserved.
//

import Foundation
import FSCalendar
import UIKit

enum SelectionType : Int {
    case none
    case single
    case leftBorder
    case middle
    case rightBorder
}


class DIYCalendarCell: FSCalendarCell {
    
    weak var circleImageView: UIImageView!
    weak var selectionLayer: CAShapeLayer!
    weak var lineLayer: CAShapeLayer?
    var hasLine = false
    
    var selectionType: SelectionType = .none {
        didSet {
            setNeedsLayout()
        }
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let circleImageView = UIImageView(image: UIImage(named: "circle")!.withRenderingMode(.alwaysTemplate))
        circleImageView.tintColor = ThemeSettings.sharedInstance.fontColor

        circleImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        circleImageView.contentMode = .scaleAspectFit // OR .scaleAspectFill
        circleImageView.clipsToBounds = true
        self.contentView.insertSubview(circleImageView, at: 0)
        self.circleImageView = circleImageView
        
        let selectionLayer = CAShapeLayer()
        selectionLayer.fillColor = ThemeSettings.sharedInstance.fontColor.cgColor
        selectionLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(selectionLayer, below: self.titleLabel!.layer)
        self.selectionLayer = selectionLayer
        
        self.shapeLayer.isHidden = true
        
        let view = UIView(frame: self.bounds)
//        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.12)
        self.backgroundView = view;
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        if hasLine {
            drawLine()
        }
        else {
            undraw()
        }
        
       
        
        self.circleImageView.frame =  CGRect(x: self.contentView.bounds.origin.x , y: self.contentView.bounds.origin.y , width: 30, height: 30)
        self.circleImageView.center = self.titleLabel.center
        
//        self.circleImageView.frame =  CGRect(x: self.contentView.frame.origin.x + 6, y: self.contentView.frame.origin.y , width: self.contentView.bounds.width - 15, height: self.contentView.bounds.height - 15)
        
        self.backgroundView?.frame = self.bounds.insetBy(dx: 1, dy: 1)
        self.selectionLayer.frame = CGRect(x: self.contentView.frame.origin.x, y: self.contentView.frame.origin.y - 4, width: 30, height: 30)
        
//        self.selectionLayer.frame = CGRect(x: self.contentView.frame.origin.x, y: self.contentView.frame.origin.y - 4, width: self.contentView.bounds.width - 15, height: self.contentView.bounds.height - 15)
//            self.contentView.bounds
        
        
        if selectionType == .middle {
            self.selectionLayer.path = UIBezierPath(rect: self.selectionLayer.bounds).cgPath
        }
        else if selectionType == .leftBorder {
            self.selectionLayer.path = UIBezierPath(roundedRect: self.selectionLayer.bounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: self.selectionLayer.frame.width / 2, height: self.selectionLayer.frame.width / 2)).cgPath
        }
        else if selectionType == .rightBorder {
            self.selectionLayer.path = UIBezierPath(roundedRect: self.selectionLayer.bounds, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: self.selectionLayer.frame.width / 2, height: self.selectionLayer.frame.width / 2)).cgPath
        }
        else if selectionType == .single {
            let diameter: CGFloat = min(self.selectionLayer.frame.height, self.selectionLayer.frame.width)
            self.selectionLayer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2, y: self.contentView.frame.height / 2 - diameter / 2, width: diameter, height: diameter)).cgPath
        }
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        // Override the build-in appearance configuration
        if self.isPlaceholder {
            if let indicator = self.eventIndicator {
                indicator.isHidden = true 
            }
            
            self.titleLabel.textColor = UIColor.lightGray
        }
    }
    
    func drawLine() {
     
        if let layer = lineLayer {
                    layer.isHidden = false
        //            layer.removeFromSuperlayer()
                return
                }
        
        drawLineFromPoint(start: CGPoint(x: 0, y: self.titleLabel.frame.origin.y + self.titleLabel.frame.height + 1 ), toPoint: CGPoint(x: self.contentView.bounds.width, y: self.titleLabel.frame.origin.y + self.titleLabel.frame.height + 1 ), ofColor: ThemeSettings.sharedInstance.fontColor, inView: self.contentView)
    
    }
    
    func undraw() {
      
        
        if let layer = lineLayer {
            layer.isHidden = true
//            layer.removeFromSuperlayer()

        }
    }
    
    
    func drawLineFromPoint(start : CGPoint, toPoint end:CGPoint, ofColor lineColor: UIColor, inView view:UIView) {

        //design the path
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)

        //design path in layer
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = 1.0
        
        lineLayer = shapeLayer
        view.layer.addSublayer(shapeLayer)
    }
    
}
