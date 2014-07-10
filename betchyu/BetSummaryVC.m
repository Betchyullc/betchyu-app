//  BetSummaryVC.m
//  betchyu
//
//  Created by Daniel Zapata on 5/7/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.

#import "BetSummaryVC.h"
#import "AppDelegate.h"
#import "API.h"

@interface BetSummaryVC ()

@end

@implementation BetSummaryVC

@synthesize bet;

- (id)initWithBet:(TempBet *)betObj {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        self.bet = betObj;
        self.screenName = @"Bet Summary (final step)";
        
        [[AlertMaker sharedInstance] scheduleNewNotification];
    }
    return self;
}

// shows the summary of the bet.
- (void)loadView {
    // Create main UIScrollView (the container for what follows)
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    int w = mainView.frame.size.width;
    
    int headerH = 150;
    int oppsH   = 135;
    int stakeH  = 175;
    int buttonH = 60;
    if (w > 500) {
        headerH = 300;
        stakeH = 300;
    }
    
    mainView.contentSize   = CGSizeMake(w, headerH + oppsH + stakeH + buttonH);
    mainView.backgroundColor = Blight;
    
    SummaryHeaderView *header = [[SummaryHeaderView alloc]initWithFrame:CGRectMake(0, 0, w, headerH) AndBet:bet];
    [mainView addSubview:header];
    
    SummaryOpponentsView *opps = [[SummaryOpponentsView alloc] initWithFrame:CGRectMake(0, headerH, w, oppsH) AndOpponents:bet.friends];
    [mainView addSubview:opps];
    
    SummaryStakeView *stake = [[SummaryStakeView alloc] initWithFrame:CGRectMake(0, headerH+oppsH, w, stakeH) AndBet:bet];
    [mainView addSubview:stake];
    
    // Betchyu button (to finish creating the bet)
    UIButton *betchyu = [[UIButton alloc] initWithFrame:CGRectMake(0, headerH+oppsH+stakeH, w, buttonH)];
    [betchyu setTitle:@"Return Home" forState:UIControlStateNormal];
    [betchyu addTarget:self action:@selector(home) forControlEvents:UIControlEventTouchUpInside];
    betchyu.tintColor = [UIColor whiteColor];
    betchyu.backgroundColor = Bgreen;
    betchyu.titleLabel.font   = [UIFont fontWithName:@"ProximaNova-Bold" size:15];
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow-16.png"]];
    arrow.image     = [arrow.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    arrow.tintColor = [UIColor whiteColor];
    arrow.frame     = CGRectMake(w-30, 22, 8, 15);
    [betchyu addSubview:arrow];
    [mainView addSubview:betchyu];
    
    
    // set the controller's view to the view we've been building in mainView
    self.view = mainView;
}

- (void) home {
    if ([self.bet.verb isEqualToString:@"Stop"]) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Your bet is now live! If you smoke once, you lose. Be sure to update your progress in \"My Bets.\"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    } else {
        [[[UIAlertView alloc]initWithTitle:@"Nice job!" message:@"Be sure to update your progress in \"My Bets\". You will lose if you don't complete the goal by the end date." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    
    // go to the home page
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES];
}

@end
