//
//  Dashboard.h
//  betchyu
//
//  Created by Adam Baratz on 6/2/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashHeaderView.h"
#import "PendingBetsView.h"

@interface Dashboard : UIView

@property DashHeaderView * head;
@property PendingBetsView * pending;

@end
