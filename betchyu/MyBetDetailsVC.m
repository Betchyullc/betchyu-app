//  MyBetDetailsVC.m
//  betchyu
//
//  Created by Daniel Zapata on 6/13/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.

#import "MyBetDetailsVC.h"

@implementation MyBetDetailsVC

@synthesize betJSON;

- (id)initWithJSONBet:(NSDictionary *)bet
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        self.betJSON = bet;
        self.screenName = @"My Bet Details (Update)";
    }
    return self;
}

- (void)loadView {
    self.view = [[BetDetailsView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame AndBet:betJSON AndIsMyBet:YES];
}

@end
