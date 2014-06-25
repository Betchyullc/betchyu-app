//
//  UpdateView.h
//  betchyu
//
//  Created by Adam Baratz on 6/13/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressTrackingVC.h"
#import "AlertMaker.h"
#import "MyBetDetailsVC.h"

@interface UpdateView : UIView <UITextFieldDelegate, BinaryProgressViewDelegate>

@property NSDictionary * bet;
@property UITextField * box;
@property BOOL btnLocked;

- (id)initWithFrame:(CGRect)frame AndBet:(NSDictionary *)b;

- (void)textFieldDidBeginEditing:(UITextField *)textField;

@end
