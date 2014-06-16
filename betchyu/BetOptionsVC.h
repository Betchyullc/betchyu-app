//
//  BetOptionsVC.h
//  betchyu
//
//  Created by Adam Baratz on 6/16/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TempBet.h"
#import "BetOptionsTopView.h"
#import "DDCalendarView.h"


@interface BetOptionsVC : UIViewController

@property TempBet * bet;
@property NSString * passedBetName;
@property UILabel * detailLabel1;
@property UILabel * detailLabel2;

- (id)initWithBetVerb:(NSString *)verbName;

@end
