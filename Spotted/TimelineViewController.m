//
//  TimelineViewController.m
//  Spotted
//
//  Created by Mathieu White on 2014-11-15.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import "TimelineViewController.h"
#import "AuthenticationViewController.h"
#import "SPColors.h"
#import "SPSchool.h"

@interface TimelineViewController ()

@property (nonatomic, strong) SPSchool *school;

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
                                             selector: @selector(getSchoolForCurrentUser)
                                                 name: kUserLoginWasSuccessfulNotification
                                               object: nil];
}

- (void) viewWillAppear: (BOOL) animated
{
    [super viewWillAppear: animated];
    
    // Verify if a user is logged in
    if ([PFUser currentUser])
    {
        PFQuery *schoolQuery = [PFQuery queryWithClassName: @"School"];
        [schoolQuery setLimit: 1];
        
        [schoolQuery getObjectInBackgroundWithId: [[[PFUser currentUser] objectForKey: @"school"] objectId]
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
    [self.view setBackgroundColor: SPGrayBackground];
}

- (void) setupViewForCurrentUser
{
    // School colors
    CGFloat red = [[[self.school valueForKey: @"colors"] valueForKey: @"red"] floatValue] / 255.0f;
    CGFloat green = [[[self.school valueForKey: @"colors"] valueForKey: @"green"] floatValue] / 255.0f;
    CGFloat blue = [[[self.school valueForKey: @"colors"] valueForKey: @"blue"] floatValue] / 255.0f;
    
    // Navigation bar properties
    [self.navigationController.navigationBar setBackgroundImage: [UIImage new] forBarMetrics: UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage: [UIImage new]];
    [self.navigationController.navigationBar setTranslucent: NO];
    [self.navigationController.navigationBar setBarTintColor: [UIColor colorWithRed: red green: green blue: blue alpha: 1.0f]];
    [self.navigationController.navigationBar setTitleTextAttributes: @{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    
    // Set the navigation bar title
    [self setTitle: [self.school valueForKey: @"name"]];

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

#pragma mark - Notification Methods

- (void) getSchoolForCurrentUser
{
    PFQuery *schoolQuery = [PFQuery queryWithClassName: @"School"];
    [schoolQuery setLimit: 1];
    
    [schoolQuery getObjectInBackgroundWithId: [[[PFUser currentUser] objectForKey: @"school"] objectId]
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

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

@end
