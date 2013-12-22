//
//  ExistingBetDetailsVC.h
//  betchyu
//
//  Created by Adam Baratz on 12/16/13.
//  Copyright (c) 2013 BetchyuLLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TempBet.h"

@interface ExistingBetDetailsVC : UIViewController

@property NSDictionary * betJSON;
@property TempBet * bet;

-(id) initWithJSON:(NSDictionary *)json;

@end
