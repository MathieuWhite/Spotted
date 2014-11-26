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
    
    // Dictionary for the preferences section
    NSMutableDictionary *preferencesSection = [[NSMutableDictionary alloc] init];
    [preferencesSection setValue: NSLocalizedString(@"General", nil) forKey: @"title"];
    
    // Dictionary for the support section
    NSMutableDictionary *supportSection = [[NSMutableDictionary alloc] init];
    [supportSection setValue: NSLocalizedString(@"Info", nil) forKey: @"title"];
    
    // Dictionary for the account section
    NSMutableDictionary *accountSection = [[NSMutableDictionary alloc] init];
    [accountSection setValue: NSLocalizedString(@"Account", nil) forKey: @"title"];
    
    // Array of rows for the preferences section
    NSMutableArray *preferencesRows = [NSMutableArray array];
    [preferencesRows addObject: @"Settings 1"];
    [preferencesRows addObject: @"Settings 2"];
    [preferencesRows addObject: @"Settings 3"];
    
    // Array of rows for the support section
    NSMutableArray *supportRows = [NSMutableArray array];
    [supportRows addObject: @"Help"];
    [supportRows addObject: @"About"];

    // Array of rows for the account section
    NSMutableArray *accountRows = [NSMutableArray array];
    [accountRows addObject: @"Sign Out"];
    [accountRows addObject: @"Delete Account"];
    
    // Add each row array to their section
    [preferencesSection setValue: preferencesRows forKey: @"rows"];
    [supportSection setValue: supportRows forKey: @"rows"];
    [accountSection setValue: accountRows forKey: @"rows"];

    // Add each section to the settings array
    [sections addObject: preferencesSection];
    [sections addObject: supportSection];
    [sections addObject: accountSection];
    
    [self setSections: [sections copy]];
}

@end
