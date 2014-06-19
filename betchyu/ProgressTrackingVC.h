//
//  ProgressTrackingVC.h
//  betchyu
//
//  Created by Adam Baratz on 6/13/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BinaryProgressView.h"

@interface ProgressTrackingVC : UIViewController <BinaryProgressViewDelegate>

@property NSDictionary * bet;
@property BinaryProgressView *prog;

- (id)initWithBet:(NSDictionary *)betObj;
- (void)updated:(NSDictionary *)params;

@end
