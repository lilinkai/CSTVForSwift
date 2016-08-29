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
        return 0.5
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
        
        let bgView = UIView(frame: CGRect.init(x: 0, y: 64, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height))
        containView?.insertSubview(bgView, belowSubview: fromView)
        bgView.backgroundColor = UIColor.blackColor()
        bgView.alpha = 0.4
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            bgView.alpha = 0
            toView.transform = CGAffineTransformMakeScale(1, 1)
            fromView.transform = CGAffineTransformMakeTranslation(0, UIScreen.mainScreen().bounds.height)
        }) { (finished) -> Void in
            bgView.removeFromSuperview()
            toView.transform = CGAffineTransformScale(toView.transform, 1, 1)
            transitionContext.completeTransition(true)
        }
    }
}
