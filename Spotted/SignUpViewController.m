//
//  SignUpViewController.m
//  Spotted
//
//  Created by Mathieu White on 2014-11-16.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import "SignUpViewController.h"
#import "SPSignUpTableView.h"
#import "SPStrokeButton.h"

@interface SignUpViewController ()

@property (nonatomic, weak) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, weak) UIButton *backButton;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) SPSignUpTableView *signUpTableView;
@property (nonatomic, weak) SPStrokeButton *signUpButton;

@end

@implementation SignUpViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    // Set the background color to clear
    [self.view setBackgroundColor: [UIColor clearColor]];
    
    // GestureRecognizer for the view
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self
                                                                                           action: @selector(hideKeyboard)];
    
    // Initialize the back button
    UIButton *backButton = [[UIButton alloc] init];
    [backButton setBackgroundImage: [UIImage imageNamed: @"backButton"] forState: UIControlStateNormal];
    [backButton setTranslatesAutoresizingMaskIntoConstraints: NO];
    [backButton addTarget: self action: @selector(dismissSignUp) forControlEvents: UIControlEventTouchUpInside];
    
    // Initialize the title label
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setText: NSLocalizedString(@"Create Your Account", nil)];
    [titleLabel setTextColor: [UIColor whiteColor]];
    [titleLabel setTextAlignment: NSTextAlignmentCenter];
    [titleLabel setFont: [UIFont fontWithName: @"Avenir-Light" size: 22.0f]];
    [titleLabel setTranslatesAutoresizingMaskIntoConstraints: NO];
    
    // Initialize the sign up table view
    SPSignUpTableView *signUpTableView = [[SPSignUpTableView alloc] init];
    [signUpTableView setTranslatesAutoresizingMaskIntoConstraints: NO];
    
    // Initialize the sign up button
    SPStrokeButton *signUpButton = [[SPStrokeButton alloc] init];
    [signUpButton setTitle: NSLocalizedString(@"Sign Up", nil) forState: UIControlStateNormal];
    [signUpButton setTranslatesAutoresizingMaskIntoConstraints: NO];
    [signUpButton addTarget: self action: @selector(processSignUp) forControlEvents: UIControlEventTouchUpInside];
    
    // Add each component to the view
    [self.view addGestureRecognizer: tapGestureRecognizer];
    [self.view addSubview: backButton];
    [self.view addSubview: titleLabel];
    [self.view addSubview: signUpTableView];
    [self.view addSubview: signUpButton];
    
    // Set each component to a property
    [self setTapGestureRecognizer: tapGestureRecognizer];
    [self setBackButton: backButton];
    [self setTitleLabel: titleLabel];
    [self setSignUpTableView: signUpTableView];
    [self setSignUpButton: signUpButton];
    
    // Auto Layout
    [self setupConstraints];
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Instance Methods

- (void) processSignUp
{
    SPTextField *emailTextField = [(SPAuthenticationTableViewCell *) [self.signUpTableView cellForRowAtIndexPath:
                                                                      [NSIndexPath indexPathForRow: 0 inSection: 0]] textField];
    
    SPTextField *nameTextField = [(SPAuthenticationTableViewCell *) [self.signUpTableView cellForRowAtIndexPath:
                                                                     [NSIndexPath indexPathForRow: 1 inSection: 0]] textField];
    
    SPTextField *passwordTextField = [(SPAuthenticationTableViewCell *) [self.signUpTableView cellForRowAtIndexPath:
                                                                         [NSIndexPath indexPathForRow: 2 inSection: 0]] textField];
    
    // All fields are required
    if ([emailTextField.text length] && [nameTextField.text length] && [passwordTextField.text length])
    {
        if (![self validatePassword: [passwordTextField text]])
            return;
        
        PFUser *user = [PFUser user];
        [user setUsername: [[emailTextField text] lowercaseString]];
        [user setEmail: [[emailTextField text] lowercaseString]];
        [user setObject: [nameTextField text] forKey: @"name"];
        [user setPassword: [passwordTextField text]];
        
        [user signUpInBackgroundWithBlock: ^(BOOL succeeded, NSError *error)
         {
             if (!error)
             {
                 UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Success", nil)
                                                                        message: NSLocalizedString(@"Success Message", nil)
                                                                       delegate: self
                                                              cancelButtonTitle: NSLocalizedString(@"Okay", nil)
                                                              otherButtonTitles: nil];
                 [successAlert show];
             }
             else
             {
                 UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Error", nil)
                                                                      message: [error.userInfo objectForKey: @"error"]
                                                                     delegate: self
                                                            cancelButtonTitle: NSLocalizedString(@"Okay", nil)
                                                            otherButtonTitles: nil];
                 [errorAlert show];
             }
             
             [PFUser logOut];
         }];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Missing Information", nil)
                                                        message: NSLocalizedString(@"All fields are required.", nil)
                                                       delegate: self
                                              cancelButtonTitle: NSLocalizedString(@"Okay", nil)
                                              otherButtonTitles: nil];
        [alert show];
    }
}

