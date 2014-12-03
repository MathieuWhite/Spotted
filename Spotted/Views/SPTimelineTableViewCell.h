//
//  SPTimelineTableViewCell.h
//  Spotted
//
//  Created by Mathieu White on 2014-12-02.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPTimelineCellLabel.h"

@interface SPTimelineTableViewCell : UITableViewCell

@property (nonatomic, weak) NSDate *date;
@property (nonatomic, weak) SPTimelineCellLabel *contentLabel;

@end
