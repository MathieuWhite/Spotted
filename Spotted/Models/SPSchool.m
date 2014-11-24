//
//  SPSchool.m
//  Spotted
//
//  Created by Mathieu White on 2014-11-24.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import "SPSchool.h"

@implementation SPSchool

@dynamic name;
@dynamic domain;
@dynamic colors;
@dynamic coordinates;

+ (void) load
{
    [self registerSubclass];
}

+ (NSString *) parseClassName
{
    return @"School";
}

@end
