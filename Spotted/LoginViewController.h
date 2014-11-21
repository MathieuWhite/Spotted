//
//  LoginViewController.h
//  Spotted
//
//  Created by Mathieu White on 2014-11-16.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

@import Parse;

static NSString * kUserLoginWasSuccessfulNotification = @"kUserLoginWasSuccessfulNotification";

@protocol LoginViewControllerDelegate <NSObject>

- (void) transitionFromLoginView;

@end

@interface LoginViewController : UIViewController <UIAlertViewDelegate, UITextFieldDelegate>

@property (nonatomic, assign) id <LoginViewControllerDelegate> delegate;

@end
