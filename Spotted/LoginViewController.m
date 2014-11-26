//
//  LoginViewController.m
//  Spotted
//
//  Created by Mathieu White on 2014-11-16.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import "LoginViewController.h"
#import "SPLoginTableView.h"
#import "SPStrokeButton.h"
#import "SPColors.h"
#import "SPConstants.h"
#import "POP.h"

@interface LoginViewController ()

@property (nonatomic, weak) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, weak) UILabel *textLogo;
@property (nonatomic, weak) SPLoginTableView *loginTableView;
@property (nonatomic, weak) SPStrokeButton *loginButton;
@property (nonatomic, weak) UIButton *forgotPasswordButton;
@property (nonatomic, weak) UIButton *signUpButton;

@end

@implementation LoginViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    // Set the background color to clear
    [self.view setBackgroundColor: [UIColor clearColor]];
    
    // GestureRecognizer for the view
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self
                                                                                           action: @selector(hideKeyboard)];
    
    // Initialize the logo
    UILabel *textLogo = [[UILabel alloc] init];
    [textLogo setText: @"Secret App"];
    [textLogo setTextColor: [UIColor whiteColor]];
    [textLogo setTextAlignment: NSTextAlignmentCenter];
    [textLogo setFont: [UIFont fontWithName: @"Avenir-Light" size: 36.0f]];
    [textLogo setTranslatesAutoresizingMaskIntoConstraints: NO];
    
    // Initialize the login table view
    SPLoginTableView *loginTableView = [[SPLoginTableView alloc] init];
    [loginTableView setTranslatesAutoresizingMaskIntoConstraints: NO];
    
    // Initialize the login button
    SPStrokeButton *loginButton = [[SPStrokeButton alloc] init];
    [loginButton setTitle: NSLocalizedString(@"Sign In", nil) forState: UIControlStateNormal];
    [loginButton setTranslatesAutoresizingMaskIntoConstraints: NO];
    [loginButton addTarget: self action: @selector(processLogin) forControlEvents: UIControlEventTouchUpInside];
    
    // Initialize the forgot password button
    UIButton *forgotPasswordButton = [UIButton buttonWithType: UIButtonTypeSystem];
    [forgotPasswordButton setTitle: NSLocalizedString(@"Forgot your password?", nil) forState: UIControlStateNormal];
    [forgotPasswordButton setTintColor: [UIColor whiteColor]];
    [forgotPasswordButton.titleLabel setFont: [UIFont fontWithName: @"Avenir-Light" size: 14.0f]];
    [forgotPasswordButton setTranslatesAutoresizingMaskIntoConstraints: NO];
    [forgotPasswordButton addTarget: self action: @selector(requestPasswordReset) forControlEvents: UIControlEventTouchUpInside];
    
    // Initialize the sign up button
    UIButton *signUpButton = [UIButton buttonWithType: UIButtonTypeSystem];
    [signUpButton setTitle: NSLocalizedString(@"Sign Up Button", nil) forState: UIControlStateNormal];
    [signUpButton setTintColor: [UIColor whiteColor]];
    [signUpButton.titleLabel setFont: [UIFont fontWithName: @"Avenir-Light" size: 14.0f]];
    [signUpButton setTranslatesAutoresizingMaskIntoConstraints: NO];
    [signUpButton addTarget: self action: @selector(requestSignUp) forControlEvents: UIControlEventTouchUpInside];
    
    // Add each component to the view
    [self.view addGestureRecognizer: tapGestureRecognizer];
    [self.view addSubview: textLogo];
    [self.view addSubview: loginTableView];
    [self.view addSubview: loginButton];
    [self.view addSubview: forgotPasswordButton];
    [self.view addSubview: signUpButton];
    
    // Set each component to a property
    [self setTapGestureRecognizer: tapGestureRecognizer];
    [self setTextLogo: textLogo];
    [self setLoginTableView: loginTableView];
    [self setLoginButton: loginButton];
    [self setForgotPasswordButton: forgotPasswordButton];
    [self setSignUpButton: signUpButton];
    
    // Auto Layout
    [self setupConstraints];
}

