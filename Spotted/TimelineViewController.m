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
#import "ComposeViewController.h"
#import "SPNavigationTitleView.h"
#import "SPTimelineTableView.h"
#import "SPColors.h"
#import "SPConstants.h"
#import "SPSchool.h"
#import "SPLoadingView.h"
#import "SPPost.h"
#import "SPAlertBar.h"

@interface TimelineViewController ()

@property (nonatomic, strong) SPSchool *school;

@property (nonatomic, weak) SPNavigationTitleView *titleView;

@property (nonatomic, weak) SPTimelineTableView *tableView;

@property (nonatomic, weak) SPLoadingView *loadingIndicator;

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
    
    // Notification for when the user post is processing
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(showProcessingPostAlert)
                                                 name: kSPPostProcessingNotification
                                               object: nil];
    
    // Notification for when the user post is successful
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(showSuccessfulPostAlert)
                                                 name: kSPPostSuccessfulNotification
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
        __weak typeof(self) weakSelf = self;
        
        PFQuery *schoolQuery = [PFQuery queryWithClassName: kSPSchoolClassName];
        [schoolQuery setLimit: 1];
        
        [schoolQuery getObjectInBackgroundWithId: [[[PFUser currentUser] objectForKey: kSPUserSchoolKey] objectId]
                                           block: ^(PFObject *object, NSError *error)
        {
            if (!error)
            {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                
                [strongSelf.loadingIndicator removeFromSuperview];
                [strongSelf setSchool: (SPSchool *) object];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [strongSelf setupViewForCurrentUser];
                });
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
    
    // Show the loading indicator
    SPLoadingView *loadingIndicator = [SPLoadingView sharedLoadingIndicator];
    [loadingIndicator setTintColor: SPBlackColor20];
    [loadingIndicator showInView: self.view];
    
    // Center X
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: loadingIndicator
                                                           attribute: NSLayoutAttributeCenterX
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.view
                                                           attribute: NSLayoutAttributeCenterX
                                                          multiplier: 1.0f
                                                            constant: 0.0f]];
    
    // Center Y
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: loadingIndicator
                                                           attribute: NSLayoutAttributeCenterY
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.view
                                                           attribute: NSLayoutAttributeCenterY
                                                          multiplier: 1.0f
                                                            constant: 0.0f]];
    
    [self setLoadingIndicator: loadingIndicator];
}

- (void) setupViewForCurrentUser
{
    // School colors
    CGFloat red = [[self.school.colors valueForKey: kSPSchoolRedColorKey] floatValue] / 255.0f;
    CGFloat green = [[self.school.colors valueForKey: kSPSchoolGreenColorKey] floatValue] / 255.0f;
    CGFloat blue = [[self.school.colors valueForKey: kSPSchoolBlueColorKey] floatValue] / 255.0f;
    
    // Navigation bar properties
    [self.navigationController.view setBackgroundColor: SPGrayBackgroundColor];
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
    
    // Set the background color
    [self.view setBackgroundColor: SPGrayBackgroundColor];
    
    // Initialize the table view
    SPTimelineTableView *tableView = [[SPTimelineTableView alloc] initWithSchool: [self school]];
    [tableView setAlpha: 0.0f];
    
    // Add the table view to the main view
    [self.view addSubview: tableView];
    
    // Set each component to its property
    [self setTitleView: titleView];
    [self setTableView: tableView];
    
    // Auto Layout
    [self setupConstraints];
    
    // Animate the content
    [self animateContent];
}

#pragma mark - Private Instance Methods

- (void) animateContent
{
    // Show the navigation bar
    [self.navigationController setNavigationBarHidden: NO animated: YES];
    
    [UIView animateWithDuration: 0.4
                          delay: 0.4
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.tableView setAlpha: 1.0f];
                     }
                     completion: NULL];
}

#pragma mark - BarButtonItem Methods

- (void) showSettings
{
    SettingsViewController *settings = [[SettingsViewController alloc] init];
    
    UINavigationController *settingsNavigationController = [[UINavigationController alloc] initWithRootViewController: settings];
    
    // School colors
    CGFloat red = [[self.school.colors valueForKey: kSPSchoolRedColorKey] floatValue] / 255.0f;
    CGFloat green = [[self.school.colors valueForKey: kSPSchoolGreenColorKey] floatValue] / 255.0f;
    CGFloat blue = [[self.school.colors valueForKey: kSPSchoolBlueColorKey] floatValue] / 255.0f;
    
    [settingsNavigationController.navigationBar setBackgroundImage: [UIImage new] forBarMetrics: UIBarMetricsDefault];
    [settingsNavigationController.navigationBar setShadowImage: [UIImage new]];
    [settingsNavigationController.navigationBar setTranslucent: NO];
    [settingsNavigationController.navigationBar setBarTintColor: [UIColor colorWithRed: red green: green blue: blue alpha: 1.0f]];
    
    [self presentViewController: settingsNavigationController animated: YES completion: ^{
        [self setPresentingView: YES];
    }];
}

