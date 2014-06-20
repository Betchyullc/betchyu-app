//  YourPastBetsView.h
//  betchyu
//
//  Created by Daniel Zapata on 6/11/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.

#import <UIKit/UIKit.h>
#import "HeadingBarView.h"

@interface YourPastBetsView : UIView

@property int fontSize;
@property int rowHt;

@property NSArray * bets;

-(void)drawBets:(NSArray *)betList;

@end
