//
//  StakeDetailsView.m
//  betchyu
//
//  Created by Adam Baratz on 6/17/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import "StakeDetailsView.h"

@implementation StakeDetailsView

@synthesize stakeType;

- (id)initWithFrame:(CGRect)frame AndStakeType:(NSString *)type
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        stakeType = type;
        int h = frame.size.height;
        int w = frame.size.width;
        
        int headerHeight = 70;
        int headerCircleWidth = 50;
        int headerImgXoff = 9;
        int headerImgYoff = 12;
        
        
        // Header Label
        UIView *header          = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, headerHeight)];
        header.backgroundColor  = [UIColor whiteColor];
        
        UILabel *headerLbl      = [[UILabel alloc]initWithFrame:CGRectMake(70, 0, w- 90, headerHeight)];
        headerLbl.text          = [NSString stringWithFormat:@"I will bet each opponent a gift card to %@.", [[type componentsSeparatedByString:@" "] objectAtIndex:0]];
        headerLbl.textColor     = Borange;
        headerLbl.font          = [UIFont fontWithName:@"ProximaNova-Regular" size:17];
        headerLbl.lineBreakMode = NSLineBreakByWordWrapping;
        headerLbl.numberOfLines = 0;
        [header addSubview:headerLbl];
        
        UIView * headerCircle = [[UIView alloc]initWithFrame:CGRectMake(10, 8, headerCircleWidth, headerCircleWidth)];
        headerCircle.layer.borderColor = Borange.CGColor;
        headerCircle.layer.borderWidth = 2;
        headerCircle.layer.cornerRadius = headerCircleWidth/2;
        UIImageView *headerImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"card-09.png"]];
        headerImg.frame = CGRectMake(headerImgXoff, headerImgYoff, headerCircleWidth-2*headerImgXoff, headerCircleWidth - 2*headerImgYoff);
        [headerCircle addSubview:headerImg];
        [header addSubview:headerCircle];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, header.frame.size.height - 2, w, 2)];
        line.backgroundColor = Bmid;
        [header addSubview:line];
        
        // Main Big Image
        int mainImgYoff = header.frame.size.height + header.frame.origin.y + 10; // 10 for padding
        
        UIView *mainImgContainer = [[UIView alloc] initWithFrame:CGRectMake(w/3, mainImgYoff, w/3, w/3)];
        mainImgContainer.layer.cornerRadius = mainImgContainer.frame.size.width/2;
        mainImgContainer.layer.borderColor = Borange.CGColor;
        mainImgContainer.layer.borderWidth = 2;
        mainImgContainer.clipsToBounds = YES;
        mainImgContainer.layer.masksToBounds = YES;
        UIImageView * mainImgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",stakeType]]];
        mainImgImg.frame = CGRectMake(4, 4, w/3 - 8, w/3 - 8);
        [mainImgContainer addSubview:mainImgImg];
        
        // @"For the Amount of" Label
        // amountLabel
        // - button
        // + button
        // Intotal stake Label
        // Review Bet button
        
        
        // set up the self stuff
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:header];
        [self addSubview:mainImgContainer];
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
