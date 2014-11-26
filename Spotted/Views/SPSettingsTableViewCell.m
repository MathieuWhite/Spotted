//
//  SPSettingsTableViewCell.m
//  Spotted
//
//  Created by Mathieu White on 2014-11-25.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import "SPSettingsTableViewCell.h"
#import "SPColors.h"

@implementation SPSettingsTableViewCell

#pragma mark - Initialization

- (id) initWithStyle: (UITableViewCellStyle) style reuseIdentifier: (NSString *) reuseIdentifier
{
    self = [super initWithStyle: style reuseIdentifier: reuseIdentifier];
    
    if (self)
    {
        [self initSettingsTableViewCell];
    }
    
    return self;
}

- (void) initSettingsTableViewCell
{
    // Set the background color
    [self setBackgroundColor: [UIColor whiteColor]];
    
    // Cell Font
    [self.textLabel setFont: [UIFont fontWithName: @"Avenir-Light" size: 16.0f]];
    
    // Selected Cell color
    UIView *selectedView = [[UIView alloc] init];
    [selectedView setBackgroundColor: SPCellSelectionColor];
    [self setSelectedBackgroundView: selectedView];
    
    // Auto Layout
    [self setupConstraints];
}

#pragma mark - UITableViewCell Methods

- (void) setSelected: (BOOL) selected animated: (BOOL) animated
{
    [super setSelected: selected animated: animated];
}

#pragma mark - Auto Layout Method

- (void) setupConstraints
{
    
}

@end
