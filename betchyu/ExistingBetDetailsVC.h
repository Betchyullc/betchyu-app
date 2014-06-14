//
//  ExistingBetDetailsVC.h
//  betchyu
//
//  Created by Daniel Zapata on 12/16/13.
//  Copyright (c) 2013 BetchyuLLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TempBet.h"
#import <Braintree/BTEncryption.h>
#import "BTPaymentViewController.h"

@interface ExistingBetDetailsVC : UIViewController

@property NSDictionary * betJSON;
@property BOOL isOffer;
@property BOOL isOwn;

-(id) initWithJSON:(NSDictionary *)json;
-(id) initWithJSON:(NSDictionary *)json AndOfferBool:(BOOL)passedOffer;

@end
