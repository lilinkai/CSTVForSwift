//
//  VCAnimatedTransitioning.swift
//  CSTV
//
//  Created by 李林凯 on 16/8/29.
//  Copyright © 2016年 7k7k. All rights reserved.
//

import UIKit

class VCAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containView = transitionContext.containerView()
        containView?.backgroundColor = UIColor.whiteColor()
        
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        toView.frame = UIScreen.mainScreen().bounds;
        
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        fromView.frame = UIScreen.mainScreen().bounds;
        
        toView.transform = CGAffineTransformMakeScale(0.7, 0.7)
        
        containView?.addSubview(toView)
        containView?.insertSubview(fromView, aboveSubview: toView)
        
        let bgView = UIView(frame: UIScreen.mainScreen().bounds)
        containView?.insertSubview(bgView, belowSubview: fromView)
        bgView.backgroundColor = UIColor.blackColor()
        bgView.alpha = 0.3
        
        UIView.animateWithDuration(1, animations: { () -> Void in
            toView.transform = CGAffineTransformMakeScale(1, 1)
            fromView.transform = CGAffineTransformMakeTranslation(0, UIScreen.mainScreen().bounds.height)
        }) { (finished) -> Void in
            bgView.removeFromSuperview()
            toView.transform = CGAffineTransformScale(toView.transform, 1, 1)
            transitionContext.completeTransition(true)
        }
    }
}
