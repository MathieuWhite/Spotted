//
//  AlertViewController.m
//  Spotted
//
//  Created by Mathieu White on 2014-11-22.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import "AlertViewController.h"
#import "AlertPresentingAnimator.h"
#import "AlertDismissingAnimator.h"
#import "SPFlatButton.h"

@interface AlertViewController ()

@property (nonatomic, copy) NSString *alertTitle;
@property (nonatomic, copy) NSString *alertMessage;
@property (nonatomic, copy) NSString *dismissButtonTitle;
@property (nonatomic, copy) NSString *actionButtonTitle;

@property (nonatomic, weak) UIView *alertView;

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *messageLabel;

@property (nonatomic, weak) UIButton *dismissButton;
@property (nonatomic, weak) UIButton *actionButton;

@property (nonatomic, strong) AlertDismissingAnimator *dismissingAnimator;

@end

@implementation AlertViewController

#pragma mark - Initialization

- (id) init
{
    self = [super init];
    
    if (self)
    {
        [self setModalPresentationStyle: UIModalPresentationCustom];
        [self setTransitioningDelegate: self];
        [self.view setTranslatesAutoresizingMaskIntoConstraints: NO];
    }
    
    return self;
}

- (instancetype) initWithTitle: (NSString *) title
                       message: (NSString *) message
                      delegate: (id) delegate
            dismissButtonTitle: (NSString *) dismissButtonTitle
             actionButtonTitle: (NSString *) actionButtonTitle
{
    self = [super init];
    
    if (self)
    {
        _alertTitle = title;
        _alertMessage = message;
        _delegate = delegate;
        _dismissButtonTitle = dismissButtonTitle;
        _actionButtonTitle = actionButtonTitle;
        
        [self setTitle: title];
        [self setModalPresentationStyle: UIModalPresentationCustom];
        [self setTransitioningDelegate: self];
        [self.view setTranslatesAutoresizingMaskIntoConstraints: NO];
    }
    
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    // Set the background color
    [self.view setBackgroundColor: [UIColor clearColor]];
    
    // Initialize the alert view
    UIView *alertView = [[UIView alloc] init];
    [alertView setBackgroundColor: [UIColor colorWithWhite: 1.0f alpha: 0.9f]];
    [alertView.layer setCornerRadius: 8.0f];
    [alertView setTranslatesAutoresizingMaskIntoConstraints: NO];
    
    // Initialize the title label
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setText: [self alertTitle]];
    [titleLabel setTextColor: [UIColor blackColor]];
    [titleLabel setFont: [UIFont fontWithName: @"Avenir" size: 18.0f]];
    [titleLabel setTextAlignment: NSTextAlignmentCenter];
    [titleLabel setAdjustsFontSizeToFitWidth: YES];
    [titleLabel setTranslatesAutoresizingMaskIntoConstraints: NO];
    
    // Initialize the title label
    UILabel *messageLabel = [[UILabel alloc] init];
    [messageLabel setText: [self alertMessage]];
    [messageLabel setTextColor: [UIColor blackColor]];
    [messageLabel setFont: [UIFont fontWithName: @"Avenir-Light" size: 14.0f]];
    [messageLabel setTextAlignment: NSTextAlignmentCenter];
    [messageLabel setNumberOfLines: 0];
    [messageLabel setLineBreakMode: NSLineBreakByWordWrapping];
    [messageLabel setTranslatesAutoresizingMaskIntoConstraints: NO];
    
    // Add the components to the alert view
    [alertView addSubview: titleLabel];
    [alertView addSubview: messageLabel];
    
    // Add the alert view to the view controller
    [self.view addSubview: alertView];
    
    // Set each component to its property
    [self setAlertView: alertView];
    [self setTitleLabel: titleLabel];
    [self setMessageLabel: messageLabel];
    
    // Setup the buttons
    [self setupButtons];
    
    // Auto Layout
    [self setupConstraints];    
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Public Instance Methods

- (void) setTintColor: (UIColor *) color;
{
    [self.dismissButton setTintColor: color];
    [self.actionButton setTintColor: color];
}

- (void) setActionButtonTintColor: (UIColor *) color
{
    [self.actionButton setTintColor: color];
}

#pragma mark - Private Instance methods

