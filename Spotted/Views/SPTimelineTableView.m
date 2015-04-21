//
//  SPTimelineTableView.m
//  Spotted
//
//  Created by Mathieu White on 2014-12-02.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import "SPTimelineTableView.h"
#import "SPTimelineTableViewCell.h"
#import "SPColors.h"
#import "SPConstants.h"
#import "SPPost.h"

@interface SPTimelineTableView ()

@property (nonatomic, strong) SPSchool *currentSchool;

@property (nonatomic, strong) NSArray *postsArray;

@property (nonatomic, strong) NSMutableDictionary *offscreenCells;

@property (nonatomic, weak) UIRefreshControl *refreshControl;
@property (nonatomic, assign) BOOL releaseToRefresh;

@end

@implementation SPTimelineTableView

#pragma mark - Initialization

- (id) initWithSchool: (SPSchool *) school
{
    self = [super init];
    
    if (self)
    {
        _currentSchool = school;
        [self initTimelineTableView];
    }
    
    return self;
}

- (void) initTimelineTableView
{
    [self setBackgroundColor: [UIColor clearColor]];
    [self setSeparatorStyle: UITableViewCellSeparatorStyleNone];
    [self setTableFooterView: [[UIView alloc] initWithFrame: CGRectZero]];
    [self setDataSource: self];
    [self setDelegate: self];
    
    // Initialize the off screen cells dictionary
    NSMutableDictionary *offscreenCells = [[NSMutableDictionary alloc] init];
    [self setOffscreenCells: offscreenCells];
    
    // Initialize the refresh control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl setTintColor: SPBlackColor20];
    [refreshControl addTarget: self action: @selector(pullToRefresh) forControlEvents: UIControlEventValueChanged];
    [refreshControl addTarget: self action: @selector(refreshTable) forControlEvents: UIControlEventTouchUpInside];
    
    // Add the refresh control to the table
    [self addSubview: refreshControl];
    
    // Fetch Posts for Current School
    [self fetchPosts];
    
    // Set each component to its property
    [self setRefreshControl: refreshControl];
    
    // Auto Layout
    [self setTranslatesAutoresizingMaskIntoConstraints: NO];
    [self setupConstraints];
}

#pragma mark - Private Instance Methods

- (void) fetchPosts
{
    __weak typeof(self) weakSelf = self;
    
    PFQuery *postQuery = [PFQuery queryWithClassName: kSPPostClassName];
    [postQuery setLimit: 100]; // 100 is the default limit
    [postQuery whereKey: kSPPostSchoolKey equalTo: [self currentSchool]];
    [postQuery orderByDescending: kSPPostCreatedAtKey];
    
    [postQuery findObjectsInBackgroundWithBlock: ^(NSArray *objects, NSError *error) {
        if (!error)
        {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            [strongSelf setPostsArray: objects];
            [strongSelf reloadData];
        }
        else
            NSLog(@"ERROR: %@", [error description]);
    }];
}

- (void) pullToRefresh
{
    [self setReleaseToRefresh: YES];
}

- (void) refreshTable
{
    if ([self releaseToRefresh])
    {
        __weak typeof(self) weakSelf = self;
        
        PFQuery *postQuery = [PFQuery queryWithClassName: kSPPostClassName];
        [postQuery setLimit: 100]; // 100 is the default limit
        [postQuery whereKey: kSPPostSchoolKey equalTo: [self currentSchool]];
        [postQuery orderByDescending: kSPPostCreatedAtKey];
        
        [postQuery findObjectsInBackgroundWithBlock: ^(NSArray *objects, NSError *error) {
            if (!error)
            {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                
                [strongSelf setPostsArray: objects];
                [strongSelf.refreshControl endRefreshing];
                [strongSelf reloadData];
                [strongSelf setReleaseToRefresh: NO];
            }
            else
                NSLog(@"ERROR: %@", [error description]);
        }];
    }
}

#pragma mark - Auto Layout Method

- (void) setupConstraints
{
    
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection: (NSInteger) section
{
    if ([self postsArray])
        return [self.postsArray count];
    
    return 0;
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
    static NSString *cellIdentifier = @"TimelineCell";
    
    SPTimelineTableViewCell *cell = (SPTimelineTableViewCell *) [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
    
    if (cell == nil)
        cell = [[SPTimelineTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellIdentifier];
    
    SPPost *post = [self.postsArray objectAtIndex: [indexPath row]];
    
    [cell setDate: [post createdAt]];
    [cell.contentLabel setText: [post content]];
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];

    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
    static NSString *cellIdentifier = @"TimelineCell";
    
    SPTimelineTableViewCell *cell = [self.offscreenCells objectForKey: cellIdentifier];
    if (cell == nil)
    {
        cell = [[SPTimelineTableViewCell alloc] init];
        [self.offscreenCells setObject: cell forKey: cellIdentifier];
    }
    
    SPPost *post = [self.postsArray objectAtIndex: [indexPath row]];
    
    [cell setDate: [post createdAt]];
    [cell.contentLabel setText: [post content]];
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    [cell setBounds: CGRectMake(0.0f, 0.0f, CGRectGetWidth([tableView bounds]), CGRectGetHeight([cell bounds]))];
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize: UILayoutFittingCompressedSize].height;
    
    height += 1.0f;
    
    return height;
}

- (CGFloat) tableView: (UITableView *) tableView estimatedHeightForRowAtIndexPath: (NSIndexPath *) indexPath
{
    return 68.0f;
}

#pragma mark - UIScrollViewDelegate Methods

- (void) scrollViewDidEndDecelerating: (UIScrollView *) scrollView
{
    if ([self.refreshControl isRefreshing])
        [self refreshTable];
}

@end
