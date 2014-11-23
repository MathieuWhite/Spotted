//
//  AlertDismissingAnimator.m
//  Spotted
//
//  Created by Mathieu White on 2014-11-22.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import "AlertDismissingAnimator.h"
#import "POP.h"

@interface AlertDismissingAnimator ()

@property (nonatomic) AlertDismissingAnimatorDirection direction;

@end

@implementation AlertDismissingAnimator

#pragma mark - Initialization

- (id) initWithDismissingAnimatorDirection: (AlertDismissingAnimatorDirection) direction
{
    self = [super init];
    
    if (self)
    {
        _direction = direction;
    }
    
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning Methods

- (NSTimeInterval) transitionDuration: (id <UIViewControllerContextTransitioning>) transitionContext
{
    return 0.6f;
}

- (void) animateTransition: (id <UIViewControllerContextTransitioning>) transitionContext
{
    UIViewController *backView = [transitionContext viewControllerForKey: UITransitionContextToViewControllerKey];
    [backView.view setTintAdjustmentMode: UIViewTintAdjustmentModeNormal];
    [backView.view setUserInteractionEnabled: YES];
    
    UIViewController *modal = [transitionContext viewControllerForKey: UITransitionContextFromViewControllerKey];
    
    // Removing the dim on the background view
    __block UIView *dimView;
    [transitionContext.containerView.subviews enumerateObjectsUsingBlock: ^(UIView *view, NSUInteger index, BOOL *stop) {
        if (view.layer.opacity < 1.0f)
        {
            dimView = view;
            *stop = YES;
        }
    }];
    
    POPBasicAnimation *enlightenAnimation = [POPBasicAnimation animationWithPropertyNamed: kPOPLayerOpacity];
    [enlightenAnimation setToValue: @(0.0)];
    [enlightenAnimation setDuration: [self transitionDuration: transitionContext]];
    
    POPBasicAnimation *fallOffScreenAnimation = [POPBasicAnimation animationWithPropertyNamed: kPOPLayerPositionY];
    [fallOffScreenAnimation setToValue: @(CGRectGetMaxY(backView.view.bounds) * 1.5f)];
    [fallOffScreenAnimation setDuration: [self transitionDuration: transitionContext]];
    
    [fallOffScreenAnimation setCompletionBlock: ^(POPAnimation *anim, BOOL finished) {
        [transitionContext completeTransition: YES];
    }];
    
    POPBasicAnimation *scaleOffScreenAnimation = [POPBasicAnimation animationWithPropertyNamed: kPOPLayerScaleXY];
    [scaleOffScreenAnimation setToValue: [NSValue valueWithCGPoint: CGPointMake(0.6, 0.6)]];
    [scaleOffScreenAnimation setDuration: [self transitionDuration: transitionContext]];
    
    POPBasicAnimation *rotateOffScreenAnimation = [POPBasicAnimation animationWithPropertyNamed: kPOPLayerRotation];
    
    if ([self direction] == AlertDismissingAnimatorDirectionLeft)
        [rotateOffScreenAnimation setToValue: @(-M_PI_4)];
    
    else if ([self direction] == AlertDismissingAnimatorDirectionRight)
        [rotateOffScreenAnimation setToValue: @(M_PI_4)];

    [rotateOffScreenAnimation setDuration: [self transitionDuration: transitionContext]];
    
    [modal.view.layer pop_addAnimation: fallOffScreenAnimation forKey: @"fallOffScreenBasicAnimation"];
    [modal.view.layer pop_addAnimation: scaleOffScreenAnimation forKey: @"scaleOffScreenBasicAnimation"];
    [modal.view.layer pop_addAnimation: rotateOffScreenAnimation forKey: @"rotateOffScreenBasicAnimation"];
    [dimView.layer pop_addAnimation: enlightenAnimation forKey: @"enlightenBasicAnimation"];
}

@end
