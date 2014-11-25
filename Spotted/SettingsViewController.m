//
//  SettingsViewController.m
//  Spotted
//
//  Created by Mathieu White on 2014-11-25.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import "SettingsViewController.h"
#import "SPColors.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void) viewDidLoad
{
    [super viewDidLoad];

    // Navigation Bar Title Properties
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                       NSFontAttributeName : [UIFont fontWithName: @"Avenir-Light" size: 20.0f]}];
    
    // Navigation Bar Title
    [self setTitle: NSLocalizedString(@"Settings", nil)];
    
    // Done Bar Button Item
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                                                                target: self
                                                                                action: @selector(dismissSettings)];
    [doneButton setTintColor: [UIColor whiteColor]];
    [doneButton setTitleTextAttributes: @{ NSFontAttributeName : [UIFont fontWithName: @"Avenir-Light" size: 16.0f]}
                              forState: UIControlStateNormal];
    
    // Add the bar button item
    [self.navigationItem setLeftBarButtonItem: doneButton];
    
    // Set the background color
    [self.view setBackgroundColor: SPGrayBackground];
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - BarButtonItem Methods

- (void) dismissSettings
{
    [self dismissViewControllerAnimated: YES completion: NULL];
}

@end
