//
//  SPSettings.m
//  Spotted
//
//  Created by Mathieu White on 2014-11-25.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import "SPSettings.h"

@implementation SPSettings

#pragma mark - Initialization

+ (SPSettings *) appSettings
{
    static SPSettings *_sharedSettings = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedSettings = [[SPSettings alloc] init];
    });
    
    return _sharedSettings;
}

- (id) init
{
    self = [super init];
    
    if (self)
    {
        [self initAppSettings];
    }
    
    return self;
}

- (void) initAppSettings
{
    // Settings sections array
    NSMutableArray *sections = [NSMutableArray array];
    
    // Dictionary for the general section
    NSMutableDictionary *generalSection = [[NSMutableDictionary alloc] init];
    [generalSection setValue: NSLocalizedString(@"General", nil) forKey: @"title"];
    
    // Dictionary for the info section
    NSMutableDictionary *infoSection = [[NSMutableDictionary alloc] init];
    [infoSection setValue: NSLocalizedString(@"Info", nil) forKey: @"title"];
    
    // Dictionary for the account section
    NSMutableDictionary *accountSection = [[NSMutableDictionary alloc] init];
    [accountSection setValue: NSLocalizedString(@"Account", nil) forKey: @"title"];
    
    // Array of rows for the general section
    NSMutableArray *generalRows = [NSMutableArray array];
    [generalRows addObject: @"Settings 1"];
    [generalRows addObject: @"Settings 2"];
    [generalRows addObject: @"Settings 3"];
    
    // Array of rows for the info section
    NSMutableArray *infoRows = [NSMutableArray array];
    [infoRows addObject: @"Help"];
    [infoRows addObject: @"About"];

    // Array of rows for the account section
    NSMutableArray *accountRows = [NSMutableArray array];
    [accountRows addObject: @"Sign Out"];
    [accountRows addObject: @"Delete Account"];
    
    // Add each row array to their section
    [generalSection setValue: generalRows forKey: @"rows"];
    [infoSection setValue: infoRows forKey: @"rows"];
    [accountSection setValue: accountRows forKey: @"rows"];

    // Add each section to the settings array
    [sections addObject: generalSection];
    [sections addObject: infoSection];
    [sections addObject: accountSection];
    
    [self setSections: [sections copy]];
}

@end
