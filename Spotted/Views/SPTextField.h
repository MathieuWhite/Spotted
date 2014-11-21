//
//  SPTextField.h
//  Spotted
//
//  Created by Mathieu White on 2014-11-16.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SPTextFieldType)
{
    SPTextFieldTypeNormal,
    SPTextFieldTypeSecure
};
                
@interface SPTextField : UITextField

- (instancetype) initWithTextFieldType: (SPTextFieldType) textFieldType;

- (void) setTextFieldIconImage: (UIImage *) iconImage;

@end
