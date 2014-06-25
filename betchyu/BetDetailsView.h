//
//  BetDetailsView.h
//  betchyu
//
//  Created by Adam Baratz on 6/13/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadingBarView.h"
#import <math.h>
#import "ProgressBarView.h"
@class UpdateView;

@interface BetDetailsView : UIScrollView

@property UpdateView * update;
@property BOOL ownerIsMale;
@property BOOL isMyBet;

- (id)initWithFrame:(CGRect)frame AndBet:(NSDictionary *)bet AndIsMyBet:(BOOL)mine;

@end
