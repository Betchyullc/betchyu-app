//  SummaryHeaderView.m
//  betchyu
//
//  Created by Daniel Zapata on 6/18/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.

#import "SummaryHeaderView.h"

@implementation SummaryHeaderView

- (id)initWithFrame:(CGRect)frame AndBet:(TempBet *)bet {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        int w = frame.size.width;
        int h = frame.size.height;
        
        // Make the graphic of the bet-type
        int graphicContainerWidth   = w/4;
        UIView *graphicContainer    = [[UIView alloc]initWithFrame:CGRectMake((w-(graphicContainerWidth))/2, 15, graphicContainerWidth, graphicContainerWidth)];
        graphicContainer.layer.cornerRadius = graphicContainerWidth/2;
        graphicContainer.layer.borderColor  = Borange.CGColor;
        graphicContainer.layer.borderWidth  = 2;
        UIImageView *graphic= [[UIImageView alloc]initWithImage:[self getGraphicFromVerb:bet.verb]];
        int gXoff           = graphicContainerWidth/6;
        int gYoff           = graphicContainerWidth/4;
        graphic.frame       = CGRectMake(gXoff, gYoff, graphicContainerWidth - 2*gXoff, graphicContainerWidth - 2*gYoff);
        if ([[bet.verb lowercaseString] isEqualToString:@"smoking"]) {
            graphic.frame   = CGRectMake(2, 2, graphicContainerWidth - 4, graphicContainerWidth - 4);
        }
        [graphicContainer addSubview:graphic];
        
        // Make the wordy bet description
        int descFontSize = 18;
        UILabel *desc       = [[UILabel alloc]initWithFrame:CGRectMake(0, 15 + graphicContainerWidth + 15, w, descFontSize + 8)];
        desc.text           = [self getDescriptionFromBet:bet];
        desc.textAlignment  = NSTextAlignmentCenter;
        desc.font           = [UIFont fontWithName:@"ProximaNova-Regular" size:descFontSize];
        desc.textColor      = Borange;
        
        // Make the line inicating the end of this view
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15, h-2, w-30, 2)];
        line.backgroundColor = Bmid;
        
        [self addSubview:graphicContainer];
        [self addSubview:desc];
        [self addSubview:line];
    }
    return self;
}

- (UIImage *) getGraphicFromVerb:(NSString*)name {
    name = [name lowercaseString];
    if ([name isEqualToString:@"lose"]) {
        return [UIImage imageNamed:@"scale-02.png"];
    }
    else if ([name isEqualToString:@"stop"]){
        return [UIImage imageNamed:@"smoke-04.png"];
    }
    else if ([name isEqualToString:@"workout"]){
        return [UIImage imageNamed:@"workout-05.png"];
    }
    else if ([name isEqualToString:@"run"]){
        return [UIImage imageNamed:@"run-03.png"];
    } else {
        NSLog(@"uh oh");
        return [UIImage imageNamed:@"info_button.png"];
    }
}

-(NSString*) getDescriptionFromBet:(TempBet*)bet {
    if ([[bet.noun lowercaseString] isEqualToString:@"smoking"]) {
        return [NSString stringWithFormat:@"%@ %@ for %@ days", bet.verb, bet.noun, bet.duration];
    }
    
    return [NSString stringWithFormat:@"%@ %@ %@ in %@ days", bet.verb, bet.amount, bet.noun, bet.duration];
}

@end
