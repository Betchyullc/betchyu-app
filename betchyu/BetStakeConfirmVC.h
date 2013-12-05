//
//  BetStakeConfirmVC.h
//  iBetchyu
//
//  Created by Betchyu Computer on 11/24/13.
//  Copyright (c) 2013 Betchyu Computer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TempBet.h"
#import <FacebookSDK/FacebookSDK.h>

@interface BetStakeConfirmVC : UIViewController <FBFriendPickerDelegate>

@property int stakeImageHeight;
@property (strong) TempBet *bet;
@property int currentStake;
@property (strong) UILabel *stakeLabel;
@property (strong) UILabel *verboseLabel;
@property (strong, nonatomic) FBFriendPickerViewController *fbFriendVC;

- (id)initWithBet:(TempBet *)betObj;
-(void)setBetStake:(id)sender;
-(void)increaseStake:(id)sender;
-(void)lowerStake:(id)sender;
-(void)updateLabels;

@end
