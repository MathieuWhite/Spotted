//
//  SPSettingsTableViewSectionHeader.m
//  Spotted
//
//  Created by Mathieu White on 2014-11-25.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import "SPSettingsTableViewSectionHeader.h"

@interface SPSettingsTableViewSectionHeader ()

@property (nonatomic, weak) UILabel *titleLabel;

@end

@implementation SPSettingsTableViewSectionHeader

#pragma mark - Initialization

- (id) init
{
    self = [super init];
    
    if (self)
    {
        [self initSectionHeader];
    }
    
    return self;
}

- (void) initSectionHeader
{
    // Set the background color
    [self setBackgroundColor: [UIColor clearColor]];
    
    // Initialize the title label
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setText: @""];
    [titleLabel setFont: [UIFont fontWithName: @"Avenir-Light" size: 14.0f]];
    [titleLabel setTranslatesAutoresizingMaskIntoConstraints: NO];
    
    // Add each component to the view
    [self addSubview: titleLabel];
    
    // Set each component to its property
    [self setTitleLabel: titleLabel];
    
    // Auto Layout
    [self setupConstraints];
}

#pragma mark - Public Instance Methods

- (void) setTintColor: (UIColor *) tintColor
{
    [self.titleLabel setTextColor: tintColor];
}

- (void) setHeaderTitle: (NSString *) title
{
    [self.titleLabel setText: title];
}

#pragma mark - Auto Layout Methods

- (void) setupConstraints
{
    // Title Label Center Y
    [self addConstraint: [NSLayoutConstraint constraintWithItem: self.titleLabel
                                                      attribute: NSLayoutAttributeCenterY
                                                      relatedBy: NSLayoutRelationEqual
                                                         toItem: self
                                                      attribute: NSLayoutAttributeCenterY
                                                     multiplier: 1.0f
                                                       constant: 0.0f]];
    
    // Title Label Left
    [self addConstraint: [NSLayoutConstraint constraintWithItem: self.titleLabel
                                                      attribute: NSLayoutAttributeLeft
                                                      relatedBy: NSLayoutRelationEqual
                                                         toItem: self
                                                      attribute: NSLayoutAttributeLeft
                                                     multiplier: 1.0f
                                                       constant: 15.0f]];
}

@end
