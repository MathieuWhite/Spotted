//
//  AlertViewController.h
//  Spotted
//
//  Created by Mathieu White on 2014-11-22.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlertViewController;

@protocol AlertViewControllerDelegate <NSObject>

@optional
- (void) alertViewController: (AlertViewController *) alertView didDismissWithButtonIndex: (NSInteger) buttonIndex;

@end

@interface AlertViewController : UIViewController <UIViewControllerTransitioningDelegate>

- (instancetype) initWithTitle: (NSString *) title
                       message: (NSString *) message
                      delegate: (id) delegate
            dismissButtonTitle: (NSString *) dismissButtonTitle
             actionButtonTitle: (NSString *) actionButtonTitle;

- (void) setTintColor: (UIColor *) color;
- (void) setActionButtonTintColor: (UIColor *) color;

@property (nonatomic, assign) id <AlertViewControllerDelegate> delegate;

@end
