//
//  BetTrackingVC.h
//  betchyu
//
//  Created by Daniel Zapata on 12/19/13.
//  Copyright (c) 2013 BetchyuLLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TempBet.h"
#import "Graph.h"

@interface BetTrackingVC : UIViewController <UIAlertViewDelegate, GraphDelegate>

@property NSDictionary * betJSON;
@property TempBet * bet;
@property UILabel *updateText;
@property UILabel *boolGraphSub;
@property UISlider *slider;
@property NSDate *currentBooleanDate;
@property NSArray *previousUpdates;
@property BOOL isFinished;

@property (nonatomic, strong) Graph *hostView;

-(id) initWithJSON:(NSDictionary *)json;

@end
