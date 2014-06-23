//  HeadingBarView.m
//  betchyu
//
//  Created by Daniel Zapata on 6/12/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.

#import "HeadingBarView.h"

@implementation HeadingBarView

- (id)initWithFrame:(CGRect)frame AndTitle:(NSString *)str
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIColor *dark  = [UIColor colorWithRed:71.0/255 green:71.0/255 blue:82.0/255 alpha:1.0];
        int fontSize = frame.size.width > 500 ? 20 : 14;
        
        // Title bar
        [self setBackgroundColor:dark];
        //Adds a shadow to heading
        self.layer.shadowOffset = CGSizeMake(0, 5);
        self.layer.shadowColor = [dark CGColor];
        self.layer.shadowRadius = 2.5f;
        self.layer.shadowOpacity = 0.60f;
        self.layer.shadowPath = [[UIBezierPath bezierPathWithRect:self.layer.bounds] CGPath];
        // Adds text to the heading
        UILabel *title  = [[UILabel alloc]initWithFrame:CGRectMake(10, 3, frame.size.width - 20, fontSize*1.5)];
        title.text = str;
        title.font = [UIFont fontWithName:@"ProximaNova-Bold" size:fontSize];
        title.textColor = [UIColor whiteColor];
        title.textAlignment = NSTextAlignmentLeft;
        [self addSubview:title];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
