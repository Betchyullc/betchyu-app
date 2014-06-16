//
//  BetOptionsTopView.m
//  betchyu
//
//  Created by Adam Baratz on 6/16/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import "BetOptionsTopView.h"

@implementation BetOptionsTopView

- (id)initWithFrame:(CGRect)frame AndBetName:(NSString *)name
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        int off = 64;
        
        // add the Background image
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", name]]];
        img.frame = CGRectMake(0, off, frame.size.width, frame.size.height);
        [self addSubview:img];
        
        // The text
        UILabel *bName  = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height-40 + off, frame.size.width, 30)];
        bName.textColor = [UIColor whiteColor];
        bName.text      = name;
        bName.font      = [UIFont fontWithName:@"ProximaNova-Bold" size:22.0];
        bName.textAlignment = NSTextAlignmentCenter;
        [self addSubview:bName];
        
        // Type Graphic
        // use a button to dispaly a pic for tint funcionality
        int dim = frame.size.width/3;
        CGRect picF = CGRectMake(frame.size.width/3, off + 15, dim, dim);
        UIColor * tintC = [UIColor whiteColor];
        UIImageView * pic = [[UIImageView alloc] initWithImage:[self getGraphicFromName:name]];
        // set the frame for said graphic button
        if ([[[[name componentsSeparatedByString:@" "] objectAtIndex:1] lowercaseString] isEqualToString:@"smoking"]) {
            pic.frame = CGRectMake(picF.origin.x+2, picF.origin.y+2, picF.size.width-4, picF.size.height-4);
        } else {
            pic.frame = CGRectMake(1+picF.origin.x + ((dim+10)/6), 1+picF.origin.y + ((dim+10)/6), 2*(dim-5)/3, 2*(dim-5)/3);
        }
        pic.image = [pic.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        pic.tintColor = tintC;          // makes said UIImage teh correct color
        CompletionBorderView *circle = [[CompletionBorderView alloc] initWithFrame:picF AndColor:tintC AndPercentComplete:100];
        circle.layer.cornerRadius = circle.frame.size.width/2;
        circle.lineWidth = 4;
        
        [self addSubview:pic];
        [self addSubview:circle];
        
    }
    return self;
}

- (UIImage *) getGraphicFromName:(NSString*)name {
    if ([name isEqualToString:@"Lose Weight"]) {
        return [UIImage imageNamed:@"scale-02.png"];
    }
    else if ([name isEqualToString:@"Stop Smoking"]){
        return [UIImage imageNamed:@"smoke-04.png"];
    }
    else if ([name isEqualToString:@"Workout More"]){
        return [UIImage imageNamed:@"workout-05.png"];
    }
    else if ([name isEqualToString:@"Run More"]){
        return [UIImage imageNamed:@"run-03.png"];
    } else {
        return [UIImage imageNamed:@"info_button.png"];
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
