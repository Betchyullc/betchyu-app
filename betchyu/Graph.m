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
@synthesize points;
@synthesize isWeightLoss;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        points = [NSMutableArray new];
        isWeightLoss = NO;
    }
    return self;
}

-(void)makeVisual {
    // clear all the subviews
    for (UIView* v in self.subviews){ [v removeFromSuperview]; }
    points = [NSMutableArray new];
    
    // useful variables
    int bf = 20;
    int h = self.frame.size.height - bf;
    int w = self.frame.size.width - bf;
    UIColor *orange =[UIColor colorWithRed:1.0 green:(117.0/255.0) blue:(63/255.0) alpha:1.0];
    
    /* Add axes */
    // x-axis
    UIView *bottomAxis = [[UIView alloc] initWithFrame:CGRectMake(bf/2, h - 3 + bf, w, 3)];
    bottomAxis.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomAxis];
    // X-axis label
    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(w - 40, h, 40 + bf, 20)];
    bottomLabel.text = @"Goal";
    bottomLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:18];
    bottomLabel.textColor = orange;
    bottomLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:bottomLabel];
    // y-axis
    UIView *leftAxis = [[UIView alloc] initWithFrame:CGRectMake(bf/2, bf, 3, h)];
    leftAxis.backgroundColor = [UIColor whiteColor];
    [self addSubview:leftAxis];
    // Y-axis label
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    topLabel.text = @"Start";
    topLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:18];
    topLabel.textColor = orange;
    topLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:topLabel];
    
    // check for delegate
    if (!self.delegate) { return; }
    
    self.vals = [self.delegate valsArr];
    int max = [self.delegate max];
    int min = [self.delegate min];
    int unit = h / (max - min);
    int wUnit = w / [self.delegate numberOfDaysTheBetLasts];
    
    // plot points
    for (int i = 0; i < self.vals.count; i++){
        NSDictionary *obj = [self.vals objectAtIndex:i];
        int yCoord = [[obj valueForKey:@"value"] integerValue] - min;
        if (self.isWeightLoss) { yCoord = max - [[obj valueForKey:@"value"] integerValue]; }
        int xCoord = [self.delegate xCoordForIndex:i];
        UIView *point = [[UIView alloc] initWithFrame:CGRectMake(wUnit * xCoord + bf, yCoord * unit + bf, 6, 6)];
        point.backgroundColor = orange;
        point.layer.cornerRadius = 3.0;
        [self addSubview:point];
        [points addObject:point];
    }
    
    /* plot tick marks */
    // x-axis
    for (int i = 0; i < [self.delegate numberOfDaysTheBetLasts]; i++) {
        UIView *tick = [[UIView alloc] initWithFrame:CGRectMake(bf + i * wUnit - 2, bf + h - 6, 2, 6)];
        tick.backgroundColor = [UIColor whiteColor];
        [self addSubview:tick];
    }
    
    [self setNeedsDisplay];  // force re-draw in drawRect (for the lines connecting the points)
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    int bf = 20;
    // setup drawing variables
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect bounds = self.bounds;
    
    // draw the clear background
    CGContextSetRGBStrokeColor(ctx, (39/255.0), (37/255.0), (37/255.0), 1.0);
    CGContextSetRGBFillColor(ctx, (39/255.0), (37/255.0), (37/255.0), 1.0);
    CGContextFillRect(ctx, bounds);
    
    // draw the projection line
    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 0.5);
    CGContextSetLineWidth(ctx, 2);
    float blah[] = {30, 30};
    CGContextSetLineDash(ctx, 0.6, blah, 2);
    if (self.isWeightLoss && self.delegate) {
        int h = bounds.size.height;
        int max = [self.delegate max];
        int min = [self.delegate min];
        int unit = h / (max - min);
        CGContextMoveToPoint(ctx, rect.origin.x + bf/2, rect.origin.y + bf + (unit*3));
        CGContextAddLineToPoint(ctx, bounds.size.width - bf/2, bounds.size.height - (unit*3));
    } else {
        CGContextMoveToPoint(ctx, rect.origin.x + bf/2, rect.origin.y + bf);
        CGContextAddLineToPoint(ctx, bounds.size.width - bf/2, bounds.size.height);
    }
    // DO IT!!!
    CGContextStrokePath(ctx);
    
    // draw the connectors line
    if (self.delegate) {
        // setup the line's color and staring location
        CGContextSetRGBStrokeColor(ctx, 1.0, (117.0/255.0), (63/255.0), 1.0);
        CGContextSetLineDash(ctx, 1.0, NULL, 0);
        if (self.isWeightLoss && self.delegate) {
            int h = bounds.size.height;
            int max = [self.delegate max];
            int min = [self.delegate min];
            int unit = h / (max - min);
            CGContextMoveToPoint(ctx, bf/2, bf + (unit*3));
        } else {
            CGContextMoveToPoint(ctx, bf/2, bf);
        }
        
        for (UIView *point in self.points) {
            CGContextAddLineToPoint(ctx, point.frame.origin.x +3, point.frame.origin.y +3);
        }
        
        // DO IT!!!
        CGContextStrokePath(ctx);
    }
}


@end
