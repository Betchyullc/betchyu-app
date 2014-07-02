//  BetSummaryVC.h
//  betchyu
//
//  Created by Daniel Zapata on 5/7/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "TempBet.h"
#import "SummaryHeaderView.h"
#import "SummaryOpponentsView.h"
#import "SummaryStakeView.h"
#import "AlertMaker.h"

@interface BetSummaryVC : GAITrackedViewController

@property (strong) TempBet * bet;

-(id)initWithBet:(TempBet *)betObj;
-(void) home;

@end
