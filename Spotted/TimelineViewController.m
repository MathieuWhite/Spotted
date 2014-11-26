//
//  TimelineViewController.m
//  Spotted
//
//  Created by Mathieu White on 2014-11-15.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import "TimelineViewController.h"
#import "AuthenticationViewController.h"
#import "SettingsViewController.h"
#import "SPNavigationTitleView.h"
#import "SPColors.h"
#import "SPConstants.h"
#import "SPSchool.h"

@interface TimelineViewController ()

@property (nonatomic, strong) SPSchool *school;

@property (nonatomic, weak) SPNavigationTitleView *titleView;
@property (nonatomic, weak) UILabel *welcomeLabel;

@property (nonatomic, getter = isPresentingView) BOOL presentingView;

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
                                             selector: @selector(getSchoolForCurrentUser)
                                                 name: kSPUserLoginWasSuccessfulNotification
                                               object: nil];
    
    // Notification for a user logout
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(removeViewsForUserLogout)
                                                 name: kSPUserWantsLogoutNotification
                                               object: nil];
    
    // Notification for a user delete account
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(removeViewsForUserLogout)
                                                 name: kSPUserDidDeleteAccountNotification
                                               object: nil];
}

- (void) viewWillAppear: (BOOL) animated
{
    [super viewWillAppear: animated];
    
    // The view is appearing from a dismissed view controller
    if ([self isPresentingView])
        return;
    
    // Verify if a user is logged in
    if ([PFUser currentUser])
    {
        PFQuery *schoolQuery = [PFQuery queryWithClassName: @"School"];
        [schoolQuery setLimit: 1];
        
        [schoolQuery getObjectInBackgroundWithId: [[[PFUser currentUser] objectForKey: kSPUserSchoolKey] objectId]
                                           block: ^(PFObject *object, NSError *error)
        {
            if (!error)
            {
                [self setSchool: (SPSchool *) object];
                [self setupViewForCurrentUser];
            }
            
            else
                NSLog(@"ERROR: %@", [error userInfo]);
        }];
        
        [self setupView];
    }
}

- (void) viewDidAppear: (BOOL) animated
{
    [super viewDidAppear: animated];
    
    // Check if a user is logged in
    if (![PFUser currentUser])
    {
        // Initialize the authentication view controller
        AuthenticationViewController *authenticationController = [[AuthenticationViewController alloc] init];
        
        // Present the authentication view controller
        [self.navigationController presentViewController: authenticationController animated: YES completion: NULL];
    }
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View Setup Methods

- (void) setupView
{
    [self.view setBackgroundColor: SPGrayBackgroundColor];
}

- (void) setupViewForCurrentUser
{
    // School colors
    CGFloat red = [[self.school.colors valueForKey: kSPSchoolRedColorKey] floatValue] / 255.0f;
    CGFloat green = [[self.school.colors valueForKey: kSPSchoolGreenColorKey] floatValue] / 255.0f;
    CGFloat blue = [[self.school.colors valueForKey: kSPSchoolBlueColorKey] floatValue] / 255.0f;
    
    // Navigation bar properties
    [self.navigationController.navigationBar setBackgroundImage: [UIImage new] forBarMetrics: UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage: [UIImage new]];
    [self.navigationController.navigationBar setTranslucent: NO];
    [self.navigationController.navigationBar setBarTintColor: [UIColor colorWithRed: red green: green blue: blue alpha: 1.0f]];
    
    // Custom NavigationBar Title View
    SPNavigationTitleView *titleView = [[SPNavigationTitleView alloc] init];
    [titleView setFrame: [self.navigationController.navigationBar bounds]];
    [titleView setTintColor: [UIColor whiteColor]];
    [titleView setDetailText: [self.school name]];
    [self.navigationItem setTitleView: titleView];
    
    // Initialize the Settings Icon
    UIBarButtonItem *settingsIcon = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed: @"settingsBarButtonItem"]
                                                                     style: UIBarButtonItemStylePlain
                                                                    target: self
                                                                    action: @selector(showSettings)];
    [settingsIcon setTintColor: [UIColor whiteColor]];
    
    // Initialize the Conversations Icon
    UIBarButtonItem *conversationsIcon = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed: @"conversationsBarButtonItem"]
                                                                          style: UIBarButtonItemStylePlain
                                                                         target: self
                                                                         action: @selector(showConversations)];
    [conversationsIcon setTintColor: [UIColor whiteColor]];
    
    // Set the navigation bar icons
    [self.navigationItem setLeftBarButtonItem: settingsIcon];
    [self.navigationItem setRightBarButtonItem: conversationsIcon];

    // Show the navigation bar
    [self.navigationController setNavigationBarHidden: NO];
    
    // Set the background colorg
    [self.view setBackgroundColor: SPGrayBackgroundColor];
    
    // Initialize the welcome label
    UILabel *welcomeLabel = [[UILabel alloc] init];
    [welcomeLabel setFrame: CGRectMake(0, 60, CGRectGetWidth([self.view bounds]), 44)];
    [welcomeLabel setTextColor: [UIColor blackColor]];
    [welcomeLabel setTextAlignment: NSTextAlignmentCenter];
    
    [welcomeLabel setText: [NSString stringWithFormat: @"Welcome, %@!", [[PFUser currentUser] objectForKey: kSPUserNameKey]]];
    
    [self.view addSubview: welcomeLabel];
    
    // Set each component to its property
    [self setTitleView: titleView];
    [self setWelcomeLabel: welcomeLabel];
    
    // Auto Layout
    [self setupConstraints];
}

