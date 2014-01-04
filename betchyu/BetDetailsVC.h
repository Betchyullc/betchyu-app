//
//  BetDetailsVC.h
//  iBetchyu
//
//  Created by Betchyu Computer on 11/20/13.
//  Copyright (c) 2013 Betchyu Computer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TempBet.h"

@interface BetDetailsVC : UIViewController <UITextFieldDelegate>

@property (strong) TempBet *bet;
@property (strong) UILabel *detailLabel1;
@property (strong) UILabel *detailLabel2;
@property UITextField *weightInput;
@property UIColor *betchyuOrange;

- (id)initWithBetVerb:(NSString *)verbName;
- (void)updateSlider1Value:(id)sender;
- (void)updateSlider2Value:(id)sender;
-(void)setBetStake:(id)sender;

@end
