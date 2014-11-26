//
//  SPSettings.h
//  Spotted
//
//  Created by Mathieu White on 2014-11-25.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPSettings : NSObject

@property (nonatomic, copy) NSArray *sections;

+ (SPSettings *) appSettings;

@end
