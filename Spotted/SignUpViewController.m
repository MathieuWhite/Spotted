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
#import "SPConstants.h"
#import "SPSchool.h"

@interface SignUpViewController ()

@property (nonatomic, strong) NSArray *availableSchools;
@property (nonatomic, strong) SPSchool *school;

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
    
    // Get the available schools
    [self requestAvailableSchools];
    
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

- (void) requestAvailableSchools
{
    PFQuery *query = [PFQuery queryWithClassName: @"School"];
    [query setLimit: 100]; // 100 is the default value
    [query findObjectsInBackgroundWithBlock: ^(NSArray *objects, NSError *error)
     {
         if (!error)
         {
             [self setAvailableSchools: objects];
         }
         else
         {
             NSLog(@"Error: %@ %@", error, [error userInfo]);
         }
     }];
}

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
        if (![self validateEmail: [emailTextField text]])
            return;
        
        if (![self validatePassword: [passwordTextField text]])
            return;
        
        PFUser *user = [PFUser user];
        [user setUsername: [[emailTextField text] lowercaseString]];
        [user setEmail: [[emailTextField text] lowercaseString]];
        [user setObject: [nameTextField text] forKey: kSPUserNameKey];
        [user setPassword: [passwordTextField text]];
        [user setObject: [self school] forKey: kSPUserSchoolKey];
        
        [user signUpInBackgroundWithBlock: ^(BOOL succeeded, NSError *error)
         {
             if (!error)
             {
                 AlertViewController *successAlert = [[AlertViewController alloc] initWithTitle: NSLocalizedString(@"Success", nil)
                                                                                        message: NSLocalizedString(@"Success Message", nil)
                                                                                       delegate: self
                                                                             dismissButtonTitle: NSLocalizedString(@"Okay", nil)
                                                                              actionButtonTitle: nil];
                                  
                 [self presentViewController: successAlert animated: YES completion: NULL];
             }
             else
             {
                 AlertViewController *errorAlert = [[AlertViewController alloc] initWithTitle: NSLocalizedString(@"Error", nil)
                                                                                      message: [error.userInfo objectForKey: kSPUserErrorKey]
                                                                                     delegate: self
                                                                           dismissButtonTitle: NSLocalizedString(@"Okay", nil)
                                                                            actionButtonTitle: nil];
                 
                 [self presentViewController: errorAlert animated: YES completion: NULL];
             }
             
             [PFUser logOut];
         }];
    }
    else
    {
        AlertViewController *alert = [[AlertViewController alloc] initWithTitle: NSLocalizedString(@"Missing Information", nil)
                                                                        message: NSLocalizedString(@"All fields are required.", nil)
                                                                       delegate: self
                                                             dismissButtonTitle: NSLocalizedString(@"Okay", nil)
                                                              actionButtonTitle: nil];
        
        [self presentViewController: alert animated: YES completion: NULL];
    }
}

- (BOOL) validateEmail: (NSString *) email
{
    NSArray *separatedEmail = [[email lowercaseString] componentsSeparatedByString: @"@"];
    NSString *domain = [separatedEmail lastObject];
    
    // Not using a school email
    NSArray *emailProviders = @[@"gmail.com"];
    if ([emailProviders containsObject: domain] || [separatedEmail count] == 1)
    {
        AlertViewController *alert = [[AlertViewController alloc] initWithTitle: NSLocalizedString(@"Invalid Email", nil)
                                                                        message: NSLocalizedString(@"Invalid Email Message", nil)
                                                                       delegate: self
                                                             dismissButtonTitle: NSLocalizedString(@"Okay", nil)
                                                              actionButtonTitle: nil];
        
        [self presentViewController: alert animated: YES completion: NULL];
        
        return NO;
    }
    
    __block BOOL schoolAvailable = NO;
    
    [self.availableSchools enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop)
     {
         if ([domain isEqualToString: [[obj valueForKey: kSPSchoolDomainKey] lowercaseString]])
         {
             [self setSchool: obj];
             schoolAvailable = YES;
             *stop = YES;
         }
     }];
    
    if (schoolAvailable)
    {
        return YES;
    }
    
    else
    {
        AlertViewController *alert = [[AlertViewController alloc] initWithTitle: NSLocalizedString(@"Not Available", nil)
                                                                        message: NSLocalizedString(@"Not Available Message", nil)
                                                                       delegate: self
                                                             dismissButtonTitle: NSLocalizedString(@"Cancel", nil)
                                                              actionButtonTitle: NSLocalizedString(@"Send", nil)];
        
        [self presentViewController: alert animated: YES completion: NULL];
        
        return NO;
    }
    
    return NO;
}

- (BOOL) validatePassword: (NSString *) secret
{
    // Password must be at least 6 characters long
    if ([secret length] < 6)
    {
        AlertViewController *alert = [[AlertViewController alloc] initWithTitle: NSLocalizedString(@"Invalid Password", nil)
                                                                        message: NSLocalizedString(@"Invalid Password Message", nil)
                                                                       delegate: self
                                                             dismissButtonTitle: NSLocalizedString(@"Okay", nil)
                                                              actionButtonTitle: nil];
        
        [self presentViewController: alert animated: YES completion: NULL];
        
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

#pragma mark - AlertViewControllerDelegate Methods

- (void) alertViewController: (AlertViewController *) alertView didDismissWithButtonIndex: (NSInteger) buttonIndex
{    
    if ([alertView.title isEqualToString: NSLocalizedString(@"Success", nil)])
    {
        [self.view endEditing: YES];
        [[NSNotificationCenter defaultCenter] postNotificationName: kUserSignUpWasSuccessfulNotification object: nil];
    }
    
    if ([alertView.title isEqualToString: NSLocalizedString(@"Not Available", nil)])
    {
        // Send button
        if (buttonIndex == 1)
        {
            /*
            // Email Subject
            NSString *subject = NSLocalizedString(@"Email Subject", nil);
            
            // Email Content
            NSString *messageBody = NSLocalizedString(@"Message Body", nil);
            
            // To address
            NSArray *toRecipents = [NSArray arrayWithObject: @"me@mathieuwhite.com"];
            
            MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
            [mailController setMailComposeDelegate: self];
            [mailController setSubject: subject];
            [mailController setMessageBody: messageBody isHTML: NO];
            [mailController setToRecipients: toRecipents];
            [mailController setModalPresentationStyle: UIModalPresentationFullScreen];
            
            // Present the mail view controller
            [self presentViewController: mailController animated: YES completion: NULL];
             */
        }
    }

}

#pragma mark - MFMailComposeViewControllerDelegate Methods

- (void) mailComposeController: (MFMailComposeViewController *) controller
           didFinishWithResult: (MFMailComposeResult) result
                         error: (NSError *) error
{
    // Close the mail view controller
    [self dismissViewControllerAnimated: YES completion: NULL];
}

#pragma mark - Gesture Recognizer Methods

- (void) hideKeyboard
{
    [[self view] endEditing: YES];
}

@end
