//
//  Animator.swift
//  GourmetApp
//
//  Created by 岩瀬　駿 on 2015/07/05.
//  Copyright (c) 2015年 岩瀬　駿. All rights reserved.
//

import Foundation

class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    let kDuration = 0.1
    var presenting = false // 遷移するときtrue（戻るときfalse）
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return kDuration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        // 遷移するときと戻るときとで処理を変える
        if presenting {
            presentTransition(transitionContext, toView: toVC!.view, fromView: fromVC!.view)
        } else {
            dismissTransition(transitionContext, toView: toVC!.view, fromView: fromVC!.view)
        }
    }
    
    // 遷移するときのアニメーション
    func presentTransition(transitionContext: UIViewControllerContextTransitioning, toView: UIView, fromView: UIView) {
        let containerView = transitionContext.containerView()
        containerView.insertSubview(toView, aboveSubview: fromView) // toViewの下にfromView
        toView.alpha = 0.0
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            toView.alpha = 1.0
            }) { (finished) -> Void in
                transitionContext.completeTransition(true)
        }
    }
    
    // 戻るときのアニメーション
    func dismissTransition(transitionContext: UIViewControllerContextTransitioning, toView: UIView, fromView: UIView) {
        let containerView = transitionContext.containerView()
        containerView.insertSubview(toView, belowSubview: fromView) // fromViewの下にtoView
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            fromView.frame = CGRectOffset(fromView.frame, 0, 0)
            toView.alpha = 1.0
            }) { (finished) -> Void in
                transitionContext.completeTransition(true)
        }
    }
}