//
//  ProgressBarView.m
//  betchyu
//
//  Created by Daniel Zapata on 6/12/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import "ProgressBarView.h"

@implementation ProgressBarView

@synthesize progress;
@synthesize color;

- (id)initWithFrame:(CGRect)frame AndColor:(UIColor *)c AndPercentComplete:(int)per
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIColor *mid = [UIColor colorWithRed:186.0/255 green:186.0/255 blue:194.0/255 alpha:1.0];
        self.layer.borderColor = [mid CGColor];
        self.layer.borderWidth = 2;
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 2;
        
        self.progress = per;
        self.color = c;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing Rect
    [self.color setFill];
    UIRectFill(CGRectMake(2, 0, self.frame.size.width*self.progress / 100, self.frame.size.height));
}


@end