#pragma mark - Private Instance Methods

- (void) processLogin
{
    SPTextField *emailTextField = [(SPAuthenticationTableViewCell *) [self.loginTableView cellForRowAtIndexPath:
                                                                      [NSIndexPath indexPathForRow: 0 inSection: 0]] textField];
    
    SPTextField *passwordTextField = [(SPAuthenticationTableViewCell *) [self.loginTableView cellForRowAtIndexPath:
                                                                         [NSIndexPath indexPathForRow: 1 inSection: 0]] textField];
    
    // Check if both username and password fields are filled
    if ([emailTextField.text length] && [passwordTextField.text length])
    {
        // Begin the login process
        [PFUser logInWithUsernameInBackground: [[emailTextField text] lowercaseString]
                                     password: [passwordTextField text]
                                        block: ^(PFUser *user, NSError *error)
         {
             if (user)
             {
                 // Check user email verification
                 if (![[user objectForKey: kSPUserEmailVerifiedKey] boolValue])
                 {
                     AlertViewController *alert = [[AlertViewController alloc] initWithTitle: NSLocalizedString(@"Email Not Verified", nil)
                                                                                     message: NSLocalizedString(@"Email Not Verified Message", nil)
                                                                                    delegate: self
                                                                          dismissButtonTitle: NSLocalizedString(@"Okay", nil)
                                                                           actionButtonTitle: nil];
                     
                     [self presentViewController: alert animated: YES completion: NULL];
                     
                     [PFUser logOut];
                 }
                 
                 else
                 {
                     [[NSNotificationCenter defaultCenter] postNotificationName: kSPUserLoginWasSuccessfulNotification object: nil];
                     [self dismissViewControllerAnimated: YES completion: NULL];
                 }
             }
             else
             {
                 // Something went wrong
                 NSString *errorString = [[error userInfo] objectForKey: kSPUserErrorKey];
                 
                 AlertViewController *errorAlert = [[AlertViewController alloc] initWithTitle: NSLocalizedString(@"Error", nil)
                                                                                      message: errorString
                                                                                     delegate: self
                                                                           dismissButtonTitle: NSLocalizedString(@"Okay", nil)
                                                                            actionButtonTitle: nil];
                 
                 [self presentViewController: errorAlert animated: YES completion: NULL];
             }
         }];
        
    }
    else
    {
        AlertViewController *alert = [[AlertViewController alloc] initWithTitle: NSLocalizedString(@"Missing Information", nil)
                                                                        message: NSLocalizedString(@"No Email or Password", nil)
                                                                       delegate: self
                                                             dismissButtonTitle: NSLocalizedString(@"Okay", nil)
                                                              actionButtonTitle: nil];
        
        [self presentViewController: alert animated: YES completion: NULL];
    }
}

- (void) requestPasswordReset
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Email Address", nil)
                                                    message: NSLocalizedString(@"Enter the email address for your account: ", nil)
                                                   delegate: self
                                          cancelButtonTitle: NSLocalizedString(@"Cancel", nil)
                                          otherButtonTitles: NSLocalizedString(@"Send", nil), nil];
    [alert setAlertViewStyle: UIAlertViewStylePlainTextInput];
    [[alert textFieldAtIndex: 0] setKeyboardAppearance: UIKeyboardAppearanceDark];
    [[alert textFieldAtIndex: 0] setKeyboardType: UIKeyboardTypeEmailAddress];
    [[alert textFieldAtIndex: 0] setAutocapitalizationType: UITextAutocapitalizationTypeNone];
    [alert show];
}

- (void) requestSignUp
{
    if ([self.delegate respondsToSelector: @selector(transitionFromLoginView)])
        [self.delegate transitionFromLoginView];
}

#pragma mark - Auto Layout Method

