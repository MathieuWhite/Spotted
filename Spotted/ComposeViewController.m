//
//  ComposeViewController.m
//  Spotted
//
//  Created by Mathieu White on 2014-11-30.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import "ComposeViewController.h"
#import "SPConstants.h"
#import "SPColors.h"
#import "SPPost.h"
#import "SPSchool.h"

@interface ComposeViewController ()

@property (nonatomic, weak) UITextView *textView;

@end

@implementation ComposeViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    // Navigation Bar Title Properties
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                       NSFontAttributeName : [UIFont fontWithName: @"Avenir-Light" size: 20.0f]}];
    
    // Navigation Bar Title
    [self setTitle: NSLocalizedString(@"Compose", nil)];
    
    // Close Bar Button Item
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle: @"Close"
                                                                    style: UIBarButtonItemStylePlain
                                                                   target: self
                                                                   action: @selector(dismissComposeView)];
    [closeButton setTintColor: [UIColor whiteColor]];
    [closeButton setTitleTextAttributes: @{ NSFontAttributeName : [UIFont fontWithName: @"Avenir-Light" size: 16.0f]}
                               forState: UIControlStateNormal];
    
    // Post Bar Button Item
    UIBarButtonItem *postButton = [[UIBarButtonItem alloc] initWithTitle: @"Post"
                                                                   style: UIBarButtonItemStylePlain
                                                                  target: self
                                                                  action: @selector(processPost)];
    [postButton setTintColor: [UIColor whiteColor]];
    [postButton setTitleTextAttributes: @{ NSFontAttributeName : [UIFont fontWithName: @"Avenir-Light" size: 16.0f]}
                             forState: UIControlStateNormal];
    
    // Add the bar button items
    [self.navigationItem setLeftBarButtonItem: closeButton];
    [self.navigationItem setRightBarButtonItem: postButton];
    [self.navigationItem.rightBarButtonItem setEnabled: NO];
    
    // Set the background color
    [self.view setBackgroundColor: SPGrayBackgroundColor];
    
    // Initialize the text view
    UITextView *textView = [[UITextView alloc] init];
    [textView becomeFirstResponder];
    [textView setKeyboardAppearance: UIKeyboardAppearanceLight];
    [textView setTranslatesAutoresizingMaskIntoConstraints: NO];
    [textView setDelegate: self];
    
    // Add each component to the view
    [self.view addSubview: textView];
    
    // Set each component to its property
    [self setTextView: textView];
    
    // Auto Layout
    [self setupConstraints];
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - BarButtonItem Methods

- (void) dismissComposeView
{
    [self dismissViewControllerAnimated: YES completion: NULL];
}

- (void) processPost
{
    SPSchool *school = [[PFUser currentUser] valueForKey: kSPUserSchoolKey];
    
    SPPost *post = [SPPost object];
    [post setContent: [self.textView text]];
    [post setUser: [PFUser currentUser]];
    [post setSchool: school];
    
    // Posts are public, and may not be modified after posting
    PFACL *postACL = [PFACL ACLWithUser: [PFUser currentUser]];
    [postACL setPublicReadAccess: YES];
    [postACL setPublicWriteAccess: NO];
    [post setACL: postACL];
    
    // Save the Post Object
    [post saveInBackgroundWithBlock: ^(BOOL succeeded, NSError *error) {
        if (!error)
            NSLog(@"Post was successful");
        else
            NSLog(@"ERROR: %@", [error description]);
    }];
    
    [self dismissViewControllerAnimated: YES completion: NULL];
}

#pragma mark - Auto Layout Method

- (void) setupConstraints
{
    // Text View Top
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.textView
                                                           attribute: NSLayoutAttributeTop
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.view
                                                           attribute: NSLayoutAttributeTop
                                                          multiplier: 1.0f
                                                            constant: 0.0f]];
    
    // Text View Left
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.textView
                                                           attribute: NSLayoutAttributeLeft
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.view
                                                           attribute: NSLayoutAttributeLeft
                                                          multiplier: 1.0f
                                                            constant: 0.0f]];
    
    // Text View Right
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.textView
                                                           attribute: NSLayoutAttributeRight
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.view
                                                           attribute: NSLayoutAttributeRight
                                                          multiplier: 1.0f
                                                            constant: 0.0f]];
    
    // Text View Bottom
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.textView
                                                           attribute: NSLayoutAttributeBottom
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.view
                                                           attribute: NSLayoutAttributeBottom
                                                          multiplier: 1.0f
                                                            constant: 0.0f]];
}

#pragma mark - UITextViewDelegate Methods

- (void) textViewDidChange: (UITextView *) textView
{
    if ([textView.text length] > 0)
        [self.navigationItem.rightBarButtonItem setEnabled: YES];
    else
        [self.navigationItem.rightBarButtonItem setEnabled: NO];
}

@end
