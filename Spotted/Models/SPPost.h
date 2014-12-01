//
//  SPPost.h
//  Spotted
//
//  Created by Mathieu White on 2014-11-30.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import <Parse/Parse.h>
#import "SPSchool.h"

@interface SPPost : PFObject <PFSubclassing>

@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) SPSchool *school;

@end
