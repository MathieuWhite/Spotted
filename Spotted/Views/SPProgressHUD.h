//
//  SPProgressHUD.h
//  Spotted
//
//  Created by Mathieu White on 2014-11-27.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SPProgressHUDStyle)
{
    SPProgressHUDStyleLight,
    SPProgressHUDStyleDark
};

@interface SPProgressHUD : UIView

- (instancetype) initWithTitle: (NSString *) title style: (SPProgressHUDStyle) style;

- (void) showInView: (UIView *) superview;

@end
