//  DashHeaderView.h
//  betchyu
//
//  Created by Daniel Zapata on 6/2/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "EditProfileVC.h"

@interface DashHeaderView : UIView

@property FBProfilePictureView * profPic;

- (void) setUpProfilePic:(BOOL)notCalled;

@end
