//
//  StakeDetailsVC.h
//  betchyu
//
//  Created by Adam Baratz on 6/17/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StakeDetailsView.h"
#import "BetSummaryVC.h"
#import "BTPaymentViewController.h"

@interface StakeDetailsVC : UIViewController <UIAlertViewDelegate>

@property (strong) TempBet *bet;
@property int currentStake;
@property StakeDetailsView * staticStuff;

- (id)initWithBet:(TempBet *)betObj;

@end