- (void) setupConstraints
{
    // Text Logo Center X
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.textLogo
                                                           attribute: NSLayoutAttributeCenterX
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.view
                                                           attribute: NSLayoutAttributeCenterX
                                                          multiplier: 1.0f
                                                            constant: 0.0f]];
    
    // Text Logo Top
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.textLogo
                                                           attribute: NSLayoutAttributeTop
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.view
                                                           attribute: NSLayoutAttributeTop
                                                          multiplier: 1.0f
                                                            constant: 40.0f]];
    
    // Login Table View Top
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.loginTableView
                                                           attribute: NSLayoutAttributeTop
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.textLogo
                                                           attribute: NSLayoutAttributeBottom
                                                          multiplier: 1.0f
                                                            constant: 22.0f]];
    
    // Login Table View Left
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.loginTableView
                                                           attribute: NSLayoutAttributeLeft
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.view
                                                           attribute: NSLayoutAttributeLeft
                                                          multiplier: 1.0f
                                                            constant: 24.0f]];
    
    // Login Table View Right
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.loginTableView
                                                           attribute: NSLayoutAttributeRight
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.view
                                                           attribute: NSLayoutAttributeRight
                                                          multiplier: 1.0f
                                                            constant: -24.0f]];
    
    // Login Table View Bottom
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.loginTableView
                                                           attribute: NSLayoutAttributeBottom
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.view
                                                           attribute: NSLayoutAttributeCenterY
                                                          multiplier: 1.0f
                                                            constant: 20.0f]];
    
    // Login Button Top
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.loginButton
                                                           attribute: NSLayoutAttributeTop
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.loginTableView
                                                           attribute: NSLayoutAttributeBottom
                                                          multiplier: 1.0f
                                                            constant: 20.0f]];
    
    // Login Button Left
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.loginButton
                                                           attribute: NSLayoutAttributeLeft
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.view
                                                           attribute: NSLayoutAttributeLeft
                                                          multiplier: 1.0f
                                                            constant: 24.0f]];
    
    // Login Button Right
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.loginButton
                                                           attribute: NSLayoutAttributeRight
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.view
                                                           attribute: NSLayoutAttributeRight
                                                          multiplier: 1.0f
                                                            constant: -24.0f]];
    
    // Forgot Password Button Center X
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.forgotPasswordButton
                                                           attribute: NSLayoutAttributeCenterX
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.view
                                                           attribute: NSLayoutAttributeCenterX
                                                          multiplier: 1.0f
                                                            constant: 0.0f]];
    
    // Forgot Password Button Top
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.forgotPasswordButton
                                                           attribute: NSLayoutAttributeTop
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.loginButton
                                                           attribute: NSLayoutAttributeBottom
                                                          multiplier: 1.0f
                                                            constant: 22.0f]];
    
    // Sign Up Button Center X
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.signUpButton
                                                           attribute: NSLayoutAttributeCenterX
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.view
                                                           attribute: NSLayoutAttributeCenterX
                                                          multiplier: 1.0f
                                                            constant: 0.0f]];
    
    // Sign Up Button Bottom
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.signUpButton
                                                           attribute: NSLayoutAttributeBottom
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.view
                                                           attribute: NSLayoutAttributeBottom
                                                          multiplier: 1.0f
                                                            constant: -20.0f]];
    
}

#pragma mark - UIAlertViewDelegate Methods

- (void) alertView: (UIAlertView *) alertView didDismissWithButtonIndex: (NSInteger) buttonIndex
{
    // Send button
    if (buttonIndex == 1)
    {
        NSString *email = [[alertView textFieldAtIndex: 0] text];
        
        if ([email length])
        {
            [PFUser requestPasswordResetForEmailInBackground: email block: ^(BOOL succeeded, NSError *error)
            {
                if (error)
                {
                    NSLog(@"Error: %@", [error valueForKey: kSPUserErrorKey]);
                    
                    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Error", nil)
                                                                         message: [error valueForKey: kSPUserErrorKey]
                                                                        delegate: self
                                                               cancelButtonTitle: NSLocalizedString(@"Okay", nil)
                                                               otherButtonTitles: nil];
                    [errorAlert show];
                }
            }];
        }
    }
}

#pragma mark - Gesture Recognizer Methods

- (void) hideKeyboard
{
    [[self view] endEditing: YES];
}

@end
