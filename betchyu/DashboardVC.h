//
//  DashboardVC.h
//  betchyu
//
//  Created by Daniel Zapata on 6/2/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dashboard.h"
#import "API.h"
#import <Braintree/BTEncryption.h>
#import "BTPaymentViewController.h"
#import "CreateBetVC.h"

@interface DashboardVC : UIViewController //<BTPaymentViewControllerDelegate>

@property NSString * numberOfInvites;
@property UILabel * numNotif;
@property BOOL hasShownHowItWorks;
@property BOOL canLeavePage;
@property CreateBetVC *createGoalController;


- (id)initWithInviteNumber:(NSString *)numInvs;

@end