//
//  CompletionBorderView.m
//  betchyu
//
//  Created by Adam Baratz on 6/10/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import "CompletionBorderView.h"
#define   DEGREES_TO_RADIANS(degrees)  ((3.14159265359 * degrees)/ 180)
#define   PERCENT_2_DEGREES(deg)       (360*deg/100)

@implementation CompletionBorderView

@synthesize color;
@synthesize percent;

- (id)initWithFrame:(CGRect)frame AndColor:(UIColor *)c AndPercentComplete:(int)per
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.color = c;
        self.percent = per;
        
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    }
    return self;
}


 // Draws the colored part of the Circle
 - (void)drawRect:(CGRect)rect {
     int halfH = self.frame.size.height/2;
     UIColor *light = [UIColor colorWithRed:213.0/255 green:213.0/255 blue:214.0/255 alpha:1.0];
     
     // grey under-line
     UIBezierPath *aPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(halfH, halfH)
                                                          radius:halfH-2
                                                      startAngle:DEGREES_TO_RADIANS(0)
                                                        endAngle:DEGREES_TO_RADIANS(360)
                                                       clockwise:YES];
     aPath.lineWidth = 2;
     [light setStroke];
     [aPath stroke];
     
     // colored over-line that indicates percent completion
     UIBezierPath *bPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(halfH, halfH)
                                                          radius:halfH-2
                                                      startAngle:DEGREES_TO_RADIANS(-135)
                                                        endAngle:DEGREES_TO_RADIANS((PERCENT_2_DEGREES(self.percent)-135))
                                                       clockwise:YES];
     bPath.lineWidth = 2;
     [self.color setStroke];
     [bPath stroke];
 }


@end