- (void) setupButtons
{
    UIButton *dismissButton = [UIButton buttonWithType: UIButtonTypeSystem];
    [dismissButton setTitle: [self dismissButtonTitle] forState: UIControlStateNormal];
    [dismissButton setTintColor: [UIColor blueColor]];
    [dismissButton.titleLabel setFont: [UIFont fontWithName: @"Avenir" size: 18.0f]];
    [dismissButton setTranslatesAutoresizingMaskIntoConstraints: NO];
    [dismissButton addTarget: self action: @selector(dismissAlertView) forControlEvents: UIControlEventTouchUpInside];

    [self.alertView addSubview: dismissButton];
    
    [self setDismissButton: dismissButton];
    
    if ([self actionButtonTitle])
    {
        UIButton *actionButton = [UIButton buttonWithType: UIButtonTypeSystem];
        [actionButton setTitle: [self actionButtonTitle] forState: UIControlStateNormal];
        [actionButton setTintColor: [UIColor blueColor]];
        [actionButton.titleLabel setFont: [UIFont fontWithName: @"Avenir" size: 18.0f]];
        [actionButton setTranslatesAutoresizingMaskIntoConstraints: NO];
        [actionButton addTarget: self action: @selector(handleAction) forControlEvents: UIControlEventTouchUpInside];
        
        [self.alertView addSubview: actionButton];
        
        [self setActionButton: actionButton];
    }
}

- (void) dismissAlertView
{
    AlertDismissingAnimator *dismissingAnimator;
    
    if ([self actionButton])
        dismissingAnimator = [[AlertDismissingAnimator alloc] initWithDismissingAnimatorDirection: AlertDismissingAnimatorDirectionLeft];
    else
        dismissingAnimator = [[AlertDismissingAnimator alloc] initWithDismissingAnimatorDirection: AlertDismissingAnimatorDirectionRight];
    
    [self setDismissingAnimator: dismissingAnimator];
    
    [self dismissViewControllerAnimated: YES completion: NULL];
    
    if ([self.delegate respondsToSelector: @selector(alertViewController:didDismissWithButtonIndex:)])
        [self.delegate alertViewController: self didDismissWithButtonIndex: 0];
}

- (void) handleAction
{
    AlertDismissingAnimator *dismissingAnimator = [[AlertDismissingAnimator alloc]
                                                   initWithDismissingAnimatorDirection: AlertDismissingAnimatorDirectionRight];
    [self setDismissingAnimator: dismissingAnimator];
    
    [self dismissViewControllerAnimated: YES completion: NULL];
    
    if ([self.delegate respondsToSelector: @selector(alertViewController:didDismissWithButtonIndex:)])
        [self.delegate alertViewController: self didDismissWithButtonIndex: 1];
}

#pragma mark - Auto Layout Method

