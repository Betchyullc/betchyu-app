//
//  BraintreeDelegateController.h
//  betchyu
//
//  Created by Adam Baratz on 6/6/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Braintree/BTEncryption.h>
#import "BTPaymentViewController.h"
#import "API.h"
#import "TempBet.h"


@interface BraintreeDelegateController : NSObject <BTPaymentViewControllerDelegate>

@property TempBet * bet;
@property id del;
@property NSNumber * ident;

+(BraintreeDelegateController *)sharedInstance;

@end
