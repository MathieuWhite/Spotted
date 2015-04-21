//
//  SPComposeBar.m
//  Spotted
//
//  Created by Mathieu White on 2014-12-06.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import "SPComposeBar.h"
#import "SPCircleButton.h"

@implementation SPComposeBar

#pragma mark - Initialization

+ (SPComposeBar *) sharedComposeBar
{
    static SPComposeBar *_sharedComposeBar;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedComposeBar = [[SPComposeBar alloc] init];
    });
    
    return _sharedComposeBar;
}

- (instancetype) init
{
    self = [super init];
    
    if (self)
    {
        [self initComposeBar];
    }
    
    return self;
}

- (void) initComposeBar
{
    // Set the background image
    [self setBackgroundColor: [UIColor colorWithPatternImage: [UIImage imageNamed: @"composeBar"]]];
    
    SPCircleButton *testButton = [[SPCircleButton alloc] initWithFrame: CGRectMake(0.0f, 0.0f, 48.0f, 48.0f)];
    [testButton setTintColor: [UIColor orangeColor]];
    [self addSubview: testButton];
}

@end
