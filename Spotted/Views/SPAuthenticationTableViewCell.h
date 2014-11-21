//
//  SPAuthenticationTableViewCell.h
//  Spotted
//
//  Created by Mathieu White on 2014-11-17.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPTextField.h"

typedef NS_ENUM(NSUInteger, SPAuthenticationTableViewCellType)
{
    SPAuthenticationTableViewCellTypeEmail,
    SPAuthenticationTableViewCellTypeName,
    SPAuthenticationTableViewCellTypePassword
};

@interface SPAuthenticationTableViewCell : UITableViewCell

@property (nonatomic, readonly) SPTextField *textField;

@property (nonatomic, assign) BOOL lastCell;

- (void) setAuthenticationTableViewCellType: (SPAuthenticationTableViewCellType) type;

@end
