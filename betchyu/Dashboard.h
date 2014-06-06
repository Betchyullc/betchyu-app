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
#import "MyBetsView.h"

@interface Dashboard : UIView

@property DashHeaderView * head;
@property PendingBetsView * pending;
@property MyBetsView * my;
//@property DashboardVC * controller;

@property int oneH;
@property int twoH;

-(void) adjustPendingHeight:(int)numItems;
-(void) adjustMyBetsHeight:(int)numItems;

-(id)initWithFrame:(CGRect)frame;// AndController:(DashboardVC *)cont;

@end
