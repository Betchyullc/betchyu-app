//  SummaryStakeView.m
//  betchyu
//
//  Created by Daniel Zapata on 6/18/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.

#import "SummaryStakeView.h"

@implementation SummaryStakeView

- (id)initWithFrame:(CGRect)frame AndBet:(TempBet *)bet {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        int w = frame.size.width;
        int fontSize = 18;
        
        UILabel *title      = [[UILabel alloc] initWithFrame:CGRectMake(0, 7, w, fontSize + 6)];
        title.text          = @"The stake is:";
        title.font          = FregfS;
        title.textColor     = Bmid;
        title.textAlignment = NSTextAlignmentCenter;
        
        // Picture of stake
        int iDim = w/4.5;
        int imgYoff = 5 + title.frame.size.height + title.frame.origin.y;
        UIView *imgContainer = [[UIView alloc] initWithFrame:CGRectMake((w-iDim)/2, imgYoff, iDim, iDim)];
        imgContainer.layer.cornerRadius = imgContainer.frame.size.width/2;
        imgContainer.layer.borderColor = Borange.CGColor;
        imgContainer.layer.borderWidth = 3;
        imgContainer.clipsToBounds = YES;
        imgContainer.layer.masksToBounds = YES;
        UIImageView * mainImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", bet.stakeType]]];
        mainImg.frame = CGRectMake(4, 4, iDim - 8, iDim - 8);
        [imgContainer addSubview:mainImg];
        
        // Label describing individual stake
        int yOff = 5 + imgContainer.frame.size.height + imgContainer.frame.origin.y;
        UILabel *indStake       = [[UILabel alloc] initWithFrame:CGRectMake(0, yOff, w, fontSize + 6)];
        indStake.textAlignment  = NSTextAlignmentCenter;
        indStake.text           = [NSString stringWithFormat:@"A $%@ %@.", bet.stakeAmount, bet.stakeType];
        indStake.font           = FboldfS;
        indStake.textColor      = Borange;
        
        // Label describing total at-risk money
        yOff = 5 + indStake.frame.size.height + indStake.frame.origin.y;
        UILabel *totStake       = [[UILabel alloc] initWithFrame:CGRectMake(0, yOff, w, fontSize + 6)];
        totStake.textAlignment  = NSTextAlignmentCenter;
        totStake.text           = [NSString stringWithFormat:@"There is $%i at stake.", ([bet.stakeAmount integerValue] * bet.friends.count)];
        totStake.font           = FboldfS;
        totStake.textColor      = Borange;
        
        [self addSubview:title];
        [self addSubview:imgContainer];
        [self addSubview:indStake];
        [self addSubview:totStake];
    }
    return self;
}

@end
