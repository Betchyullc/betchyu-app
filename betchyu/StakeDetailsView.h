//
//  StakeDetailsView.h
//  betchyu
//
//  Created by Adam Baratz on 6/17/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TempBet.h"

@interface StakeDetailsView : UIScrollView

@property NSString * stakeType;

- (id)initWithFrame:(CGRect)frame AndStakeType:(NSString *)type;

@end
