//
//  TransitionalLoaderContainer.swift
//  TransitionalLoader
//
//  Created by Ammar Altahhan on 08/08/2019.
//  Copyright © 2019 Ammar Altahhan. All rights reserved.
//

import UIKit


public enum FinishState {
    /// Restores the initial view without any feedback
    case cancel
    /// Shows a success feedback with check mark, optionally in green and restoring the initial view
    case success(restoreView: Bool, inGreen: Bool)
    /// Shows an error feedback with a red cross, optionally restoring the initial view
    case error(restoreView: Bool)
    
    var isRestored: Bool {
        switch self {
        case .cancel:
            return true
        case .success(let restoreView, _):
            return restoreView
        case .error(let restoreView):
            return restoreView
        }
    }
}


class TransitionalLoaderContainer: UIView {
    
    private var initialView: UIView
    private var onTapWhileLoading: FinishState?
    private(set) var loader: TransitionalLoader!
    
    private let animator = UIViewPropertyAnimator(duration: 0.3, curve: .linear)
    
    init(initialView: UIView, onTapWhileLoading: FinishState? = nil) {
        self.initialView = initialView
        self.onTapWhileLoading = onTapWhileLoading
        super.init(frame: initialView.frame)
        backgroundColor = initialView.backgroundColor
        layer.cornerRadius = initialView.layer.cornerRadius
        layer.borderColor = initialView.layer.borderColor
        layer.borderWidth = initialView.layer.borderWidth
        autoresizesSubviews = false
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
        initializeLoader()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    deinit {
        print("Deinit Container")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview == nil {
            initialView = UIView()
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        loadSubviews()
    }
    
    private func initializeLoader() {
        var loadingColor = initialView.backgroundColor
        if initialView.layer.borderWidth > 0, let borderColor = initialView.layer.borderColor {
            loadingColor = UIColor(cgColor: borderColor)
        }
        loader = TransitionalLoader(color: loadingColor)
        
        // Frame's dimension should be equal to the smallest dimension of `initialView`, but not greater than 40 or smaller than 24
        let dimension = max(24, min(40, min(initialView.frame.width, initialView.frame.height)))
        loader.frame = self.rectFromCenter(withSize: CGSize(width: dimension, height: dimension))
    }
    
    private func loadSubviews() {
        guard loader.superview == nil else { return }
        loader.didDetermineBounds = { [weak self] _ in
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
            self?.layer.borderWidth = 0
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
                self?.removeFromSuperview()
            }
        }
    }
    
    func stopAnimation(finishState: FinishState, animationCompletion: (()->Void)? = nil) {
        
        switch finishState {
        case .cancel:
            loader.stopAnimation()
            restoreInitial()
        case .success(let restoreView, let inGreen):
            loader.stopAnimation(success: inGreen ? true : nil) { [weak self] in
                if restoreView {
                    DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                        self?.restoreInitial() {
                            animationCompletion?()
                            self?.removeFromSuperview()
                        }
                    })
                } else {
                    animationCompletion?()
                }
            }
        case .error(let restoreView):
            loader.stopAnimation(success: false) { [weak self] in
                if restoreView {
                    DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                        self?.restoreInitial() {
                            animationCompletion?()
                            self?.removeFromSuperview()
                        }
                    })
                } else {
                    animationCompletion?()
                }
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
        case .cancel:
            restoreInitial()
        }
        
    }
    
}