- (void) showConversations
{
    NSLog(@"showConversations");
    
    // show compose until compose button is finished
    ComposeViewController *compose = [[ComposeViewController alloc] init];
    
    UINavigationController *composeNavigationController = [[UINavigationController alloc] initWithRootViewController: compose];
    
    // School colors
    CGFloat red = [[self.school.colors valueForKey: kSPSchoolRedColorKey] floatValue] / 255.0f;
    CGFloat green = [[self.school.colors valueForKey: kSPSchoolGreenColorKey] floatValue] / 255.0f;
    CGFloat blue = [[self.school.colors valueForKey: kSPSchoolBlueColorKey] floatValue] / 255.0f;
    
    [composeNavigationController.navigationBar setBackgroundImage: [UIImage new] forBarMetrics: UIBarMetricsDefault];
    [composeNavigationController.navigationBar setShadowImage: [UIImage new]];
    [composeNavigationController.navigationBar setTranslucent: NO];
    [composeNavigationController.navigationBar setBarTintColor: [UIColor colorWithRed: red green: green blue: blue alpha: 1.0f]];
    
    [self presentViewController: composeNavigationController animated: YES completion: ^{
         [self setPresentingView: YES];
    }];
}

#pragma mark - Auto Layout Methods

- (void) setupConstraints
{
    // Table View Top
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.tableView
                                                           attribute: NSLayoutAttributeTop
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.view
                                                           attribute: NSLayoutAttributeTop
                                                          multiplier: 1.0f
                                                            constant: 0.0f]];
    
    // Table View Left
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.tableView
                                                           attribute: NSLayoutAttributeLeft
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.view
                                                           attribute: NSLayoutAttributeLeft
                                                          multiplier: 1.0f
                                                            constant: 0.0f]];
    
    // Table View Right
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.tableView
                                                           attribute: NSLayoutAttributeRight
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.view
                                                           attribute: NSLayoutAttributeRight
                                                          multiplier: 1.0f
                                                            constant: 0.0f]];
    
    // Table View Bottom
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.tableView
                                                           attribute: NSLayoutAttributeBottom
                                                           relatedBy: NSLayoutRelationEqual
                                                              toItem: self.view
                                                           attribute: NSLayoutAttributeBottom
                                                          multiplier: 1.0f
                                                            constant: 0.0f]];
}

#pragma mark - Notification Methods

- (void) showProcessingPostAlert
{
    SPAlertBar *alertBar = [SPAlertBar sharedAlertBar];
    [alertBar setFrame: CGRectMake(0.0f, -30.0f, CGRectGetWidth([self.view bounds]), 30.0f)];
    [alertBar setTintColor: SPAlertBarDefaultColor];
    [alertBar setAlertText: NSLocalizedString(@"Publishing Your Post", nil)];
    
    [self.view addSubview: alertBar];
    
    [UIView animateWithDuration: 0.25
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations: ^{
                         [alertBar setFrame: CGRectMake(0.0f, 0.0f, CGRectGetWidth([self.view bounds]), 30.0f)];
                     }
                     completion: NULL];
}

- (void) showSuccessfulPostAlert
{
    SPAlertBar *alertBar = [SPAlertBar sharedAlertBar];
    [alertBar setTintColor: SPAlertBarSuccessColor];
    [alertBar setAlertText: NSLocalizedString(@"Successfully Posted", nil)];
    
    //[self.view addSubview: alertBar];
    
    [UIView animateWithDuration: 0.25
                          delay: 2.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations: ^{
                         [alertBar setFrame: CGRectMake(0.0f, -30.0f, CGRectGetWidth([self.view bounds]), 30.0f)];
                     }
                     completion: ^(BOOL finished){
                         [alertBar removeFromSuperview];
                     }];
}

- (void) getSchoolForCurrentUser
{
    __weak typeof(self) weakSelf = self;
    
    PFQuery *schoolQuery = [PFQuery queryWithClassName: kSPSchoolClassName];
    [schoolQuery setLimit: 1];
    
    [schoolQuery getObjectInBackgroundWithId: [[[PFUser currentUser] objectForKey: kSPUserSchoolKey] objectId]
                                       block: ^(PFObject *object, NSError *error)
     {
         if (!error)
         {
             __strong typeof(weakSelf) strongSelf = weakSelf;
             
             [strongSelf.loadingIndicator removeFromSuperview];
             [strongSelf setSchool: (SPSchool *) object];
             
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [strongSelf setupViewForCurrentUser];
             });
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
