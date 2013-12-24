//
//  ExistingBetDetailsVC.h
//  betchyu
//
//  Created by Adam Baratz on 12/16/13.
//  Copyright (c) 2013 BetchyuLLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TempBet.h"

@interface ExistingBetDetailsVC : UIViewController <UIAlertViewDelegate>

@property NSDictionary * betJSON;
@property TempBet * bet;
@property BOOL isOffer;
@property UILabel *stakeDescription;
@property NSDictionary *invite;

-(id) initWithJSON:(NSDictionary *)json;
-(id) initWithJSON:(NSDictionary *)json AndOfferBool:(BOOL)passedOffer;

@end
