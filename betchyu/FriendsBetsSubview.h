//
//  FriendsBetsSubview.h
//  betchyu
//
//  Created by Adam Baratz on 6/9/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsBetsSubview : UIView

@property NSArray * bets;

@property int fontSize;
@property int rowHt;

-(void)addBets:(NSArray *)betList;

@end
