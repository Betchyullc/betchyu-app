//
//  Graph.h
//  betchyu
//
//  Created by Adam Baratz on 1/28/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Graph;
@protocol GraphDelegate

- (NSArray *) valsArr;
- (int) max;
- (int) min;

@end

@interface Graph : UIView

@property (nonatomic, weak) id <GraphDelegate> delegate;
@property NSArray *vals;

@end
