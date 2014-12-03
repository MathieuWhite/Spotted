//
//  SPTimelineTableViewCell.m
//  Spotted
//
//  Created by Mathieu White on 2014-12-02.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import "SPTimelineTableViewCell.h"
#import "SPColors.h"

@interface SPTimelineTableViewCell ()

@property (nonatomic, weak) UILabel *dateLabel;
@property (nonatomic, weak) UIView *cellSeparator;

@end

@implementation SPTimelineTableViewCell

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
    
    // Initialize the Date Label
    UILabel *dateLabel = [[UILabel alloc] init];
    [dateLabel setTextColor: SPTimelineCellDateTextColor];
    [dateLabel setFont: [UIFont fontWithName: @"Avenir-LightOblique" size: 12.0f]];
    [dateLabel setTranslatesAutoresizingMaskIntoConstraints: NO];
    
    // Initialize the Content Label
    SPTimelineCellLabel *contentLabel = [[SPTimelineCellLabel alloc] init];
    [contentLabel setTextColor: SPTimelineCellContentTextColor];
    [contentLabel setFont: [UIFont fontWithName: @"Avenir-Light" size: 14.0f]];
    [contentLabel setNumberOfLines: 0];
    [contentLabel setLineBreakMode: NSLineBreakByWordWrapping];
    [contentLabel setTranslatesAutoresizingMaskIntoConstraints: NO];
    
    // Initialize the cell separator
    UIView *cellSeparator = [[UIView alloc] init];
    [cellSeparator setBackgroundColor: SPCellSeparatorColor];
    [cellSeparator setTranslatesAutoresizingMaskIntoConstraints: NO];
    
    // Selected Cell color
    UIView *selectedView = [[UIView alloc] init];
    [selectedView setBackgroundColor: SPCellSelectionColor];
    [self setSelectedBackgroundView: selectedView];
    
    // Add each component to the cell content view
    [self.contentView addSubview: contentLabel];
    [self.contentView addSubview: dateLabel];
    [self.contentView addSubview: cellSeparator];
    
    // Set each component to it's property
    [self setDateLabel: dateLabel];
    [self setContentLabel: contentLabel];
    [self setCellSeparator: cellSeparator];
    
    // Auto Layout
    [self setupConstraints];
}

- (void) setDate: (NSDate *) date
{
    // The time right now
    NSDate *now = [NSDate date];
    
    // Get the time between the post date and now
    NSTimeInterval distanceBetweenDates = [now timeIntervalSinceDate: date];
    CGFloat secondsInAnHour = 3600.0f;
    NSInteger hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
    
    // String to hold the timestamp
    NSString *timestamp;
    
    // If 24 hours or more, show days
    if (hoursBetweenDates >= 24)
    {
        NSInteger days = hoursBetweenDates / 24;
        
        // If 365 days or more, show years
        if (days >= 365)
        {
            NSInteger years = days / 365;
            
            if (years == 1)
                timestamp = [NSString stringWithFormat: NSLocalizedString(@"%ld year ago", nil), years];
            
            else
                timestamp = [NSString stringWithFormat: NSLocalizedString(@"%ld years ago", nil), years];
        }
        
        else if (days == 1)
            timestamp = [NSString stringWithFormat: NSLocalizedString(@"%ld day ago", nil), days];
        
        else
            timestamp = [NSString stringWithFormat: NSLocalizedString(@"%ld days ago", nil), days];
    }
    
    // If less than 1 hour, show minutes
    else if (hoursBetweenDates < 1)
    {
        NSInteger minutes = distanceBetweenDates / secondsInAnHour * 60.0;
        
        // If less than 1 minute, show seconds
        if ((distanceBetweenDates / secondsInAnHour * 60.0) < 1.0f)
        {
            NSInteger seconds = distanceBetweenDates / secondsInAnHour * 60.0f * 60.0f;
            
            if (seconds == 1)
                timestamp = [NSString stringWithFormat: NSLocalizedString(@"%ld second ago", nil), seconds];
            
            else
                timestamp = [NSString stringWithFormat: NSLocalizedString(@"%ld seconds ago", nil), seconds];
        }
        
        else if (minutes == 1)
            timestamp = [NSString stringWithFormat: NSLocalizedString(@"%ld minute ago", nil), minutes];
        
        else
            timestamp = [NSString stringWithFormat: NSLocalizedString(@"%ld minutes ago", nil), minutes];
    }
    
    // Difference can be displayed in hours
    else
    {
        if (hoursBetweenDates == 1)
            timestamp = [NSString stringWithFormat: NSLocalizedString(@"%ld hour ago", nil), hoursBetweenDates];
        
        else
            timestamp = [NSString stringWithFormat: NSLocalizedString(@"%ld hours ago", nil), hoursBetweenDates];
    }
    
    [self.dateLabel setText: timestamp];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView layoutIfNeeded];
    
    [self.contentLabel setPreferredMaxLayoutWidth: CGRectGetWidth([self.contentLabel bounds])];
}

