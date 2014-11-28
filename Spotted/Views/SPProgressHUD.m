//
//  SPProgressHUD.m
//  Spotted
//
//  Created by Mathieu White on 2014-11-27.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import "SPProgressHUD.h"

@interface SPProgressHUD ()

@property (nonatomic, assign) SPProgressHUDStyle style;

@property (nonatomic, copy) NSString *indicatorTitle;

@property (nonatomic, weak) UIView *indicatorView;

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIActivityIndicatorView *spinner;

@end

@implementation SPProgressHUD

#pragma mark - Initialization

- (instancetype) initWithTitle: (NSString *) title style: (SPProgressHUDStyle) style
{
    self = [super init];
    
    if (self)
    {
        _indicatorTitle = title;
        _style = style;
        
        [self initProgressHUD];
    }
    
    return self;
}

- (void) initProgressHUD
{
    // Set the dim background color
    [self setBackgroundColor: [UIColor colorWithWhite: 0.0f alpha: 0.65f]];
    
    // Initialize the indicator view
    UIView *indicatorView = [[UIView alloc] init];
    
    if (self.style == SPProgressHUDStyleLight)
        [indicatorView setBackgroundColor: [UIColor colorWithWhite: 1.0f alpha: 0.65f]];
    else if (self.style == SPProgressHUDStyleDark)
        [indicatorView setBackgroundColor: [UIColor colorWithWhite: 0.0f alpha: 0.65f]];
    
    [indicatorView.layer setCornerRadius: 4.0f];
    [indicatorView setTranslatesAutoresizingMaskIntoConstraints: NO];
    
    // Initialize the title label
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setText: [self indicatorTitle]];
    
    if (self.style == SPProgressHUDStyleLight)
        [titleLabel setTextColor: [UIColor blackColor]];
    else if (self.style == SPProgressHUDStyleDark)
        [titleLabel setTextColor: [UIColor whiteColor]];

    [titleLabel setFont: [UIFont fontWithName: @"Avenir" size: 16.0f]];
    [titleLabel setTextAlignment: NSTextAlignmentCenter];
    [titleLabel setAdjustsFontSizeToFitWidth: YES];
    [titleLabel setTranslatesAutoresizingMaskIntoConstraints: NO];
    
    // Initialize the activity indicator
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] init];
    
    if (self.style == SPProgressHUDStyleLight)
        [spinner setColor: [UIColor blackColor]];
    else if (self.style == SPProgressHUDStyleDark)
        [spinner setColor: [UIColor whiteColor]];
    
    [spinner setTranslatesAutoresizingMaskIntoConstraints: NO];
    [spinner startAnimating];
    
    // Add the components to the indicator view
    [indicatorView addSubview: titleLabel];
    [indicatorView addSubview: spinner];
    
    // Add the indicator view to the view
    [self addSubview: indicatorView];
    
    // Set each component to its property
    [self setIndicatorView: indicatorView];
    [self setTitleLabel: titleLabel];
    [self setSpinner: spinner];
    
    // Auto Layout
    [self setupConstraints];
}

#pragma mark - Public Instance Methods

- (void) showInView: (UIView *) superview
{
    [self setTranslatesAutoresizingMaskIntoConstraints: NO];
    [self setAlpha: 0.0f];
    [superview addSubview: self];
    
    NSDictionary *views = @{@"_HUD" : self};
    
    NSArray *hudHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat: @"H:|[_HUD]|"
                                                                                options: 0
                                                                                metrics: nil
                                                                                  views: views];
    
    NSArray *hudVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat: @"V:|[_HUD]|"
                                                                              options: 0
                                                                              metrics: nil
                                                                                views: views];
    
    [superview addConstraints: hudHorizontalConstraints];
    [superview addConstraints: hudVerticalConstraints];
    
    [UIView animateWithDuration: 0.4
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations: ^{
                         [self setAlpha: 1.0f];
                     }
                     completion: ^(BOOL finished){
                         [superview setUserInteractionEnabled: NO];
                     }];
}

#pragma mark - Auto Layout Method