- (BOOL) validatePassword: (NSString *) password
{
    // Password must be at least 6 characters long
    if ([password length] < 6)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Invalid Password", nil)
                                                        message: NSLocalizedString(@"Invalid Message Password", nil)
                                                       delegate: self
                                              cancelButtonTitle: NSLocalizedString(@"Okay", nil)
                                              otherButtonTitles: nil];
        [alert show];
        
        return NO;
    }
    
    return YES;
}

- (void) dismissSignUp
{
    if ([self.delegate respondsToSelector: @selector(transitionFromSignUpView)])
        [self.delegate transitionFromSignUpView];
}

#pragma mark - Auto Layout Method

- (void) setupConstraints
{
    // Back Button Top
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.backButton
                                                           attribute: NSLayoutAttributeCenterY
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.titleLabel
                                                           attribute: NSLayoutAttributeCenterY
                                                          multiplier: 1.0f
                                                            constant: 0.0f]];
    
    // Back Button Left
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.backButton
                                                           attribute: NSLayoutAttributeLeft
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.view
                                                           attribute: NSLayoutAttributeLeft
                                                          multiplier: 1.0f
                                                            constant: 0.0f]];
    
    // Title Label Center X
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.titleLabel
                                                           attribute: NSLayoutAttributeCenterX
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.view
                                                           attribute: NSLayoutAttributeCenterX
                                                          multiplier: 1.0f
                                                            constant: 0.0f]];
    
    // Title Label Top
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.titleLabel
                                                           attribute: NSLayoutAttributeTop
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.view
                                                           attribute: NSLayoutAttributeTop
                                                          multiplier: 1.0f
                                                            constant: 40.0f]];
    
    // Sign Up Table View Top
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.signUpTableView
                                                           attribute: NSLayoutAttributeTop
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.titleLabel
                                                           attribute: NSLayoutAttributeBottom
                                                          multiplier: 1.0f
                                                            constant: 40.0f]];
    
    // Sign Up Table View Left
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.signUpTableView
                                                           attribute: NSLayoutAttributeLeft
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.view
                                                           attribute: NSLayoutAttributeLeft
                                                          multiplier: 1.0f
                                                            constant: 24.0f]];
    
    // Sign Up Table View Right
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.signUpTableView
                                                           attribute: NSLayoutAttributeRight
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.view
                                                           attribute: NSLayoutAttributeRight
                                                          multiplier: 1.0f
                                                            constant: -24.0f]];
    
    // Sign Up Table View Bottom
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.signUpTableView
                                                           attribute: NSLayoutAttributeBottom
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.view
                                                           attribute: NSLayoutAttributeCenterY
                                                          multiplier: 1.0f
                                                            constant: 40.0f]];
    
    // Sign Up Button Top
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.signUpButton
                                                           attribute: NSLayoutAttributeTop
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.signUpTableView
                                                           attribute: NSLayoutAttributeBottom
                                                          multiplier: 1.0f
                                                            constant: 20.0f]];
    
    // Sign Up Button Left
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.signUpButton
                                                           attribute: NSLayoutAttributeLeft
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.view
                                                           attribute: NSLayoutAttributeLeft
                                                          multiplier: 1.0f
                                                            constant: 24.0f]];
    
    // Sign Up Button Right
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.signUpButton
                                                           attribute: NSLayoutAttributeRight
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.view
                                                           attribute: NSLayoutAttributeRight
                                                          multiplier: 1.0f
                                                            constant: -24.0f]];
}

#pragma mark - UIAlertViewDelegate Methods

- (void) alertView: (UIAlertView *) alertView didDismissWithButtonIndex: (NSInteger) buttonIndex
{
    if ([alertView.title isEqualToString: NSLocalizedString(@"Success", nil)])
    {
        [self.view endEditing: YES];
        [[NSNotificationCenter defaultCenter] postNotificationName: kUserSignUpWasSuccessfulNotification object: nil];
    }
}

#pragma mark - Gesture Recognizer Methods

- (void) hideKeyboard
{
    [[self view] endEditing: YES];
}

@end