//
//  MyBetDetailsVC.h
//  betchyu
//
//  Created by Adam Baratz on 6/13/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BetDetailsView.h"

@interface MyBetDetailsVC : UIViewController

@property NSDictionary * betJSON;

- (id)initWithJSONBet:(NSDictionary *)bet;

@end
