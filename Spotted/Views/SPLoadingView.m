//
//  SPLoadingView.m
//  Spotted
//
//  Created by Mathieu White on 2014-11-28.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import "SPLoadingView.h"
#import "POP.h"

@interface SPLoadingView ()

@property (nonatomic, weak) UIImageView *loadingImageView;
@property (nonatomic, weak) UIImage *loadingImage;

@end

@implementation SPLoadingView

#pragma mark - Initilization

+ (SPLoadingView *) sharedLoadingIndicator
{
    static SPLoadingView *_sharedLoadingIndicator;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedLoadingIndicator = [[SPLoadingView alloc] init];
    });
    
    return _sharedLoadingIndicator;
}

- (instancetype) init
{
    self = [super init];
    
    if (self)
    {
        UIImage *loadingImage = [UIImage imageNamed: @"loadingImage"];
        loadingImage = [loadingImage imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
        
        UIImageView *loadingImageView = [[UIImageView alloc] initWithImage: loadingImage];
        [loadingImageView setTranslatesAutoresizingMaskIntoConstraints: NO];
        
        POPSpringAnimation *rotationAnimation = [POPSpringAnimation animationWithPropertyNamed: kPOPLayerRotation];
        [rotationAnimation setBeginTime: CACurrentMediaTime() + 0.4];
        [rotationAnimation setToValue: @(M_PI / 2.0)];
        [rotationAnimation setDynamicsMass: 2.0f];
        [rotationAnimation setDynamicsFriction: 20.0f];
        [rotationAnimation setRepeatForever: YES];
        [rotationAnimation setAdditive: YES];
        [loadingImageView.layer pop_addAnimation: rotationAnimation forKey: @"rotateSpringAnimation"];
        
        [self setTranslatesAutoresizingMaskIntoConstraints: NO];
        [self addSubview: loadingImageView];
        
        [self setLoadingImage: loadingImage];
        [self setLoadingImageView: loadingImageView];
        
        [self autoLayoutComponents];
    }
    
    return self;
}

- (void) showInView: (UIView *) view
{
    [view addSubview: self];
}

- (void) removeFromSuperview
{
    [UIView animateWithDuration: 0.4
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations: ^{
                         [self setAlpha: 0.0f];
                     }
                     completion: ^(BOOL finished) {
                         [super removeFromSuperview];
                     }];
}

- (void) setTintColor: (UIColor *) tintColor
{
    [self.loadingImageView setTintColor: tintColor];
}

- (void) autoLayoutComponents
{
    // Center X
    [self addConstraint: [NSLayoutConstraint constraintWithItem: self.loadingImageView
                                                      attribute: NSLayoutAttributeCenterX
                                                      relatedBy: NSLayoutRelationEqual
                                                         toItem: self
                                                      attribute: NSLayoutAttributeCenterX
                                                     multiplier: 1.0f
                                                       constant: 0.0f]];
    
    // Center Y
    [self addConstraint: [NSLayoutConstraint constraintWithItem: self.loadingImageView
                                                      attribute: NSLayoutAttributeCenterY
                                                      relatedBy: NSLayoutRelationEqual
                                                         toItem: self
                                                      attribute: NSLayoutAttributeCenterY
                                                     multiplier: 1.0f
                                                       constant: 0.0f]];
}

@end
