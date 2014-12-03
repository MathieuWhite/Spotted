//
//  SPAlertBar.h
//  Spotted
//
//  Created by Mathieu White on 2014-12-03.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPAlertBar : UIView

+ (SPAlertBar *) sharedAlertBar;

- (void) setAlertText: (NSString *) alertText;

@end
