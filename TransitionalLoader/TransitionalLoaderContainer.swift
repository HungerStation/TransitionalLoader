//
//  TransitionalLoaderContainer.swift
//  TransitionalLoader
//
//  Created by Ammar Altahhan on 08/08/2019.
//  Copyright © 2019 Ammar Altahhan. All rights reserved.
//

import Foundation


public enum ForceFinishState {
    case success(restoreView: Bool, inGreen: Bool)
    case error(restoreView: Bool)
}


class TransitionalLoaderContainer: UIView {
    
    private var initialView: UIView
    private var onTapWhileLoading: ForceFinishState?
    private(set) lazy var loader = TransitionalLoader(color: initialView.backgroundColor)
    
    private let animator = UIViewPropertyAnimator(duration: 0.3, curve: .linear)
    
    init(initialView: UIView, onTapWhileLoading: ForceFinishState? = nil) {
        self.initialView = initialView
        self.onTapWhileLoading = onTapWhileLoading
        super.init(frame: initialView.frame)
        backgroundColor = initialView.backgroundColor
        layer.cornerRadius = initialView.layer.cornerRadius
        layer.borderColor = initialView.layer.borderColor
        layer.borderWidth = initialView.layer.borderWidth
        autoresizesSubviews = false
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        loader.frame = self.rectFromCenter(withSize: CGSize(width: 40, height: 40))
        loadSubviews()
    }
    
    private func loadSubviews() {
        guard loader.superview == nil else { return }
        loader.didDetermineBounds = { [weak self] _ in
            print("didDetermineBounds")
            self?.startAnimating()
        }
        addLoader()
    }
    
    private func addLoader() {
        guard loader.superview == nil else { return }
        loader.alpha = 0
        addSubview(loader)
        loader.frame = bounds
    }
    
    private func startAnimating(reversed: Bool = false, completion: (()->Void)? = nil) {
        
        let diffX = !reversed ? initialView.bounds.width-loader.bounds.width : loader.bounds.width-initialView.bounds.width
        print("diffX \(diffX)")
        let diffY = !reversed ? initialView.bounds.height-loader.bounds.height : loader.bounds.height-initialView.bounds.height
        let size = !reversed ? CGSize(width: loader.bounds.width, height: loader.bounds.height) :  CGSize(width: initialView.bounds.width, height: initialView.bounds.height)
        let originPoint = CGPoint(x: self.frame.origin.x + (diffX/2), y: self.frame.origin.y + (diffY/2))
        let cornerRadius = !reversed ? self.loader.bounds.width/2 : initialView.layer.cornerRadius
        animator.addAnimations {
            self.frame.size = size
            self.frame.origin = originPoint
            self.layer.cornerRadius = cornerRadius
        }
        
        animator.addCompletion { [weak self] (_) in
            UIView.animate(withDuration: 0.1, animations: {
                self?.loader.alpha = !reversed ? 1 : 0
                self?.backgroundColor = !reversed ? nil : self?.initialView.backgroundColor
            })
            !reversed ? self?.loader.startAnimation() : self?.loader.stopAnimation()
            self?.animator.stopAnimation(true)
            completion?()
        }
        
        animator.startAnimation()
    }
    
    
    /// This function restores the initial view to its original place and look.
    /// - warning: Don't call this function directly. Call `stopAnimation(success:completion:)` on the Loader object instead
    func restoreInitial(animationCompletion: (()->Void)? = nil) {
        UIView.animate(withDuration: 0.1, animations: {
            self.backgroundColor = self.initialView.backgroundColor
            self.alpha = 1
            self.loader.alpha = 0
        })
        startAnimating(reversed: true) { [weak self] in
            UIView.animate(withDuration: 0.2, animations: {
                self?.initialView.alpha = 1
                self?.initialView.subviews.forEach({$0.alpha = 1})
                self?.alpha = 0
            }) { bool in
                animationCompletion?()
            }
        }
    }
    
    @objc private func didTap() {
        guard let action = onTapWhileLoading, loader.isLoading else { return }
        
        switch action {
        case .error(let restore):
            loader.stopAnimation(success: false) {
                if restore {
                    DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                        self.restoreInitial()
                    })
                }
            }
        case .success(let restore, let inGreen):
            loader.stopAnimation(success: inGreen ? true : nil) {
                if restore {
                    DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                        self.restoreInitial()
                    })
                }
            }
        }
    }
    
}
