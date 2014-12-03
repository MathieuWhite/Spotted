//
//  SPAlertBar.m
//  Spotted
//
//  Created by Mathieu White on 2014-12-03.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import "SPAlertBar.h"

@interface SPAlertBar ()

@property (nonatomic, weak) UILabel *alertLabel;

@end

@implementation SPAlertBar

#pragma mark - Initialization

+ (SPAlertBar *) sharedAlertBar
{
    static SPAlertBar *_sharedAlertBar;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedAlertBar = [[SPAlertBar alloc] init];
    });
    
    return _sharedAlertBar;
}

- (id) init
{
    self = [super init];
    
    if (self)
    {
        [self initAlertBar];
    }
    
    return self;
}

- (void) initAlertBar
{
    // Initialize the alert label
    UILabel *alertLabel = [[UILabel alloc] init];
    [alertLabel setTextColor: [UIColor whiteColor]];
    [alertLabel setFont: [UIFont fontWithName: @"Avenir-Light" size: 16.0f]];
    [alertLabel setTranslatesAutoresizingMaskIntoConstraints: NO];
    
    // Add each component to the view
    [self addSubview: alertLabel];
    
    // Set each component to its property
    [self setAlertLabel: alertLabel];
    
    // Auto Layout
    [self setupConstraints];
}

#pragma mark - Public Instance Methods

- (void) setTintColor: (UIColor *) tintColor
{
    [UIView animateWithDuration: 0.25
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations: ^{
                         [self setBackgroundColor: tintColor];
                     }
                     completion: NULL];
}

- (void) setAlertText: (NSString *) alertText
{
    [UIView animateWithDuration: 0.25
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations: ^{
                         [self.alertLabel setText: alertText];
                     }
                     completion: NULL];
}

#pragma mark - Auto Layout Methods

- (void) setupConstraints
{
    // Alert Label Height
    [self addConstraint: [NSLayoutConstraint constraintWithItem: self.alertLabel
                                                      attribute: NSLayoutAttributeHeight
                                                      relatedBy: NSLayoutRelationEqual
                                                         toItem: self
                                                      attribute: NSLayoutAttributeHeight
                                                     multiplier: 1.0f
                                                       constant: 0.0f]];
    
    // Alert Label Center Y
    [self addConstraint: [NSLayoutConstraint constraintWithItem: self.alertLabel
                                                      attribute: NSLayoutAttributeCenterY
                                                      relatedBy: NSLayoutRelationEqual
                                                         toItem: self
                                                      attribute: NSLayoutAttributeCenterY
                                                     multiplier: 1.0f
                                                       constant: 0.0f]];
    
    // Alert Label Left
    [self addConstraint: [NSLayoutConstraint constraintWithItem: self.alertLabel
                                                      attribute: NSLayoutAttributeLeft
                                                      relatedBy: NSLayoutRelationEqual
                                                         toItem: self
                                                      attribute: NSLayoutAttributeLeft
                                                     multiplier: 1.0f
                                                       constant: 10.0f]];
    
    // Alert Label Right
    [self addConstraint: [NSLayoutConstraint constraintWithItem: self.alertLabel
                                                      attribute: NSLayoutAttributeRight
                                                      relatedBy: NSLayoutRelationEqual
                                                         toItem: self
                                                      attribute: NSLayoutAttributeRight
                                                     multiplier: 1.0f
                                                       constant: -10.0f]];
}

@end
