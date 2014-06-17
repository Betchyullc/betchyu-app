//
//  StakeDetailsVC.m
//  betchyu
//
//  Created by Adam Baratz on 6/17/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import "StakeDetailsVC.h"

@interface StakeDetailsVC ()

@end

@implementation StakeDetailsVC

@synthesize bet;

- (id)initWithBet:(TempBet *)betObj
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        bet = betObj;
    }
    return self;
}

- (void)loadView {
    CGRect f = [UIScreen mainScreen].applicationFrame;
    int h = f.size.height - 40;
    int w = f.size.width;
    // load static stuff via the StakeDetailsView
    StakeDetailsView *staticStuff = [[StakeDetailsView alloc] initWithFrame:CGRectMake(0, 0, w, h) AndStakeType:bet.stakeType];
    
    self.view = staticStuff;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
