//
//  DashboardVC.h
//  betchyu
//
//  Created by Adam Baratz on 6/2/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dashboard.h"
#import "API.h"
#import "BetTypeViewController.h"
#import "MyBetsVC.h"
#import "MyGoalsVC.h"
#import <Braintree/BTEncryption.h>
#import "BTPaymentViewController.h"

@interface DashboardVC : UIViewController //<BTPaymentViewControllerDelegate>

@property NSString * numberOfInvites;
@property UILabel * numNotif;
@property BOOL hasShownHowItWorks;
@property BOOL canLeavePage;
@property BetTypeViewController *createGoalController;


- (id)initWithInviteNumber:(NSString *)numInvs;

@end
