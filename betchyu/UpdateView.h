//
//  UpdateView.h
//  betchyu
//
//  Created by Adam Baratz on 6/13/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressTrackingVC.h"

#define Borange [UIColor colorWithRed:243.0/255 green:(116.0/255.0) blue:(67/255.0) alpha:1.0]
#define Bgreen  [UIColor colorWithRed:173.0/255 green:196.0/255 blue:81.0/255 alpha:1.0]
#define Bred    [UIColor colorWithRed:219.0/255 green:70.0/255 blue:38.0/255 alpha:1.0]
#define Bblue   [UIColor colorWithRed:83.0/255 green:188.0/255 blue:183.0/255 alpha:1.0]
#define Bdark   [UIColor colorWithRed:71.0/255 green:71.0/255 blue:82.0/255 alpha:1.0]
#define Blight  [UIColor colorWithRed:213.0/255 green:213.0/255 blue:214.0/255 alpha:1.0]
#define Bmid    [UIColor colorWithRed:186.0/255 green:186.0/255 blue:194.0/255 alpha:1.0]

@interface UpdateView : UIView <UITextFieldDelegate, BinaryProgressViewDelegate>

@property NSDictionary * bet;
@property UITextField * box;

- (id)initWithFrame:(CGRect)frame AndBet:(NSDictionary *)b;

- (void)textFieldDidBeginEditing:(UITextField *)textField;

@end
