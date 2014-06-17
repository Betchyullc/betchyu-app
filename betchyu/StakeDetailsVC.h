//
//  StakeDetailsVC.h
//  betchyu
//
//  Created by Adam Baratz on 6/17/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StakeDetailsView.h"

@interface StakeDetailsVC : UIViewController

@property (strong) TempBet *bet;

- (id)initWithBet:(TempBet *)betObj;

@end
