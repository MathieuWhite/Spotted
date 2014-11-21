//
//  SPSignUpTableView.m
//  Spotted
//
//  Created by Mathieu White on 2014-11-17.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import "SPSignUpTableView.h"

@implementation SPSignUpTableView

- (id) init
{
    self = [super init];
    
    if (self)
    {
        [self initSignUpTableView];
    }
    
    return self;
}

- (void) initSignUpTableView
{
    [self setBackgroundColor: [UIColor clearColor]];
    [self setSeparatorStyle: UITableViewCellSeparatorStyleNone];
    [self setScrollEnabled: NO];
    [self setDataSource: self];
    [self setDelegate: self];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
    return 1;
}

- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection: (NSInteger) section
{
    return 3;
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
    static NSString *cellIdentifier = @"TextInputCell";
    
    SPAuthenticationTableViewCell *cell = (SPAuthenticationTableViewCell *) [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
    
    if (cell == nil)
        cell = [[SPAuthenticationTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellIdentifier];
    
    if ([indexPath row] == 0)
        [cell setAuthenticationTableViewCellType: SPAuthenticationTableViewCellTypeEmail];
    
    if ([indexPath row] == 1)
        [cell setAuthenticationTableViewCellType: SPAuthenticationTableViewCellTypeName];
    
    if ([indexPath row] == [tableView numberOfRowsInSection: 0] - 1)
    {
        SPAuthenticationTableViewCell *lastCell = [[SPAuthenticationTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                                                                       reuseIdentifier: @"lastCell"];
        
        [lastCell setAuthenticationTableViewCellType: SPAuthenticationTableViewCellTypePassword];
        [lastCell setLastCell: YES];
        [lastCell.textField setDelegate: self];
        return lastCell;
    }
    
    [cell.textField setDelegate: self];
    
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
    return 60.0f;
}

#pragma mark - UITextField Delegate

- (BOOL) textFieldShouldReturn: (UITextField *) textField
{
    SPAuthenticationTableViewCell *currentCell = (SPAuthenticationTableViewCell *) [textField.superview superview];
    NSIndexPath *currentIndexPath = [self indexPathForCell: currentCell];
    
    if ([currentIndexPath row] == 0)
    {
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem: currentIndexPath.row + 1 inSection: 0];
        SPAuthenticationTableViewCell *nextCell = (SPAuthenticationTableViewCell *) [self cellForRowAtIndexPath: nextIndexPath];
        [nextCell.textField becomeFirstResponder];
    }
    
    if ([currentIndexPath row] == 1)
    {
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem: currentIndexPath.row + 1 inSection: 0];
        SPAuthenticationTableViewCell *nextCell = (SPAuthenticationTableViewCell *) [self cellForRowAtIndexPath: nextIndexPath];
        [nextCell.textField becomeFirstResponder];
    }
    
    [textField resignFirstResponder];
    
    return NO;
}

@end
