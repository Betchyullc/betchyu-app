//
//  CardInfoView.h
//  betchyu
//
//  Created by Adam Baratz on 7/9/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardInfoView : UIView <UITextFieldDelegate>

@property UITextField *cardNum;
@property UITextField *cvv;
@property UITextField *month;
@property UITextField *year;

@property BOOL hasBeenCleared;

@end