- (void) setupConstraints
{
    // Indicator View Center X
    [self addConstraint: [NSLayoutConstraint constraintWithItem: self.indicatorView
                                                      attribute: NSLayoutAttributeCenterX
                                                      relatedBy: NSLayoutRelationEqual
                                                         toItem: self
                                                      attribute: NSLayoutAttributeCenterX
                                                     multiplier: 1.0f
                                                       constant: 0.0f]];
    
    // Indicator View Center Y
    [self addConstraint: [NSLayoutConstraint constraintWithItem: self.indicatorView
                                                      attribute: NSLayoutAttributeCenterY
                                                      relatedBy: NSLayoutRelationEqual
                                                         toItem: self
                                                      attribute: NSLayoutAttributeCenterY
                                                     multiplier: 1.0f
                                                       constant: 0.0f]];
    
    // Title Label Right
    [self.indicatorView addConstraint: [NSLayoutConstraint constraintWithItem: self.titleLabel
                                                                    attribute: NSLayoutAttributeRight
                                                                    relatedBy: NSLayoutRelationEqual
                                                                       toItem: self.indicatorView
                                                                    attribute: NSLayoutAttributeRight
                                                                   multiplier: 1.0f
                                                                     constant: -12.0f]];
    
    // Title Label Center Y
    [self.indicatorView addConstraint: [NSLayoutConstraint constraintWithItem: self.titleLabel
                                                                    attribute: NSLayoutAttributeCenterY
                                                                    relatedBy: NSLayoutRelationEqual
                                                                       toItem: self.indicatorView
                                                                    attribute: NSLayoutAttributeCenterY
                                                                   multiplier: 1.0f
                                                                     constant: 0.0f]];
    
    // Spinner Width
    [self.indicatorView addConstraint: [NSLayoutConstraint constraintWithItem: self.spinner
                                                                    attribute: NSLayoutAttributeWidth
                                                                    relatedBy: NSLayoutRelationEqual
                                                                       toItem: self.indicatorView
                                                                    attribute: NSLayoutAttributeHeight
                                                                   multiplier: 1.0f
                                                                     constant: 0.0f]];
    
    // Spinner Height
    [self.indicatorView addConstraint: [NSLayoutConstraint constraintWithItem: self.spinner
                                                                    attribute: NSLayoutAttributeHeight
                                                                    relatedBy: NSLayoutRelationEqual
                                                                       toItem: self.indicatorView
                                                                    attribute: NSLayoutAttributeHeight
                                                                   multiplier: 1.0f
                                                                     constant: 0.0f]];
    
    // Spinner Center Y
    [self.indicatorView addConstraint: [NSLayoutConstraint constraintWithItem: self.spinner
                                                                    attribute: NSLayoutAttributeCenterY
                                                                    relatedBy: NSLayoutRelationEqual
                                                                       toItem: self.titleLabel
                                                                    attribute: NSLayoutAttributeCenterY
                                                                   multiplier: 1.0f
                                                                     constant: 0.0f]];
    
    // Spinner Right
    [self.indicatorView addConstraint: [NSLayoutConstraint constraintWithItem: self.spinner
                                                                    attribute: NSLayoutAttributeRight
                                                                    relatedBy: NSLayoutRelationEqual
                                                                       toItem: self.titleLabel
                                                                    attribute: NSLayoutAttributeLeft
                                                                   multiplier: 1.0f
                                                                     constant: 0.0f]];
    
    [self.indicatorView setNeedsLayout];
    [self.indicatorView layoutIfNeeded];
    
    CGFloat indicatorViewWidth = CGRectGetWidth([self.titleLabel bounds]) + CGRectGetWidth([self.spinner bounds]) + 36.0f;
    CGFloat indicatorViewHeight = CGRectGetHeight([self.titleLabel bounds]) + 20.0f;
    
    // Indicator View Width
    [self addConstraint: [NSLayoutConstraint constraintWithItem: self.indicatorView
                                                      attribute: NSLayoutAttributeWidth
                                                      relatedBy: NSLayoutRelationEqual
                                                         toItem: self
                                                      attribute: NSLayoutAttributeWidth
                                                     multiplier: 0.0f
                                                       constant: indicatorViewWidth]];
    
    // Indicator View Height
    [self addConstraint: [NSLayoutConstraint constraintWithItem: self.indicatorView
                                                      attribute: NSLayoutAttributeHeight
                                                      relatedBy: NSLayoutRelationEqual
                                                         toItem: self
                                                      attribute: NSLayoutAttributeHeight
                                                     multiplier: 0.0f
                                                       constant: indicatorViewHeight]];
}

@end
