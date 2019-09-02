//
//  CheckMark.swift
//  TransitionalLoader
//
//  Created by Ammar Altahhan on 08/08/2019.
//  Copyright © 2019 Ammar Altahhan. All rights reserved.
//

import UIKit

class Mark: UIView {
    
    private let path = UIBezierPath()
    private let pathLayer = CAShapeLayer()
    
    private var success: Bool?
    private var animated: Bool
    private var color: UIColor
    private var lineWidth: CGFloat
    private var duration: TimeInterval
    
    
    /// Initialize a check mark `✓` by default with the given `color` unless `success` is provided, which overrides the drawn shape to be a green `✓` or a red `x`
    ///
    /// - Parameters:
    ///   - success: Rendered state. success == true, failure == false
    ///   - color: color of the `✓` mark
    ///   - lineWidth: width the the marks drawn
    ///   - animated: animate drawing marks or not
    ///   - duration: duration of animation, if any
    init(success: Bool?, color: UIColor, lineWidth: CGFloat, animated: Bool = true, duration: TimeInterval = 0.5) {
        self.success = success
        self.animated = animated
        self.color = color
        self.lineWidth = lineWidth
        self.duration = duration
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        drawMark()
    }
    
    
    /// Start drawing either `✓` or `x` depending on the value of `success`
    private func drawMark() {
        guard pathLayer.path == nil else { return }
        
        pathLayer.frame = bounds
        pathLayer.fillColor = UIColor.clear.cgColor
        pathLayer.backgroundColor = UIColor.clear.cgColor
        pathLayer.lineWidth = lineWidth
        pathLayer.lineCap = .round
        pathLayer.lineJoin = .round
        
        if success != false {
            drawCheck()
        } else {
            drawX()
        }
        
        animatePath()
    }
    
    
    /// Draws a `✓`, either in the same or origin `color` or in green depending on the value of success
    private func drawCheck() {
        let rect = bounds
        
        let xRatio = rect.maxX/2.8
        let yRatio = rect.maxY/6.5
        path.move(to: CGPoint(x: 0, y: rect.midY))
        path.addLine(to: CGPoint(x: xRatio, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY+yRatio))
        
        pathLayer.path = path.cgPath
        pathLayer.strokeColor = color.cgColor
        
        if success == true {
            pathLayer.strokeColor = UIColor.green.cgColor
        }
    }
    
    
    /// Draws a red `✓` regardless of any condition
    private func drawX() {
        let rect = bounds
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.move(to: CGPoint(x: rect.maxX, y: 0))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY))
        
        pathLayer.path = path.cgPath
        pathLayer.strokeColor = UIColor.red.cgColor
    }
    
    
    /// Aniamte the drawing of all marks. Adds a shake animation to the `x` mark
    private func animatePath() {
        if animated {
            let pathAnimation = CABasicAnimation(keyPath:"strokeEnd")
            pathAnimation.fromValue = NSNumber(floatLiteral: 0)
            pathAnimation.toValue = NSNumber(floatLiteral: 1)
            pathAnimation.duration = duration
            layer.addSublayer(pathLayer)
            pathLayer.removeAllAnimations()
            pathLayer.add(pathAnimation, forKey:"strokeEnd")
            if success == false {
                let shakeAnimation = CABasicAnimation(keyPath: "position")
                shakeAnimation.duration = 0.08
                shakeAnimation.repeatCount = 4
                shakeAnimation.autoreverses = true
                shakeAnimation.fromValue = NSValue(cgPoint: CGPoint(x: center.x - 1, y: center.y - 1))
                shakeAnimation.toValue = NSValue(cgPoint: CGPoint(x: center.x + 1, y: center.y + 1))
                layer.add(shakeAnimation, forKey: "position")
            }
            CATransaction.commit()
        } else {
            layer.addSublayer(pathLayer)
            pathLayer.removeAllAnimations()
        }
    }
    
}
