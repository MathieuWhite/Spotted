//
//  AlertPresentingAnimator.m
//  Spotted
//
//  Created by Mathieu White on 2014-11-22.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import "AlertPresentingAnimator.h"
#import "POP.h"

@interface AlertPresentingAnimator ()

@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, weak) UIView *dimView;
@property (nonatomic, weak) UIView *modal;

@end

@implementation AlertPresentingAnimator

#pragma mark - UIViewControllerAnimatedTransitioning Methods

- (NSTimeInterval) transitionDuration: (id <UIViewControllerContextTransitioning>) transitionContext
{
    return 0.4f;
}

- (void) animateTransition: (id <UIViewControllerContextTransitioning>) transitionContext
{
    // The view behind the modal
    UIView *backView = [[transitionContext viewControllerForKey: UITransitionContextFromViewControllerKey] view];
    [backView setTintAdjustmentMode: UIViewTintAdjustmentModeDimmed];
    [backView setUserInteractionEnabled: NO];
    
    // The view overlayed on the back view
    UIView *dimView = [[UIView alloc] init];
    [dimView setTranslatesAutoresizingMaskIntoConstraints: NO];
    [dimView setBackgroundColor: [UIColor blackColor]];
    [dimView.layer setOpacity: 0.0f];
    
    // The modal view
    UIView *modal = [[transitionContext viewControllerForKey: UITransitionContextToViewControllerKey] view];
    [modal setTranslatesAutoresizingMaskIntoConstraints: NO];
    
    // Add the views to the context
    [transitionContext.containerView addSubview: dimView];
    [transitionContext.containerView addSubview: modal];
    
    // Set each component to its property
    [self setContainerView: transitionContext.containerView];
    [self setDimView: dimView];
    [self setModal: modal];
    
    // Auto Layout
    [self setupConstraints];
    
    // Animations
    POPSpringAnimation *appearOnScreenAnimation = [POPSpringAnimation animationWithPropertyNamed: kPOPLayerPositionY];
    [appearOnScreenAnimation setFromValue: @(-transitionContext.containerView.center.y)];
    [appearOnScreenAnimation setToValue: @(transitionContext.containerView.center.y)];
    [appearOnScreenAnimation setSpringBounciness: 8.0f];
    [appearOnScreenAnimation setSpringSpeed: 16.0f];
    
    [appearOnScreenAnimation setCompletionBlock: ^(POPAnimation *anim, BOOL finished) {
        [transitionContext completeTransition: YES];
    }];
    
    POPBasicAnimation *dimmingAnimation = [POPBasicAnimation animationWithPropertyNamed: kPOPLayerOpacity];
    [dimmingAnimation setToValue: @(0.65)];
    [dimmingAnimation setDuration: [self transitionDuration: transitionContext]];
    
    [modal.layer pop_addAnimation: appearOnScreenAnimation forKey: @"appearOnScreenSpringAnimation"];
    [dimView.layer pop_addAnimation: dimmingAnimation forKey: @"dimmingBasicAnimation"];
}

#pragma mark - Auto Layout Method

- (void) setupConstraints
{
    // Views Dictionary for Auto Layout
    NSDictionary *views = @{@"dimView" : [self dimView]};
    
    // Dim View Horizontal Constraints
    NSArray *dimViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat: @"H:|[dimView]|"
                                                                                    options: 0
                                                                                    metrics: nil
                                                                                      views: views];
    // Dim View Vertical Constraints
    NSArray *dimViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat: @"V:|[dimView]|"
                                                                                  options: 0
                                                                                  metrics: nil
                                                                                    views: views];
    
    // Add the constraints to the context view
    [self.containerView addConstraints: dimViewHorizontalConstraints];
    [self.containerView addConstraints: dimViewVerticalConstraints];
    
    // Modal Center X
    [self.containerView addConstraint: [NSLayoutConstraint constraintWithItem: self.modal
                                                                    attribute: NSLayoutAttributeCenterX
                                                                    relatedBy: NSLayoutRelationEqual
                                                                       toItem: self.containerView
                                                                    attribute: NSLayoutAttributeCenterX
                                                                   multiplier: 1.0f
                                                                     constant: 0.0f]];
    
    // Modal Center Y
    [self.containerView addConstraint: [NSLayoutConstraint constraintWithItem: self.modal
                                                                    attribute: NSLayoutAttributeCenterY
                                                                    relatedBy: NSLayoutRelationEqual
                                                                       toItem: self.containerView
                                                                    attribute: NSLayoutAttributeCenterY
                                                                   multiplier: -1.0f
                                                                     constant: 0.0f]];
    
    // Modal Width
    [self.containerView addConstraint: [NSLayoutConstraint constraintWithItem: self.modal
                                                                    attribute: NSLayoutAttributeWidth
                                                                    relatedBy: NSLayoutRelationEqual
                                                                       toItem: self.containerView
                                                                    attribute: NSLayoutAttributeWidth
                                                                   multiplier: 1.0f
                                                                     constant: 0.0f]];
    
    // Modal Height
    [self.containerView addConstraint: [NSLayoutConstraint constraintWithItem: self.modal
                                                                    attribute: NSLayoutAttributeHeight
                                                                    relatedBy: NSLayoutRelationEqual
                                                                       toItem: self.containerView
                                                                    attribute: NSLayoutAttributeHeight
                                                                   multiplier: 1.0f
                                                                     constant: 0.0f]];
}

@end
