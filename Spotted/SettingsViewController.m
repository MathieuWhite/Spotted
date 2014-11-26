//
//  SettingsViewController.m
//  Spotted
//
//  Created by Mathieu White on 2014-11-25.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import "SettingsViewController.h"
#import "SPSettingsTableViewCell.h"
#import "SPSettingsTableViewSectionHeader.h"
#import "SPSettings.h"
#import "SPColors.h"

@interface SettingsViewController ()

@property (nonatomic, strong) SPSettings *settings;

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation SettingsViewController

- (void) viewDidLoad
{
    [super viewDidLoad];

    // Initialize the settings dictionary
    SPSettings *settings = [SPSettings appSettings];
    [self setSettings: settings];
    
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
    [self.view setBackgroundColor: SPGrayBackgroundColor];
    
    // Initialize the table view
    UITableView *tableView = [[UITableView alloc] initWithFrame: CGRectZero style: UITableViewStyleGrouped];
    [tableView setBackgroundColor: [UIColor clearColor]];
    [tableView setSeparatorColor: SPCellSeparatorColor];
    [tableView setTableFooterView: [[UIView alloc] initWithFrame: CGRectZero]];
    [tableView setTranslatesAutoresizingMaskIntoConstraints: NO];
    [tableView setDataSource: self];
    [tableView setDelegate: self];
    
    // Add each component to the view
    [self.view addSubview: tableView];
    
    // Set each component to its property
    [self setTableView: tableView];
    
    // Auto Layout
    [self setupConstraints];
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

#pragma mark - Auto Layout Method

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

#pragma mark - UITableViewDataSource Methods

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
    return [self.settings.sections count];
}

- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection: (NSInteger) section
{
    return [[[self.settings.sections objectAtIndex: section] valueForKey: @"rows"] count];
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
    static NSString *identifier = @"cell";
    
    SPSettingsTableViewCell *cell = (SPSettingsTableViewCell *) [tableView dequeueReusableCellWithIdentifier: identifier];
    
    if (cell == nil)
        cell = [[SPSettingsTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: identifier];
    
    NSString *rowLabel = [[[self.settings.sections objectAtIndex: [indexPath section]] valueForKey: @"rows"] objectAtIndex: [indexPath row]];
    
    [cell.textLabel setText: rowLabel];
    
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
    return 48.0f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32.0f;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    if ([indexPath row] == 0)
        NSLog(@"logout");
    
    if ([indexPath row] == 1)
        NSLog(@"delete account");
}

- (UIView *) tableView: (UITableView *) tableView viewForHeaderInSection: (NSInteger) section
{
    SPSettingsTableViewSectionHeader *sectionHeader = [[SPSettingsTableViewSectionHeader alloc] init];
    
    [sectionHeader setHeaderTitle: [[self.settings.sections objectAtIndex: section] valueForKey: @"title"]];
    
    [sectionHeader setTintColor: SPSettingsSectionHeaderTextColor];
    
    return sectionHeader;
}

@end
