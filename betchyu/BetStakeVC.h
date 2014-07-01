//
//  BetStakeVC.h
//  iBetchyu
//
//  Created by Betchyu Computer on 11/24/13.
//  Copyright (c) 2013 Betchyu Computer. All rights reserved.

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "TempBet.h"
#import "BetOptionsTopView.h"
#import "GAITrackedViewController.h"

@interface BetStakeVC : GAITrackedViewController

@property (strong) NSArray *stakes;
@property int stakeImageHeight;
@property (strong) TempBet *bet;

-(void) stakeTapped:(id)sender;
-(id) initWithBet:(TempBet *)betObj;

@end
