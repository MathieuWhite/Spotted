//
//  ComposeViewController.m
//  Spotted
//
//  Created by Mathieu White on 2014-11-30.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import "ComposeViewController.h"
#import "SPColors.h"

@interface ComposeViewController ()

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
                                                                   action: @selector(processPost)];
    [closeButton setTintColor: [UIColor whiteColor]];
    [closeButton setTitleTextAttributes: @{ NSFontAttributeName : [UIFont fontWithName: @"Avenir-Light" size: 16.0f]}
                               forState: UIControlStateNormal];
    
    // Post Bar Button Item
    UIBarButtonItem *postButton = [[UIBarButtonItem alloc] initWithTitle: @"Post"
                                                                   style: UIBarButtonItemStylePlain
                                                                  target: self
                                                                  action: @selector(processPost)];
    [postButton setEnabled: NO];
    [postButton setTintColor: [UIColor whiteColor]];
    [postButton setTitleTextAttributes: @{ NSFontAttributeName : [UIFont fontWithName: @"Avenir-Light" size: 16.0f]}
                             forState: UIControlStateNormal];
    
    // Add the bar button items
    [self.navigationItem setLeftBarButtonItem: closeButton];
    [self.navigationItem setRightBarButtonItem: postButton];
    
    // Set the background color
    [self.view setBackgroundColor: SPGrayBackgroundColor];
    
    // Auto Layout
    [self setupConstraints];
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - BarButtonItem Methods

- (void) dismissCompose
{
    [self dismissViewControllerAnimated: YES completion: NULL];
}

- (void) processPost
{
    NSLog(@"processPost");
    [self dismissViewControllerAnimated: YES completion: NULL];
}

#pragma mark - Auto Layout Method

- (void) setupConstraints
{
}

@end
