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
#import "FriendsBetsSubview.h"

@interface Dashboard : UIScrollView

@property DashHeaderView * head;
@property PendingBetsView * pending;
@property MyBetsView * my;
@property FriendsBetsSubview * friends;

@property int oneH;
@property int rowH;

-(void) adjustPendingHeight:(int)numItems;
-(void) adjustMyBetsHeight:(int)numItems;
-(void) adjustFriendsBetsHeight:(int)numItems;

-(id)initWithFrame:(CGRect)frame;// AndController:(DashboardVC *)cont;

@end
