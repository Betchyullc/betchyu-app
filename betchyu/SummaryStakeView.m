//  SummaryStakeView.m
//  betchyu
//
//  Created by Daniel Zapata on 6/18/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.

#import "SummaryStakeView.h"

@implementation SummaryStakeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        int w = frame.size.width;
        int fontSize = 18;
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, w, fontSize + 6)];
        title.text = @"The stake is:";
        title.font = FregfS;
        title.textColor = Bmid;
        
        [self addSubview:title];
    }
    return self;
}

@end
