//
//  FadeDismissingAnimator.m
//  Spotted
//
//  Created by Mathieu White on 2014-11-16.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import "FadeDismissingAnimator.h"
#import "POP.h"

@implementation FadeDismissingAnimator

- (NSTimeInterval) transitionDuration: (id <UIViewControllerContextTransitioning>) transitionContext
{
    return 0.6;
}

- (void) animateTransition: (id <UIViewControllerContextTransitioning>) transitionContext
{
    // The view controller that called presentViewController
    UIViewController *viewControllerBehind = [transitionContext viewControllerForKey: UITransitionContextToViewControllerKey];
    [viewControllerBehind.view setTintAdjustmentMode: UIViewTintAdjustmentModeNormal];
    [viewControllerBehind.view setUserInteractionEnabled: YES];
    
    // The current active view controller
    UIViewController *activeViewController = [transitionContext viewControllerForKey: UITransitionContextFromViewControllerKey];
    
    POPBasicAnimation *fadeOutAnimation = [POPBasicAnimation animationWithPropertyNamed: kPOPLayerOpacity];
    [fadeOutAnimation setToValue: @(0.0)];
    [fadeOutAnimation setDuration: [self transitionDuration: transitionContext]];
    
    [fadeOutAnimation setCompletionBlock: ^(POPAnimation *anim, BOOL finished) {
        [transitionContext completeTransition: YES];
    }];
    
    [activeViewController.view.layer pop_addAnimation: fadeOutAnimation forKey: @"fadeOutBasicAnimation"];
}

@end
