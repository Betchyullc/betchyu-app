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
#import "UISwipeWithTag.h"
@class UpdateView;

@interface BetDetailsView : UIScrollView <UITextFieldDelegate, UIAlertViewDelegate>

@property NSDictionary *bet;

@property UpdateView * update;
@property BOOL ownerIsMale;
@property BOOL isMyBet;

@property UIView *comments;
@property UITextField *commentBox;

- (id)initWithFrame:(CGRect)frame AndBet:(NSDictionary *)bet AndIsMyBet:(BOOL)mine;

@end
