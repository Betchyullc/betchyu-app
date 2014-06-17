//
//  BetOptionsTopView.m
//  betchyu
//
//  Created by Daniel Zapata on 6/16/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import "BetOptionsTopView.h"

@implementation BetOptionsTopView

@synthesize textLabel;

- (id)initWithFrame:(CGRect)frame AndBetName:(NSString *)name
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        int off = 64;
        name = [self getBetName:name];
        
        // add the Background image
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", name]]];
        img.frame = CGRectMake(0, off, frame.size.width, frame.size.height);
        [self addSubview:img];
        
        // The text
        self.textLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height-40 + off, frame.size.width, 30)];
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.text      = name;
        self.textLabel.font      = [UIFont fontWithName:@"ProximaNova-Bold" size:22.0];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.textLabel];
        
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
    name = [name lowercaseString];
    if ([name hasPrefix:@"lose"]) {
        return [UIImage imageNamed:@"scale-02.png"];
    }
    else if ([name hasPrefix:@"stop"]){
        return [UIImage imageNamed:@"smoke-04.png"];
    }
    else if ([name hasPrefix:@"workout"]){
        return [UIImage imageNamed:@"workout-05.png"];
    }
    else if ([name hasPrefix:@"run"]){
        return [UIImage imageNamed:@"run-03.png"];
    } else {
        NSLog(@"uh oh");
        return [UIImage imageNamed:@"info_button.png"];
    }
}

- (NSString *) getBetName:(NSString*)name {
    name = [name lowercaseString];
    if ([name hasPrefix:@"lose"]) {
        return @"Lose Weight";
    }
    else if ([name hasPrefix:@"stop"]){
        return @"Stop Smoking";
    }
    else if ([name hasPrefix:@"workout"]){
        return @"Workout More";
    }
    else if ([name hasPrefix:@"run"]){
        return @"Run More";
    } else {
        NSLog(@"uh oh");
        return @"Uh Oh";
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
