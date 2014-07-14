//  BetOptionsVC.h
//  betchyu
//
//  Created by Daniel Zapata on 6/16/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.

#import <UIKit/UIKit.h>
#import "TempBet.h"
#import "BetOptionsTopView.h"
#import <FacebookSDK/FacebookSDK.h>
#import "BetStakeVC.h"
#import "TouchesBeganHelper.h"
#import "GAITrackedViewController.h"

@interface BetOptionsVC : GAITrackedViewController <FBFriendPickerDelegate, UISearchBarDelegate, UITextFieldDelegate>

@property TempBet * bet;
@property NSString * passedBetName;
@property UILabel * detailLabel1;
@property UILabel * detailLabel2;
@property UILabel * durationLabel;
@property FBFriendPickerViewController * fbFriendVC;
@property (retain, nonatomic) UISearchBar *searchBar;
@property (retain, nonatomic) NSString *searchText;
@property UITextField *initialInput;

- (id)initWithBetVerb:(NSString *)verbName;
-(void) setupDurationLabelFromFrame:(CGRect)frame AndFontSize:(int)fontSize;
-(UILabel *) getInLabelFromFrame:(CGRect)frame AndFontSize:(int)fontSize;
-(UISlider *) makeDateScrollerFromFrame:(CGRect)frame;
-(UIButton *)getChooseOpponentsButton:(CGRect)openCalendarFrame WithWidth:(int)w AndFontSize:(int)fontSize;
-(void) chooseOpponents:(id)sender;
-(void)addSearchBarToFriendPickerView;


@end
