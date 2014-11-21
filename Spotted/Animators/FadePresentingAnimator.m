//
//  FadePresentingAnimator.m
//  Spotted
//
//  Created by Mathieu White on 2014-11-16.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import "FadePresentingAnimator.h"
#import "POP.h"

@implementation FadePresentingAnimator

- (NSTimeInterval) transitionDuration: (id <UIViewControllerContextTransitioning>) transitionContext
{
    return 0.6f;
}

- (void) animateTransition: (id <UIViewControllerContextTransitioning>) transitionContext
{
    // The view calling presentViewController
    UIView *currentView = [[transitionContext viewControllerForKey: UITransitionContextFromViewControllerKey] view];
    [currentView setTintAdjustmentMode: UIViewTintAdjustmentModeDimmed];
    [currentView setUserInteractionEnabled: NO];
    
    // The view being presented
    UIView *modalView = [[transitionContext viewControllerForKey: UITransitionContextToViewControllerKey] view];
    [modalView setTranslatesAutoresizingMaskIntoConstraints: NO];
    [modalView.layer setOpacity: 0.0f];
    
    // Add the modalView to the context
    [transitionContext.containerView addSubview: modalView];
    
    // Views Dictionary for Auto Layout
    NSDictionary *views = @{@"modalView" : modalView};
    
    // Modal View Horizontal Constraints
    NSArray *modalViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat: @"H:|[modalView]|"
                                                                                      options: 0
                                                                                      metrics: nil
                                                                                        views: views];
    // Modal View Vertical Constraints
    NSArray *modalViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat: @"V:|[modalView]|"
                                                                                    options: 0
                                                                                    metrics: nil
                                                                                      views: views];
    // Add the constraints to the context view
    [transitionContext.containerView addConstraints: modalViewHorizontalConstraints];
    [transitionContext.containerView addConstraints: modalViewVerticalConstraints];
    
    // The animation
    POPBasicAnimation *fadeInAnimation = [POPBasicAnimation animationWithPropertyNamed: kPOPLayerOpacity];
    [fadeInAnimation setToValue: @(1.0)];
    [fadeInAnimation setDuration: [self transitionDuration: transitionContext]];
    
    [fadeInAnimation setCompletionBlock: ^(POPAnimation *anim, BOOL finished) {
        [transitionContext completeTransition: YES];
    }];
    
    [modalView.layer pop_addAnimation: fadeInAnimation forKey: @"fadeInBasicAnimation"];
}

@end
