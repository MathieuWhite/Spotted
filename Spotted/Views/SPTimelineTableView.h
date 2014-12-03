//
//  SPTimelineTableView.h
//  Spotted
//
//  Created by Mathieu White on 2014-12-02.
//  Copyright (c) 2014 Mathieu White. All rights reserved.
//

@import Parse;

#import <UIKit/UIKit.h>

@class SPSchool;

@interface SPTimelineTableView : UITableView <UITableViewDelegate, UITableViewDataSource>

- (id) initWithSchool: (SPSchool *) school;

@end
