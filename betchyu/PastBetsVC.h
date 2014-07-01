//  PastBetsVC.h
//  betchyu
//
//  Created by Daniel Zapata on 6/11/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.

#import <UIKit/UIKit.h>
#import "YourPastBetsView.h"
#import "FriendsPastBetsView.h"


@interface PastBetsVC : GAITrackedViewController

@property YourPastBetsView *yourView;
@property FriendsPastBetsView *friendsView;

@end
