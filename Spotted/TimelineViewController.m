//
//  TimelineViewController.m
//  Spotted
//
//  Created by Mathieu White on 2014-11-15.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import "TimelineViewController.h"
#import "AuthenticationViewController.h"
#import "LoginViewController.h"
#import "SignUpViewController.h"
#import "FadePresentingAnimator.h"
#import "FadeDismissingAnimator.h"
#import "SPColors.h"

@interface TimelineViewController ()

@property (nonatomic, weak) UILabel *welcomeLabel;

@end

@implementation TimelineViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    // Hide the navigation bar
    [self.navigationController setNavigationBarHidden: YES];
    
    // Set the background color
    [self.view setBackgroundColor: [UIColor blackColor]];
    
    // Notification for a successul user login
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(setupViewForCurrentUser)
                                                 name: kUserLoginWasSuccessfulNotification
                                               object: nil];
}

- (void) viewWillAppear: (BOOL) animated
{
    [super viewWillAppear: animated];
    
    // Verify if a user is logged in
    if ([PFUser currentUser])
        [self setupViewForCurrentUser];
}

- (void) viewDidAppear: (BOOL) animated
{
    [super viewDidAppear: animated];
    
    // Check if a user is logged in
    if (![PFUser currentUser])
    {
        // Initialize the authentication view controller
        AuthenticationViewController *authenticationController = [[AuthenticationViewController alloc] init];
        [authenticationController setTransitioningDelegate: self];
        [authenticationController setModalPresentationStyle: UIModalPresentationCustom];
        
        // Present the authentication view controller
        [self.navigationController presentViewController: authenticationController animated: YES completion: NULL];
    }
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIViewControllerTransitioningDelegate Methods

- (id <UIViewControllerAnimatedTransitioning>) animationControllerForPresentedController: (UIViewController *) presented
                                                                    presentingController: (UIViewController *) presenting
                                                                        sourceController: (UIViewController *) source
{
    return [[FadePresentingAnimator alloc] init];
}

- (id <UIViewControllerAnimatedTransitioning>) animationControllerForDismissedController: (UIViewController *) dismissed
{
    return [[FadeDismissingAnimator alloc] init];
}

#pragma mark - View Setup Methods

- (void) setupViewForCurrentUser
{
    // Navigation bar properties
    [self.navigationController.navigationBar setBackgroundImage: [UIImage new] forBarMetrics: UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage: [UIImage new]];
    [self.navigationController.navigationBar setTranslucent: NO];
    [self.navigationController.navigationBar setBarTintColor: [UIColor blueColor]];
    [self.navigationController.navigationBar setTitleTextAttributes: @{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    
    // Set the navigation bar title
    [self setTitle: @"Hello"];

    // Slide the navigation bar in the view
    [self.navigationController setNavigationBarHidden: NO];
    
    // Set the background colorg
    [self.view setBackgroundColor: SPGrayBackground];
    
    // Initialize the welcome label
    UILabel *welcomeLabel = [[UILabel alloc] init];
    [welcomeLabel setFrame: CGRectMake(0, 60, CGRectGetWidth([self.view bounds]), 44)];
    [welcomeLabel setTextColor: [UIColor blackColor]];
    [welcomeLabel setTextAlignment: NSTextAlignmentCenter];
    
    [welcomeLabel setText: [NSString stringWithFormat: @"Welcome, %@!", [[PFUser currentUser] objectForKey: @"name"]]];
    
    [self.view addSubview: welcomeLabel];
    
    [self setWelcomeLabel: welcomeLabel];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

@end
