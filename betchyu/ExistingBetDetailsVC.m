//  ExistingBetDetailsVC.m
//  betchyu
//
//  Created by Daniel Zapata on 12/16/13.
//  Copyright (c) 2013 BetchyuLLC. All rights reserved.

#import "ExistingBetDetailsVC.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import "API.h"
#import "BetDetailsView.h"

@interface ExistingBetDetailsVC ()

@end

@implementation ExistingBetDetailsVC

@synthesize betJSON;
@synthesize isOffer;
@synthesize isOwn;

// ===== Initializers ===== //
- (id)initWithJSON:(NSDictionary *)json {
    self = [super init];
    if (self) {
        // Custom initialization
        
        self.betJSON    = json;
        
        self.isOffer = NO;
        self.isOwn   = NO;
        self.screenName = @"Bet Details (Friend's Bet)";
    }
    return self;
}
- (id)initWithJSON:(NSDictionary *)json AndOfferBool:(BOOL)passedOffer{
    self = [self initWithJSON:json];
    self.isOffer = passedOffer;
    return self;
}

- (void)loadView {
    self.view = [[BetDetailsView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame AndBet:betJSON AndIsMyBet:NO AndIsOffer:self.isOffer];
}

@end
