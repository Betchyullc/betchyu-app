//
//  BetOptionsVC.h
//  betchyu
//
//  Created by Adam Baratz on 6/16/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TempBet.h"
#import "BetOptionsTopView.h"
#import <FacebookSDK/FacebookSDK.h>
#import "BetStakeVC.h"
#import "TouchesBeganHelper.h"


@interface BetOptionsVC : UIViewController <FBFriendPickerDelegate, UISearchBarDelegate, UITextFieldDelegate>

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

@end
