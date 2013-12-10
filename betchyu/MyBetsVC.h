//
//  MyBetsVC.h
//  betchyu
//
//  Created by Adam Baratz on 12/9/13.
//  Copyright (c) 2013 BetchyuLLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyBetsVC : UIViewController

@property  NSArray * ongoingBets;   // represents all the bet from friends that you have accepted
@property  NSArray * openBets;      // represents all the bets for which You have an open invite
@property  NSArray * openInvites;   // all of the still-valid invites people have sent you

@end
