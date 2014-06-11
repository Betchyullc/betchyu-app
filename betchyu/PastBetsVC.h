//
//  PastBetsVC.h
//  betchyu
//
//  Created by Adam Baratz on 6/11/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YourPastBetsView.h"
#import "FriendsPastBetsView.h"


@interface PastBetsVC : UIViewController

@property YourPastBetsView *yourView;
@property FriendsPastBetsView *friendsView;

@end
