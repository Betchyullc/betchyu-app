//
//  PendingBetsView.h
//  betchyu
//
//  Created by Adam Baratz on 6/3/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "BraintreeDelegateController.h"

@interface PendingBetsView : UIView <UIAlertViewDelegate>

@property NSArray * bets;
@property NSMutableArray * bits;
@property NSDictionary * selectedBet;

@property int fontSize;
@property int rowHt;

@property BOOL isWide;

-(id) initWithFrame:(CGRect)frame;
-(void) addBets:(NSArray *)pending;

@end
