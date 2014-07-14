//
//  CustomBetDefineView.h
//  betchyu
//
//  Created by Adam Baratz on 7/11/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BetOptionsVC.h"

@interface CustomBetDefineView : UIView <UITextFieldDelegate>

@property UILabel * detailLabel;
@property UILabel * durationLabel;
@property UISlider * dateSlider;

@property BOOL hasBeenCleared;

@property UITextField * verb;
@property UITextField * amount;
@property UITextField * noun;

@property BetOptionsVC * helper;

@end
