//  FlyoutMenuVC.h
//  betchyu
//
//  Created by Daniel Zapata on 12/21/13.
//  Copyright (c) 2013 BetchyuLLC. All rights reserved.

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "FlyoutTopView.h"

@interface FlyoutMenuVC : UIViewController <UIPageViewControllerDataSource, MTStackViewControllerDelegate>

@property CGRect passedFrame;
@property FlyoutTopView *top;
@property UIButton * editBtn;
@property UIButton *dashBtn;
@property UILabel * dashText;
@property UIImageView * dashImg;
@property UIButton *pastBtn;
@property UILabel * pastText1;
@property UIImageView * pastImg1;
@property UIButton *friendsBtn;
@property UILabel * friendsText;
@property UIImageView * friendsImg;
@property UIButton *setBtn;
@property UILabel * setText;
@property UIImageView * setImg;
@property int last;

-(id)initWithFrame:(CGRect)frame;

@end
