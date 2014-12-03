//
//  SPTimelineCellLabel.m
//  Spotted
//
//  Created by Mathieu White on 2014-12-02.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import "SPTimelineCellLabel.h"

@implementation SPTimelineCellLabel

- (void) setBounds: (CGRect) bounds
{
    [super setBounds: bounds];
    
    if ([self numberOfLines] == 0 && bounds.size.width != [self preferredMaxLayoutWidth])
    {
        [self setPreferredMaxLayoutWidth: CGRectGetWidth([self bounds])];
        [self setNeedsUpdateConstraints];
    }
}

@end
