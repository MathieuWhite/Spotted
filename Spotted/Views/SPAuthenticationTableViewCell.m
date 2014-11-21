//
//  SPAuthenticationTableViewCell.m
//  Spotted
//
//  Created by Mathieu White on 2014-11-17.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import "SPAuthenticationTableViewCell.h"
#import "SPTextField.h"

@interface SPAuthenticationTableViewCell ()

@property (nonatomic, weak) UIView *cellSeparator;

@end

@implementation SPAuthenticationTableViewCell

#pragma mark - Initialization

- (id) initWithStyle: (UITableViewCellStyle) style reuseIdentifier: (NSString *) reuseIdentifier
{
    self = [super initWithStyle: style reuseIdentifier: reuseIdentifier];
    
    if (self)
    {
        [self initAuthenticationTableViewCell];
    }
    
    return self;
}

- (void) initAuthenticationTableViewCell
{
    // Initialize the cell separator
    UIView *cellSeparator = [[UIView alloc] init];
    [cellSeparator setBackgroundColor: [UIColor colorWithWhite: 1.0f alpha: 0.3f]];
    [cellSeparator setTranslatesAutoresizingMaskIntoConstraints: NO];
    
    [self.contentView addSubview: cellSeparator];
    
    [self setBackgroundColor: [UIColor clearColor]];
    [self setSelectionStyle: UITableViewCellSelectionStyleNone];
    
    [self setCellSeparator: cellSeparator];
    
    [self setupConstraints];
}

- (void) setLastCell: (BOOL) lastCell
{
    if (lastCell)
        [self.cellSeparator removeFromSuperview];
}

- (void) setAuthenticationTableViewCellType: (SPAuthenticationTableViewCellType) type
{
    SPTextField *textField;
    
    if (type == SPAuthenticationTableViewCellTypeEmail)
    {
        textField = [[SPTextField alloc] initWithTextFieldType: SPTextFieldTypeNormal];
        [textField setPlaceholder: NSLocalizedString(@"Email address", nil)];
        [textField setKeyboardType: UIKeyboardTypeEmailAddress];
        [textField setAutocapitalizationType: UITextAutocapitalizationTypeNone];
    }
    
    else if (type == SPAuthenticationTableViewCellTypeName)
    {
        textField = [[SPTextField alloc] initWithTextFieldType: SPTextFieldTypeNormal];
        [textField setPlaceholder: NSLocalizedString(@"Name", nil)];
        [textField setAutocapitalizationType: UITextAutocapitalizationTypeWords];
    }
    
    else if (type == SPAuthenticationTableViewCellTypePassword)
    {
        textField = [[SPTextField alloc] initWithTextFieldType: SPTextFieldTypeSecure];
        [textField setPlaceholder: NSLocalizedString(@"Password", nil)];
    }
    
    [textField setTranslatesAutoresizingMaskIntoConstraints: NO];
    
    [self.contentView addSubview: textField];
    
    [self setTextField: textField];
    
    [self setupTextFieldConstraints];
}

- (void) setTextField: (SPTextField *) textField
{
    _textField = textField;
}

#pragma mark - UITableViewCell Methods

- (void) setSelected:(BOOL) selected animated: (BOOL) animated
{
    [super setSelected: selected animated: animated];
}

#pragma mark - Auto Layout Method

- (void) setupConstraints
{
    // Cell Separator Height
    [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem: self.cellSeparator
                                                                  attribute: NSLayoutAttributeHeight
                                                                  relatedBy: NSLayoutRelationEqual
                                                                     toItem: self.contentView
                                                                  attribute: NSLayoutAttributeHeight
                                                                 multiplier: 0.0f
                                                                   constant: 1.0f]];
    
    // Cell Separator Left
    [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem: self.cellSeparator
                                                                  attribute: NSLayoutAttributeLeft
                                                                  relatedBy: NSLayoutRelationEqual
                                                                     toItem: self.contentView
                                                                  attribute: NSLayoutAttributeLeft
                                                                 multiplier: 1.0f
                                                                   constant: 0.0f]];
    
    // Cell Separator Right
    [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem: self.cellSeparator
                                                                  attribute: NSLayoutAttributeRight
                                                                  relatedBy: NSLayoutRelationEqual
                                                                     toItem: self.contentView
                                                                  attribute: NSLayoutAttributeRight
                                                                 multiplier: 1.0f
                                                                   constant: 0.0f]];
    
    // Cell Separator Bottom
    [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem: self.cellSeparator
                                                                  attribute: NSLayoutAttributeBottom
                                                                  relatedBy: NSLayoutRelationEqual
                                                                     toItem: self.contentView
                                                                  attribute: NSLayoutAttributeBottom
                                                                 multiplier: 1.0f
                                                                   constant: 0.0f]];
}

- (void) setupTextFieldConstraints
{
    // Text Field Height
    [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem: self.textField
                                                                  attribute: NSLayoutAttributeHeight
                                                                  relatedBy: NSLayoutRelationEqual
                                                                     toItem: self.contentView
                                                                  attribute: NSLayoutAttributeHeight
                                                                 multiplier: 1.0f
                                                                   constant: 0.0f]];
    
    // Text Field Left
    [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem: self.textField
                                                                  attribute: NSLayoutAttributeLeft
                                                                  relatedBy: NSLayoutRelationEqual
                                                                     toItem: self.contentView
                                                                  attribute: NSLayoutAttributeLeft
                                                                 multiplier: 1.0f
                                                                   constant: 0.0f]];
    
    // Text Field Right
    [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem: self.textField
                                                                  attribute: NSLayoutAttributeRight
                                                                  relatedBy: NSLayoutRelationEqual
                                                                     toItem: self.contentView
                                                                  attribute: NSLayoutAttributeRight
                                                                 multiplier: 1.0f
                                                                   constant: 0.0f]];
    
    // Text Field Bottom
    [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem: self.textField
                                                                  attribute: NSLayoutAttributeBottom
                                                                  relatedBy: NSLayoutRelationEqual
                                                                     toItem: self.contentView
                                                                  attribute: NSLayoutAttributeBottom
                                                                 multiplier: 1.0f
                                                                   constant: 0.0f]];
}

@end
