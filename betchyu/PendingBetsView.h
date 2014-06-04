//
//  PendingBetsView.h
//  betchyu
//
//  Created by Adam Baratz on 6/3/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface PendingBetsView : UIView

-(id) initWithFrame:(CGRect)frame //AndPendingBets:(NSArray*)pending;
-(void) addBets:(NSArray *)pending;

@end
