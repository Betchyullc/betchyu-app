//  MyBetDetailsVC.h
//  betchyu
//
//  Created by Daniel Zapata on 6/13/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.

#import <UIKit/UIKit.h>
#import "BetDetailsView.h"

@interface MyBetDetailsVC : GAITrackedViewController

@property NSDictionary * betJSON;

- (id)initWithJSONBet:(NSDictionary *)bet;

@end
