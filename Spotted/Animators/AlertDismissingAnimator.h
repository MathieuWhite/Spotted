//
//  AlertDismissingAnimator.h
//  Spotted
//
//  Created by Mathieu White on 2014-11-22.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, AlertDismissingAnimatorDirection)
{
    AlertDismissingAnimatorDirectionLeft,
    AlertDismissingAnimatorDirectionRight
};

@interface AlertDismissingAnimator : NSObject <UIViewControllerAnimatedTransitioning>

- (id) initWithDismissingAnimatorDirection: (AlertDismissingAnimatorDirection) direction;

@end
