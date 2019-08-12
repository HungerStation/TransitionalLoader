//
//  UIView+TransitionalLoader.swift
//  TransitionalLoader
//
//  Created by Ammar Altahhan on 08/08/2019.
//  Copyright © 2019 Ammar Altahhan. All rights reserved.
//

import UIKit

extension UIView {
    
    
    /// Aniamtes the called on view from its current size and position to a loader in the middle and starts animating directly.
    ///
    /// - Parameter onTapWhileLoading: Fall back action for when the user taps on the loader before explicitly calling `stopLoader(success:restoreView)`. `nil` ignores user action.
    public func startLoader(onTapWhileLoading: FinishState? = nil) {
        UIView.animate(withDuration: 0.1, animations: {
            self.subviews.forEach({$0.alpha = 0})
        })
        DispatchQueue.main.asyncAfter(deadline: .now()+0.08) {
            let container = TransitionalLoaderContainer(initialView: self, onTapWhileLoading: onTapWhileLoading)
            
            container.tag = 425612
            self.superview?.addSubview(container)
            self.alpha = 0
        }
    }
    
    
    /// Stops the loader started by `startLoader(onTapWhileLoading:)` or by `startLoader()` if any.
    ///
    /// - Parameters:
    ///   - finishState: Determines the state to finish the animation with.
    public func stopLoader(finishState: FinishState, animationCompletion: (()->Void)? = nil) {
        guard let container = superview?.viewWithTag(425612) as? TransitionalLoaderContainer else { return }
        
        container.stopAnimation(finishState: finishState, animationCompletion: animationCompletion)
    }
    
    
    /// Helper function to get a CGRect that's centered in current's view center with specific size.
    ///
    ///                     _____________
    ///                    |    _____    |
    ///                    |   |     |   |
    ///                    |   |  .  |   |
    ///                    |   |     |   |
    ///                    |    ‾‾‾‾‾    |
    ///                     ‾‾‾‾‾‾‾‾‾‾‾‾‾‾
    ///
    func rectFromCenter(withSize size: CGSize) -> CGRect {
        return CGRect(x: (bounds.width/2)-(size.width/2), y: (bounds.height/2)-(size.height/2), width: size.width, height: size.height)
    }
}
