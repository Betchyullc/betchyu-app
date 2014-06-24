//  AlertMaker.h
//  betchyu
//
//  Created by Daniel Zapata on 6/24/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.

#import <Foundation/Foundation.h>

@interface AlertMaker : NSObject

+(AlertMaker *)sharedInstance;


-(void) showGoalUpdatedAlert;

@end
