//
//  FriendsPastBetsView.h
//  betchyu
//
//  Created by Adam Baratz on 6/11/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadingBarView.h"

@interface FriendsPastBetsView : UIView

@property int rowHt;
@property int fontSize;
@property NSArray * bets;

-(void) drawBets:(NSArray *)betList;

@end
