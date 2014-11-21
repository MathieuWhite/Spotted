//
//  SPTextField.m
//  Spotted
//
//  Created by Mathieu White on 2014-11-16.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import "SPTextField.h"
#import "SPColors.h"

@interface SPTextField ()

@property (nonatomic, weak) UITextField *textField;
@property (nonatomic, weak) UIImageView *iconImageView;

@end

@implementation SPTextField

- (instancetype) initWithTextFieldType: (SPTextFieldType) textFieldType;
{
    self = [super init];
    
    if (self)
    {
        [self setFont: [UIFont fontWithName: @"Avenir-Light" size: 24.0f]];
        [self setLeftViewMode: UITextFieldViewModeAlways];
        [self setTextColor: [UIColor whiteColor]];
        [self setContentVerticalAlignment: UIControlContentVerticalAlignmentCenter];
        [self setAutocorrectionType: UITextAutocorrectionTypeNo];
        [self setTintColor: [UIColor whiteColor]];
        [self setKeyboardAppearance: UIKeyboardAppearanceDark];
        
        if (textFieldType == SPTextFieldTypeNormal)
            [self initTextFieldNormalType];
        if (textFieldType == SPTextFieldTypeSecure)
            [self initTextFieldSecureType];
    }
    
    return self;
}

- (void) initTextFieldNormalType
{
    [self setReturnKeyType: UIReturnKeyNext];
}

- (void) initTextFieldSecureType
{
    [self setReturnKeyType: UIReturnKeyDone];
    [self setSecureTextEntry: YES];
}

- (void) setTextFieldIconImage: (UIImage *) iconImage
{
    iconImage = [iconImage imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage: iconImage];
    [iconImageView setTintColor: [UIColor whiteColor]];
    
    [self setLeftView: iconImageView];
    
    [self setIconImageView: iconImageView];
}

- (void) setPlaceholder: (NSString *) placeholder
{
    [self setAttributedPlaceholder: [[NSAttributedString alloc]
                                     initWithString: placeholder
                                     attributes: @{NSForegroundColorAttributeName : SPWhiteColor60}]];
}

@end
