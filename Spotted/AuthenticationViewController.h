//
//  AuthenticationViewController.h
//  Spotted
//
//  Created by Mathieu White on 2014-11-17.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "SignUpViewController.h"

@interface AuthenticationViewController : UIViewController <LoginViewControllerDelegate, SignUpViewControllerDelegate>

@end
