//
//  SPFlatButton.m
//  Spotted
//
//  Created by Mathieu White on 2014-11-16.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import "SPFlatButton.h"
#import "POP.h"

@implementation SPFlatButton

#pragma mark - Initialization

- (instancetype) init
{
    self = [super init];
    
    if (self)
    {
        [self initFlatButton];
    }
    
    return self;
}

- (void) initFlatButton
{
    [self.titleLabel setFont: [UIFont fontWithName: @"Avenir-Light" size: 20.0f]];
    [self.layer setCornerRadius: 4.0f];
    
    [self addTarget: self action: @selector(scaleToSmall) forControlEvents: UIControlEventTouchDown | UIControlEventTouchDragEnter];
    [self addTarget: self action: @selector(scaleAnimation) forControlEvents: UIControlEventTouchUpInside];
    [self addTarget: self action: @selector(scaleToDefault) forControlEvents: UIControlEventTouchDragExit];
}

#pragma mark - Instance Methods

- (UIEdgeInsets) titleEdgeInsets
{
    return UIEdgeInsetsMake(4.0f, 28.0f, 4.0f, 28.0f);
}

- (CGSize) intrinsicContentSize
{
    CGSize s = [super intrinsicContentSize];
    
    return CGSizeMake(s.width + self.titleEdgeInsets.left + self.titleEdgeInsets.right,
                      s.height + self.titleEdgeInsets.top + self.titleEdgeInsets.bottom);
    
}

#pragma mark - Animations

- (void) scaleToSmall
{
    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed: kPOPLayerScaleXY];
    [scaleAnimation setToValue: [NSValue valueWithCGSize: CGSizeMake(0.9f, 0.9f)]];
    [self.layer pop_addAnimation: scaleAnimation forKey: @"scaleSmallSpringAnimation"];
}

- (void) scaleAnimation
{
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed: kPOPLayerScaleXY];
    [scaleAnimation setVelocity: [NSValue valueWithCGSize: CGSizeMake(3.0f, 3.0f)]];
    [scaleAnimation setToValue: [NSValue valueWithCGSize: CGSizeMake(1.0f, 1.0f)]];
    [scaleAnimation setSpringBounciness: 18.0f];
    [self.layer pop_addAnimation: scaleAnimation forKey: @"scaleSpringAnimation"];
}

- (void) scaleToDefault
{
    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed: kPOPLayerScaleXY];
    [scaleAnimation setToValue: [NSValue valueWithCGSize: CGSizeMake(1.0f, 1.0f)]];
    [self.layer pop_addAnimation: scaleAnimation forKey: @"scaleDefaultSpringAnimation"];
}

@end
