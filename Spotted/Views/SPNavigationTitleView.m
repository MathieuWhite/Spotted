//
//  SPNavigationTitleView.m
//  Spotted
//
//  Created by Mathieu White on 2014-11-24.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import "SPNavigationTitleView.h"

@interface SPNavigationTitleView ()

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *detailLabel;

@end

@implementation SPNavigationTitleView

#pragma mark - Initialization

- (id) init
{
    self = [super init];
    
    if (self)
    {
        [self initNavigationTitleView];
    }
    
    return self;
}

- (void) initNavigationTitleView
{
    // Set the background color
    //[self setBackgroundColor: [UIColor redColor]];
    
    // Initialize the title label
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setText: @"Secret App"];
    [titleLabel setTextAlignment: NSTextAlignmentCenter];
    [titleLabel setFont: [UIFont fontWithName: @"Avenir" size: 16.0f]];
    [titleLabel setTranslatesAutoresizingMaskIntoConstraints: NO];
    
    // Initialize the detail label
    UILabel *detailLabel = [[UILabel alloc] init];
    [detailLabel setText: @""];
    [detailLabel setTextAlignment: NSTextAlignmentCenter];
    [detailLabel setFont: [UIFont fontWithName: @"Avenir-Light" size: 12.0f]];
    [detailLabel setTranslatesAutoresizingMaskIntoConstraints: NO];
    
    // Add the components to the view
    [self addSubview: titleLabel];
    [self addSubview: detailLabel];
    
    // Set each component to its property
    [self setTitleLabel: titleLabel];
    [self setDetailLabel: detailLabel];
    
    // Auto Layout
    [self setupConstraints];
}

#pragma mark - Public Instance Methods

- (void) setTintColor: (UIColor *) tintColor
{
    [self.titleLabel setTextColor: tintColor];
    [self.detailLabel setTextColor: tintColor];
}

- (void) setDetailText: (NSString *) detailText
{
    [self.detailLabel setText: detailText];
}

#pragma mark - Auto Layout Methods

- (void) setupConstraints
{
    // Title Label Top
    [self addConstraint: [NSLayoutConstraint constraintWithItem: self.titleLabel
                                                      attribute: NSLayoutAttributeTop
                                                      relatedBy: NSLayoutRelationEqual
                                                         toItem: self
                                                      attribute: NSLayoutAttributeTop
                                                     multiplier: 1.0f
                                                       constant: 2.0f]];
    
    // Title Label Left
    [self addConstraint: [NSLayoutConstraint constraintWithItem: self.titleLabel
                                                      attribute: NSLayoutAttributeLeft
                                                      relatedBy: NSLayoutRelationEqual
                                                         toItem: self
                                                      attribute: NSLayoutAttributeLeft
                                                     multiplier: 1.0f
                                                       constant: 0.0f]];
    
    // Title Label Right
    [self addConstraint: [NSLayoutConstraint constraintWithItem: self.titleLabel
                                                      attribute: NSLayoutAttributeRight
                                                      relatedBy: NSLayoutRelationEqual
                                                         toItem: self
                                                      attribute: NSLayoutAttributeRight
                                                     multiplier: 1.0f
                                                       constant: 0.0f]];
    
    // Detail Label Top
    [self addConstraint: [NSLayoutConstraint constraintWithItem: self.detailLabel
                                                      attribute: NSLayoutAttributeTop
                                                      relatedBy: NSLayoutRelationEqual
                                                         toItem: self.titleLabel
                                                      attribute: NSLayoutAttributeBottom
                                                     multiplier: 1.0f
                                                       constant: -1.0f]];
    
    // Detail Label Left
    [self addConstraint: [NSLayoutConstraint constraintWithItem: self.detailLabel
                                                      attribute: NSLayoutAttributeLeft
                                                      relatedBy: NSLayoutRelationEqual
                                                         toItem: self.titleLabel
                                                      attribute: NSLayoutAttributeLeft
                                                     multiplier: 1.0f
                                                       constant: 0.0f]];
    
    // Detail Label Right
    [self addConstraint: [NSLayoutConstraint constraintWithItem: self.detailLabel
                                                      attribute: NSLayoutAttributeRight
                                                      relatedBy: NSLayoutRelationEqual
                                                         toItem: self.titleLabel
                                                      attribute: NSLayoutAttributeRight
                                                     multiplier: 1.0f
                                                       constant: 0.0f]];
}

@end
