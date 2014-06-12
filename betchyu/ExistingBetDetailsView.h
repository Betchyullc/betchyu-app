//
//  ExistingBetDetailsView.h
//  betchyu
//
//  Created by Adam Baratz on 6/12/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadingBarView.h"
#import <math.h>
#import "ProgressBarView.h"

@interface ExistingBetDetailsView : UIScrollView

@property BOOL ownerIsMale;

- (id)initWithFrame:(CGRect)frame AndBet:(NSDictionary *)bet;

@end