#pragma mark - UITableViewCell Methods

- (void) setSelected: (BOOL) selected animated: (BOOL) animated
{
    [super setSelected: selected animated: animated];
}

#pragma mark - Auto Layout Method

- (void) setupConstraints
{
    // Date Label Top
    [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem: self.dateLabel
                                                                  attribute: NSLayoutAttributeTop
                                                                  relatedBy: NSLayoutRelationEqual
                                                                     toItem: self.contentView
                                                                  attribute: NSLayoutAttributeTop
                                                                 multiplier: 1.0f
                                                                   constant: 10.0f]];
    
    // Date Label Left
    [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem: self.dateLabel
                                                                  attribute: NSLayoutAttributeLeft
                                                                  relatedBy: NSLayoutRelationEqual
                                                                     toItem: self.contentLabel
                                                                  attribute: NSLayoutAttributeLeft
                                                                 multiplier: 1.0f
                                                                   constant: 0.0f]];
    
    // Date Label Right
    [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem: self.dateLabel
                                                                  attribute: NSLayoutAttributeRight
                                                                  relatedBy: NSLayoutRelationEqual
                                                                     toItem: self.contentLabel
                                                                  attribute: NSLayoutAttributeRight
                                                                 multiplier: 1.0f
                                                                   constant: 0.0f]];
    
    // Content Label Top
    [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem: self.contentLabel
                                                                  attribute: NSLayoutAttributeTop
                                                                  relatedBy: NSLayoutRelationEqual
                                                                     toItem: self.dateLabel
                                                                  attribute: NSLayoutAttributeBottom
                                                                 multiplier: 1.0f
                                                                   constant: 10.0f]];
    
    // Content Label Left
    [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem: self.contentLabel
                                                                  attribute: NSLayoutAttributeLeft
                                                                  relatedBy: NSLayoutRelationEqual
                                                                     toItem: self.contentView
                                                                  attribute: NSLayoutAttributeLeft
                                                                 multiplier: 1.0f
                                                                   constant: 10.0f]];
    
    // Content Label Right
    [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem: self.contentLabel
                                                                  attribute: NSLayoutAttributeRight
                                                                  relatedBy: NSLayoutRelationEqual
                                                                     toItem: self.contentView
                                                                  attribute: NSLayoutAttributeRight
                                                                 multiplier: 1.0f
                                                                   constant: -10.0f]];
    
    // Content Label Bottom
    [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem: self.contentLabel
                                                                  attribute: NSLayoutAttributeBottom
                                                                  relatedBy: NSLayoutRelationEqual
                                                                     toItem: self.cellSeparator
                                                                  attribute: NSLayoutAttributeTop
                                                                 multiplier: 1.0f
                                                                   constant: -10.0f]];
    
    // Cell Separator Height
    [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem: self.cellSeparator
                                                                  attribute: NSLayoutAttributeHeight
                                                                  relatedBy: NSLayoutRelationEqual
                                                                     toItem: self.contentView
                                                                  attribute: NSLayoutAttributeHeight
                                                                 multiplier: 0.0f
                                                                   constant: 0.5f]];
    
    // Cell Separator Left
    [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem: self.cellSeparator
                                                                  attribute: NSLayoutAttributeLeft
                                                                  relatedBy: NSLayoutRelationEqual
                                                                     toItem: self.contentView
                                                                  attribute: NSLayoutAttributeLeft
                                                                 multiplier: 1.0f
                                                                   constant: 10.0f]];
    
    // Cell Separator Right
    [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem: self.cellSeparator
                                                                  attribute: NSLayoutAttributeRight
                                                                  relatedBy: NSLayoutRelationEqual
                                                                     toItem: self.contentView
                                                                  attribute: NSLayoutAttributeRight
                                                                 multiplier: 1.0f
                                                                   constant: -10.0f]];
    
    // Cell Separator Bottom
    [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem: self.cellSeparator
                                                                  attribute: NSLayoutAttributeBottom
                                                                  relatedBy: NSLayoutRelationEqual
                                                                     toItem: self.contentView
                                                                  attribute: NSLayoutAttributeBottom
                                                                 multiplier: 1.0f
                                                                   constant: 0.0f]];
}

@end
