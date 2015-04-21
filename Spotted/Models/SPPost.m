//
//  SPPost.m
//  Spotted
//
//  Created by Mathieu White on 2014-11-30.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import "SPPost.h"
#import "SPConstants.h"

@implementation SPPost

@dynamic content;
@dynamic photo;
@dynamic photoThumbnail;
@dynamic user;
@dynamic school;

+ (void) load
{
    [self registerSubclass];
}

+ (NSString *) parseClassName
{
    return kSPPostClassName;
}

@end
