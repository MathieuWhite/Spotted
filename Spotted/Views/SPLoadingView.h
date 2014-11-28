//
//  SPLoadingView.h
//  Spotted
//
//  Created by Mathieu White on 2014-11-28.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPLoadingView : UIView

+ (SPLoadingView *) sharedLoadingIndicator;

- (void) showInView: (UIView *) view;
- (void) setTintColor: (UIColor *) tintColor;

@end
