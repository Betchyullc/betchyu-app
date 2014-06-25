//
//  SettingsView.m
//  betchyu
//
//  Created by Daniel Zapata on 6/11/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import "SettingsView.h"

@implementation SettingsView


// This file just puts the visible parts of the settings page on screen--it does NOT handle buttons
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = Blight;
        int rH = 43;
        int yOff = 64;
        int fontSize = 19;
        
        // Top Two Buttons are pure white background and shadowlined
        // Profile Information 'Button'
        UILabel *profInfo = [[UILabel alloc]initWithFrame:CGRectMake(0, yOff, frame.size.width, rH)];
        profInfo.text = @"\tProfile Information";
        profInfo.font = FregfS;
        profInfo.textColor = Bdark;
        profInfo.backgroundColor = [UIColor whiteColor];
        [self addSubview:profInfo];
        UILabel * a1 = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width - 40, yOff, frame.size.width, rH)];
        a1.text      = [NSString stringWithUTF8String:"❯"];
        a1.textColor = Bdark;
        a1.font      = FregfS;
        [self addSubview:a1];
        
        // Second button
        yOff = yOff + rH;
        UILabel *payInfo = [[UILabel alloc]initWithFrame:CGRectMake(0, yOff, frame.size.width, rH)];
        payInfo.text = @"\tPayment Information";
        payInfo.font = FregfS;
        payInfo.textColor = Bdark;
        payInfo.backgroundColor = [UIColor whiteColor];
        //Adds a shadow to payInfo button
        payInfo.layer.shadowOffset = CGSizeMake(0, 5);
        payInfo.layer.shadowColor = [Bdark CGColor];
        payInfo.layer.shadowRadius = 2.5f;
        payInfo.layer.shadowOpacity = 0.50f;
        payInfo.layer.shadowPath = [[UIBezierPath bezierPathWithRect:payInfo.layer.bounds] CGPath];
        payInfo.layer.masksToBounds = NO;
        [self addSubview:payInfo];
        // the arrow
        UILabel * a2 = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width - 40, yOff, frame.size.width, rH)];
        a2.text      = [NSString stringWithUTF8String:"❯"];
        a2.textColor = Bdark;
        a2.font      = FregfS;
        [self addSubview:a2];
        
        // Bottom three buttons are normal
        // How It works button
        yOff = yOff + rH;
        UILabel *how = [[UILabel alloc]initWithFrame:CGRectMake(0, yOff, frame.size.width, rH)];
        how.text = @"\tHow It Works";
        how.font = FregfS;
        how.textColor = Bdark;
        [self addSubview:how];
        // the arrow
        UILabel * a3 = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width - 40, yOff, frame.size.width, rH)];
        a3.text      = [NSString stringWithUTF8String:"❯"];
        a3.textColor = Bdark;
        a3.font      = FregfS;
        [self addSubview:a3];
        // Feedback Button
        yOff = yOff + rH;
        UILabel *feed = [[UILabel alloc]initWithFrame:CGRectMake(0, yOff, frame.size.width, rH)];
        feed.text = @"\tFeedback";
        feed.font = FregfS;
        feed.textColor = Bdark;
        [self addSubview:feed];
        // the arrow
        UILabel * a4 = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width - 40, yOff, frame.size.width, rH)];
        a4.text      = [NSString stringWithUTF8String:"❯"];
        a4.textColor = Bdark;
        a4.font      = FregfS;
        [self addSubview:a4];
        // About Us button
        yOff = yOff + rH;
        UILabel *us = [[UILabel alloc]initWithFrame:CGRectMake(0, yOff, frame.size.width, rH)];
        us.text = @"\tAbout Us";
        us.font = FregfS;
        us.textColor = Bdark;
        [self addSubview:us];
        // the arrow
        UILabel * a5 = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width - 40, yOff, frame.size.width, rH)];
        a5.text      = [NSString stringWithUTF8String:"❯"];
        a5.textColor = Bdark;
        a5.font      = FregfS;
        [self addSubview:a5];

    }
    return self;
}

@end
