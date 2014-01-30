//
//  Graph.m
//  betchyu
//
//  Created by Adam Baratz on 1/28/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import "Graph.h"

@implementation Graph

@synthesize vals;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)makeVisual {
    // clear all the subviews
    for (UIView* v in self.subviews){ [v removeFromSuperview]; }
    
    // useful variables
    int h = self.frame.size.height;
    int w = self.frame.size.width;
    UIColor *orange =[UIColor colorWithRed:1.0 green:(117.0/255.0) blue:(63/255.0) alpha:1.0];
    
    /* Add axes */
    // x-axis
    UIView *bottomAxis = [[UIView alloc] initWithFrame:CGRectMake(0, h - 3, w, 3)];
    bottomAxis.backgroundColor = orange;
    [self addSubview:bottomAxis];
    // y-axis
    UIView *leftAxis = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, h)];
    leftAxis.backgroundColor = orange;
    [self addSubview:leftAxis];
    
    // check for delegate
    if (!self.delegate) { return; }
    
    self.vals = [self.delegate valsArr];
    int max = [self.delegate max];
    int min = [self.delegate min];
    int unit = h / (max - min);
    int wUnit = w/self.vals.count;
    
    // plot points
    for (int i = 0; i < self.vals.count; i++){
        NSDictionary *obj = [self.vals objectAtIndex:i];
        int yCoord = [[obj valueForKey:@"value"] integerValue] - min;
        UIView *point = [[UIView alloc] initWithFrame:CGRectMake(wUnit*i, yCoord * unit, 4, 4)];
        point.backgroundColor = orange;
        point.layer.cornerRadius = 2.0;
        [self addSubview:point];
    }
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