#pragma mark - Auto Layout Methods

- (void) setupConstraints
{
}

#pragma mark - BarButtonItem Methods

- (void) showSettings
{
    SettingsViewController *settings = [[SettingsViewController alloc] init];
    [settings setModalTransitionStyle: UIModalTransitionStyleCoverVertical];
    [settings setModalPresentationStyle: UIModalPresentationCurrentContext];
    
    UINavigationController *settingsNavigationController = [[UINavigationController alloc] initWithRootViewController: settings];
    
    // School colors
    CGFloat red = [[self.school.colors valueForKey: kSPSchoolRedColorKey] floatValue] / 255.0f;
    CGFloat green = [[self.school.colors valueForKey: kSPSchoolGreenColorKey] floatValue] / 255.0f;
    CGFloat blue = [[self.school.colors valueForKey: kSPSchoolBlueColorKey] floatValue] / 255.0f;
    
    [settingsNavigationController.navigationBar setBackgroundImage: [UIImage new] forBarMetrics: UIBarMetricsDefault];
    [settingsNavigationController.navigationBar setShadowImage: [UIImage new]];
    [settingsNavigationController.navigationBar setTranslucent: NO];
    [settingsNavigationController.navigationBar setBarTintColor: [UIColor colorWithRed: red green: green blue: blue alpha: 1.0f]];
    
    [self presentViewController: settingsNavigationController animated: YES completion: ^
    {
        [self setPresentingView: YES];
    }];
}

- (void) showConversations
{
    NSLog(@"showConversations");
}

#pragma mark - Notification Methods

- (void) getSchoolForCurrentUser
{
    PFQuery *schoolQuery = [PFQuery queryWithClassName: @"School"];
    [schoolQuery setLimit: 1];
    
    [schoolQuery getObjectInBackgroundWithId: [[[PFUser currentUser] objectForKey: kSPUserSchoolKey] objectId]
                                       block: ^(PFObject *object, NSError *error)
     {
         if (!error)
         {
             [self setSchool: (SPSchool *) object];
             [self setupViewForCurrentUser];
         }
         
         else
             NSLog(@"ERROR: %@", [error userInfo]);
     }];
    
    [self setupView];
}

- (void) removeViewsForUserLogout
{
    [self.navigationController setNavigationBarHidden: YES];
    [self.view.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

@end
