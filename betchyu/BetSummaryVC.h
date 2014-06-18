//
//  BetSummaryVC.h
//  betchyu
//
//  Created by Adam Baratz on 5/7/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "TempBet.h"
#import "BigButton.h"
#import "SummaryHeaderView.h"
#import "SummaryOpponentsView.h"
#import "SummaryStakeView.h"

@interface BetSummaryVC : UIViewController

@property (strong) TempBet * bet;
@property NSManagedObjectContext * managedObjectContext;

-(id)initWithBet:(TempBet *)betObj;
-(void) home;

@end
