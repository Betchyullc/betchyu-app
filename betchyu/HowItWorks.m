//
//  HowItWorks.m
//  betchyu
//
//  Created by Adam Baratz on 12/22/13.
//  Copyright (c) 2013 BetchyuLLC. All rights reserved.
//

#import "HowItWorks.h"

@implementation HowItWorks

@synthesize owner;

- (id)initWithFrame:(CGRect)frame AndOwner:(UIViewController *)passedOwner {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.owner = passedOwner;
        
        UIView *lineView;  //used for drawing lines
        
        self.backgroundColor = [UIColor colorWithRed:(69/255.0) green:(69/255.0) blue:(69/255.0) alpha:1.0];
        
        /////////////////////
        // The back button
        /////////////////////
        // actual buttom
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(25, 40, 80, 30)];
        [backBtn setTitle:@"< Menu" forState:UIControlStateNormal];
        backBtn.font = [UIFont fontWithName:@"ProximaNova-Regular" size:22];
        [backBtn addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        // it's line
        lineView = [[UIView alloc] initWithFrame:CGRectMake(29, 80, frame.size.width, 2)];
        lineView.backgroundColor = [UIColor whiteColor];
        // add to the view
        [self addSubview:backBtn];
        [self addSubview:lineView];
        
        //////////////////
        // The Logo image
        ///////////////////
        // actual imageView
        UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"howItWorksLogo.png"]];
        int wide = frame.size.width * 0.8;
        logo.frame = CGRectMake((frame.size.width-wide)/2, 100, wide, (103.0/381)*wide);
        // it's line
        lineView = [[UIView alloc] initWithFrame:CGRectMake(29, 125 + ((103.0/381)*wide), frame.size.width, 2)];
        lineView.backgroundColor = [UIColor whiteColor];
        //add to the view
        [self addSubview:logo];
        [self addSubview:lineView];
        
        ////////////////////
        // The copy Text
        ////////////////////
        // ui label containing said text
        UILabel *copy;
        if (frame.size.height > 500) {
            copy = [[UILabel alloc] initWithFrame:CGRectMake(30, 140, frame.size.width-60, 3*frame.size.height/4)];
            copy.font = [UIFont fontWithName:@"ProximaNova-Regular" size:15];
        } else {
            copy = [[UILabel alloc] initWithFrame:CGRectMake(30, 150, frame.size.width-60, frame.size.height-140)];
            copy.font = [UIFont fontWithName:@"ProximaNova-Regular" size:13];
        }
        copy.text = @"To help people achieve their goals, we have found a way to leverage accountability to one's friends, relatives and acquaintances, as well as the natural desire to prove doubters wrong, and the motivation sparked by the chance to win money or prizes. Because of the unprecedented ease and frequency with which social networks are now connected, the Betchyu app is able to tap into the goodwill of those in our lives, drawing upon reserves of support available to every individual.";
        copy.numberOfLines = 0;
        copy.textAlignment = NSTextAlignmentLeft;
        copy.textColor = [UIColor whiteColor];
        [self addSubview:copy];
        
    }
    return self;
}

-(void)backBtnPressed:(id)sender {
    [owner.navigationController popViewControllerAnimated:YES];
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
