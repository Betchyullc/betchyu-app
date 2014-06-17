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
#import "DDCalendarView.h"
#import <FacebookSDK/FacebookSDK.h>
#import "BetStakeVC.h"


@interface BetOptionsVC : UIViewController <FBFriendPickerDelegate, UISearchBarDelegate, UIAlertViewDelegate, UITextFieldDelegate>

@property TempBet * bet;
@property NSString * passedBetName;
@property UILabel * detailLabel1;
@property UILabel * detailLabel2;
@property FBFriendPickerViewController * fbFriendVC;
@property (retain, nonatomic) UISearchBar *searchBar;
@property (retain, nonatomic) NSString *searchText;
@property UITextField *initialInput;

- (id)initWithBetVerb:(NSString *)verbName;

@end
