//
//  BetTrackingVC.h
//  betchyu
//
//  Created by Adam Baratz on 12/19/13.
//  Copyright (c) 2013 BetchyuLLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TempBet.h"
#import "CorePlot-CocoaTouch.h"

@interface BetTrackingVC : UIViewController <CPTPlotDataSource>

@property NSDictionary * betJSON;
@property TempBet * bet;
@property UILabel *updateText;
@property UISlider *slider;
@property NSDate *currentBooleanDate;
@property NSArray *previousUpdates;

@property (nonatomic, strong) CPTGraphHostingView *hostView;

-(id) initWithJSON:(NSDictionary *)json;

@end
