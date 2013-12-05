//
//  BetStakeVC.h
//  iBetchyu
//
//  Created by Betchyu Computer on 11/24/13.
//  Copyright (c) 2013 Betchyu Computer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TempBet.h"

@interface BetStakeVC : UIViewController

@property (strong) NSArray *stakes;
@property int stakeImageHeight;
@property (strong) TempBet *bet;

-(void) stakeTapped:(id)sender;
-(id) initWithBet:(TempBet *)betObj;

@end
