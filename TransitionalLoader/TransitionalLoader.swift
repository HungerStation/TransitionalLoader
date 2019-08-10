//
//  TransitionalLoader.swift
//  TransitionalLoader
//
//  Created by Ammar Altahhan on 08/08/2019.
//  Copyright © 2019 Ammar Altahhan. All rights reserved.
//

import UIKit

public class TransitionalLoader: UIView {
    
    var didDetermineBounds: ((CGRect)->Void)?
    private var _isLoading: Bool = false
    public var isLoading: Bool {
        return _isLoading
    }
    
    private let lineDashPhase = "lineDashPhase"
    private var dashedLayer = CAShapeLayer()
    private var checkMark: CheckMark!
    
    private var color: UIColor = UIColor.green
    
    private var lineWidth: CGFloat {
        return bounds.width > 40 ? 3 : 2
    }
    
    init(color: UIColor? = .green) {
        self.color = color ?? .green
        super.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        didDetermineBounds?(bounds)
        drawDashedCircle()
    }
    
    private func drawDashedCircle() {
        guard dashedLayer.path == nil else { return }
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.width/2)
        dashedLayer.strokeColor = color.cgColor
        dashedLayer.lineCap = .round
        dashedLayer.lineWidth = lineWidth
        dashedLayer.lineDashPattern = [7,11]
        dashedLayer.backgroundColor = UIColor.clear.cgColor
        dashedLayer.fillColor = UIColor.clear.cgColor
        dashedLayer.path = path.cgPath
        self.layer.addSublayer(dashedLayer)
    }
    
    
    /// Starts loading animation for ever
    public func startAnimation() {
        guard dashedLayer.animation(forKey: lineDashPhase) == nil else { return }
        _isLoading = true
        let lineDashAnimation = CABasicAnimation(keyPath: lineDashPhase)
        lineDashAnimation.fromValue = 0
        lineDashAnimation.toValue = dashedLayer.lineDashPattern?.reduce(0) { $0 + $1.intValue }
        lineDashAnimation.duration = 0.15
        lineDashAnimation.repeatCount = Float.greatestFiniteMagnitude
        
        dashedLayer.add(lineDashAnimation, forKey: lineDashPhase)
    }
    
    
    /// Stops loading animation, and depending on the value of success, shows either `✓` mark or `x`
    ///
    /// - Parameters:
    ///   - success: nil shows `✓` in its original color. true shows a `✓` in green. false shows a `x` in red.
    ///   - completion: Block that returns and takes nothing. Called after animation's stopped.
    public func stopAnimation(success: Bool? = nil, completion: (()->Void)? = nil) {
        
        let spacing = self.dashedLayer.lineDashPattern![1].intValue
        
        guard isLoading else {
            return
        }
        
        _isLoading = false
        
        var i0 = self.dashedLayer.lineDashPattern![0].intValue
        var i1 = spacing
        let totalAnimationTime: TimeInterval = Double(spacing) * 0.06
        
        if let success = success {
            let newColor = success == true ? UIColor.green.cgColor : UIColor.red.cgColor
            let strokeColorAnimation = CABasicAnimation(keyPath: "strokeColor")
            strokeColorAnimation.fromValue = dashedLayer.strokeColor
            strokeColorAnimation.toValue = newColor
            strokeColorAnimation.duration = totalAnimationTime
            strokeColorAnimation.isRemovedOnCompletion = false
            strokeColorAnimation.autoreverses = false
            self.dashedLayer.strokeColor = newColor
            dashedLayer.add(strokeColorAnimation, forKey: "strokeColor")
        }
        
        for i in 1...spacing {
            DispatchQueue.main.asyncAfter(deadline: .now()+(Double(i)*0.06)) {
                i0 += 1
                i1 -= 1
                self.dashedLayer.lineDashPattern![0] = NSNumber(value: i0)
                self.dashedLayer.lineDashPattern![1] = NSNumber(value: i1)
                if i == spacing / 2 {
                    self.showCheckMark(success: success)
                } else if i == spacing {
                    self.dashedLayer.removeAnimation(forKey: self.lineDashPhase)
                    completion?()
                }
            }
        }
    }
    
    private func showCheckMark(success: Bool?) {
        checkMark = CheckMark(success: success, color: color, lineWidth: lineWidth)
        checkMark.translatesAutoresizingMaskIntoConstraints = false
        addSubview(checkMark)
        NSLayoutConstraint.activate([
            checkMark.centerXAnchor.constraint(equalTo: centerXAnchor),
            checkMark.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkMark.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
            checkMark.heightAnchor.constraint(equalTo: checkMark.widthAnchor)
            ])
    }
    
}
