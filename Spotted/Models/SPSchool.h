//
//  SPSchool.h
//  Spotted
//
//  Created by Mathieu White on 2014-11-24.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

@import Parse;

#import <Foundation/Foundation.h>

@interface SPSchool : PFObject <PFSubclassing>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *domain;
@property (nonatomic, strong) NSDictionary *colors;
@property (nonatomic, strong) NSDictionary *coordinates;

@end
