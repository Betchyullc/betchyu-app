//
//  MyBetDetailsVC.m
//  betchyu
//
//  Created by Adam Baratz on 6/13/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import "MyBetDetailsVC.h"

@interface MyBetDetailsVC ()

@end

@implementation MyBetDetailsVC

@synthesize betJSON;

- (id)initWithJSONBet:(NSDictionary *)bet
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        self.betJSON = bet;
    }
    return self;
}

- (void)loadView {
    self.view = [[BetDetailsView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame AndBet:betJSON AndIsMyBet:YES];
}

@end