- (void) setupConstraints
{
    // Alert View Width
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.alertView
                                                           attribute: NSLayoutAttributeWidth
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.view
                                                           attribute: NSLayoutAttributeWidth
                                                          multiplier: 0.0f
                                                            constant: 270.0f]];
    
    // Alert View Center X
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.alertView
                                                           attribute: NSLayoutAttributeCenterX
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.view
                                                           attribute: NSLayoutAttributeCenterX
                                                          multiplier: 1.0f
                                                            constant: 0.0f]];
    
    // Alert View Center Y
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.alertView
                                                           attribute: NSLayoutAttributeCenterY
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.view
                                                           attribute: NSLayoutAttributeCenterY
                                                          multiplier: 1.0f
                                                            constant: 0.0f]];
    
    // Title Label Top
    [self.alertView addConstraint: [NSLayoutConstraint constraintWithItem: self.titleLabel
                                                                attribute: NSLayoutAttributeTop
                                                                relatedBy: NSLayoutRelationEqual
                                                                   toItem: self.alertView
                                                                attribute: NSLayoutAttributeTop
                                                               multiplier: 1.0f
                                                                 constant: 20.0f]];
    
    // Title Label Left
    [self.alertView addConstraint: [NSLayoutConstraint constraintWithItem: self.titleLabel
                                                                attribute: NSLayoutAttributeLeft
                                                                relatedBy: NSLayoutRelationEqual
                                                                   toItem: self.alertView
                                                                attribute: NSLayoutAttributeLeft
                                                               multiplier: 1.0f
                                                                 constant: 20.0f]];
    
    // Title Label Right
    [self.alertView addConstraint: [NSLayoutConstraint constraintWithItem: self.titleLabel
                                                                attribute: NSLayoutAttributeRight
                                                                relatedBy: NSLayoutRelationEqual
                                                                   toItem: self.alertView
                                                                attribute: NSLayoutAttributeRight
                                                               multiplier: 1.0f
                                                                 constant: -20.0f]];
    
    // Message Label Top
    [self.alertView addConstraint: [NSLayoutConstraint constraintWithItem: self.messageLabel
                                                                attribute: NSLayoutAttributeTop
                                                                relatedBy: NSLayoutRelationEqual
                                                                   toItem: self.titleLabel
                                                                attribute: NSLayoutAttributeBottom
                                                               multiplier: 1.0f
                                                                 constant: 6.0f]];
    
    // Message Label Left
    [self.alertView addConstraint: [NSLayoutConstraint constraintWithItem: self.messageLabel
                                                                attribute: NSLayoutAttributeLeft
                                                                relatedBy: NSLayoutRelationEqual
                                                                   toItem: self.alertView
                                                                attribute: NSLayoutAttributeLeft
                                                               multiplier: 1.0f
                                                                 constant: 20.0f]];
    
    // Message Label Right
    [self.alertView addConstraint: [NSLayoutConstraint constraintWithItem: self.messageLabel
                                                                attribute: NSLayoutAttributeRight
                                                                relatedBy: NSLayoutRelationEqual
                                                                   toItem: self.alertView
                                                                attribute: NSLayoutAttributeRight
                                                               multiplier: 1.0f
                                                                 constant: -20.0f]];
    
    // Dismiss Button Top
    [self.alertView addConstraint: [NSLayoutConstraint constraintWithItem: self.dismissButton
                                                                attribute: NSLayoutAttributeTop
                                                                relatedBy: NSLayoutRelationEqual
                                                                   toItem: self.messageLabel
                                                                attribute: NSLayoutAttributeBottom
                                                               multiplier: 1.0f
                                                                 constant: 10.0f]];
    
    // Dismiss Button Left
    [self.alertView addConstraint: [NSLayoutConstraint constraintWithItem: self.dismissButton
                                                                attribute: NSLayoutAttributeLeft
                                                                relatedBy: NSLayoutRelationEqual
                                                                   toItem: self.alertView
                                                                attribute: NSLayoutAttributeLeft
                                                               multiplier: 1.0f
                                                                 constant: 20.0f]];
    
    if ([self actionButton])
    {
        // Action Button Top
        [self.alertView addConstraint: [NSLayoutConstraint constraintWithItem: self.actionButton
                                                                    attribute: NSLayoutAttributeTop
                                                                    relatedBy: NSLayoutRelationEqual
                                                                       toItem: self.dismissButton
                                                                    attribute: NSLayoutAttributeTop
                                                                   multiplier: 1.0f
                                                                     constant: 0.0f]];
        
        // Action Button Left
        [self.alertView addConstraint: [NSLayoutConstraint constraintWithItem: self.actionButton
                                                                    attribute: NSLayoutAttributeLeft
                                                                    relatedBy: NSLayoutRelationEqual
                                                                       toItem: self.alertView
                                                                    attribute: NSLayoutAttributeCenterX
                                                                   multiplier: 1.0f
                                                                     constant: 10.0f]];
        
        // Action Button Right
        [self.alertView addConstraint: [NSLayoutConstraint constraintWithItem: self.actionButton
                                                                    attribute: NSLayoutAttributeRight
                                                                    relatedBy: NSLayoutRelationEqual
                                                                       toItem: self.alertView
                                                                    attribute: NSLayoutAttributeRight
                                                                   multiplier: 1.0f
                                                                     constant: -20.0f]];
        
        // Dismiss Button Right
        [self.alertView addConstraint: [NSLayoutConstraint constraintWithItem: self.dismissButton
                                                                    attribute: NSLayoutAttributeRight
                                                                    relatedBy: NSLayoutRelationEqual
                                                                       toItem: self.alertView
                                                                    attribute: NSLayoutAttributeCenterX
                                                                   multiplier: 1.0f
                                                                     constant: -10.0f]];
    }
    
    else
    {
        // Dismiss Button Right
        [self.alertView addConstraint: [NSLayoutConstraint constraintWithItem: self.dismissButton
                                                                    attribute: NSLayoutAttributeRight
                                                                    relatedBy: NSLayoutRelationEqual
                                                                       toItem: self.alertView
                                                                    attribute: NSLayoutAttributeRight
                                                                   multiplier: 1.0f
                                                                     constant: -20.0f]];
    }
    
    // Alert View Height
    [self.alertView setNeedsLayout];
    [self.alertView layoutIfNeeded];
    
    CGFloat alertViewHeight = CGRectGetHeight([self.titleLabel bounds]) +
                              CGRectGetHeight([self.messageLabel bounds]) +
                              CGRectGetHeight([self.dismissButton bounds]) + 44.0f;
    
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.alertView
                                                           attribute: NSLayoutAttributeHeight
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.view
                                                           attribute: NSLayoutAttributeHeight
                                                          multiplier: 0.0f
                                                            constant: alertViewHeight]];
}

#pragma mark - UIViewControllerTransitioningDelegate Methods

- (id <UIViewControllerAnimatedTransitioning>) animationControllerForPresentedController: (UIViewController *) presented
                                                                    presentingController: (UIViewController *) presenting
                                                                        sourceController: (UIViewController *) source
{
    return [[AlertPresentingAnimator alloc] init];
}

- (id <UIViewControllerAnimatedTransitioning>) animationControllerForDismissedController: (UIViewController *) dismissed
{
    return [self dismissingAnimator];
}

@end
