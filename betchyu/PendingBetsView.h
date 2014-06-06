//
//  PendingBetsView.h
//  betchyu
//
//  Created by Adam Baratz on 6/3/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
//@class DashboardVC;

@interface PendingBetsView : UIView

//@property DashboardVC * controller;

-(id) initWithFrame:(CGRect)frame;// AndController:(DashboardVC *)cont;
-(void) addBets:(NSArray *)pending;

@end
