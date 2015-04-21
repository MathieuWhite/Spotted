//
//  SPCircleButton.m
//  Spotted
//
//  Created by Mathieu White on 2014-12-06.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import "SPCircleButton.h"

@interface SPCircleButton ()

@property (nonatomic, strong) CAShapeLayer *circleLayer;

@end

@implementation SPCircleButton

#pragma mark - Initialization

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame: frame];
    
    if (self)
    {
        [self initCircleButton];
    }
    
    return self;
}

- (void) initCircleButton
{
    CGFloat lineWidth = 2.0f;
    CGFloat radius = CGRectGetWidth([self bounds]) / 2.0f - lineWidth / 2.0f;
    CGRect rect = CGRectMake(lineWidth / 2.0f, lineWidth / 2.0f, radius * 2.0f, radius * 2.0f);
    
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    [circleLayer setPath: [UIBezierPath bezierPathWithRoundedRect: rect cornerRadius: radius].CGPath];
    [circleLayer setFillColor:[[UIColor purpleColor] CGColor]];
    
    [self.layer addSublayer: circleLayer];
    
    [self setCircleLayer: circleLayer];
}

- (void) setTintColor:(UIColor *)tintColor
{
    [self.circleLayer setFillColor: [tintColor CGColor]];
}

@end
