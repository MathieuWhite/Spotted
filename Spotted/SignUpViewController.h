//
//  SignUpViewController.h
//  Spotted
//
//  Created by Mathieu White on 2014-11-16.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

@import Parse;
@import MessageUI;

#import "AlertViewController.h"

static NSString * kUserSignUpWasSuccessfulNotification = @"kUserSignUpWasSuccessfulNotification";

@protocol SignUpViewControllerDelegate <NSObject>

- (void) transitionFromSignUpView;

@end

@interface SignUpViewController : UIViewController <AlertViewControllerDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, assign) id <SignUpViewControllerDelegate> delegate;

@end
