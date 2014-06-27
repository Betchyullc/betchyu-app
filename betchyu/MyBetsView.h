//  MyBetsView.h
//  betchyu
//
//  Created by Adam Baratz on 6/5/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.

#import <UIKit/UIKit.h>
#import "ExistingBetDetailsVC.h"
#import "CompletionBorderView.h"

@interface MyBetsView : UIView <UIAlertViewDelegate>

@property UIScrollView * scroller;
@property NSArray * bets;

@property int fontSize;
@property int rowHt;

-(void) addBets:(NSArray *)myBets;

@end
