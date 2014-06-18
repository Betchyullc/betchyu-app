//
//  BetSummaryVC.m
//  betchyu
//
//  Created by Adam Baratz on 5/7/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import "BetSummaryVC.h"
#import "AppDelegate.h"
#import "API.h"

@interface BetSummaryVC ()

@end

@implementation BetSummaryVC

@synthesize bet;
@synthesize managedObjectContext;

- (id)initWithBet:(TempBet *)betObj {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        self.bet = betObj;
        AppDelegate *appDelegate = (AppDelegate *)([[UIApplication sharedApplication] delegate]);
        self.managedObjectContext = appDelegate.managedObjectContext;
    }
    return self;
}
// shows the summary of the bet.
- (void)loadView {
    // Create main UIScrollView (the container for what follows)
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    int h = mainView.frame.size.height - 40;
    int w = mainView.frame.size.width;
    mainView.contentSize   = CGSizeMake(w, h);
    [mainView setBackgroundColor:[UIColor colorWithRed:(39/255.0) green:(37/255.0) blue:(37/255.0) alpha:1.0]];
    
    int headerH = 155;
    
    SummaryHeaderView *header = [[SummaryHeaderView alloc]initWithFrame:CGRectMake(0, 0, w, headerH) AndBet:bet];
    [mainView addSubview:header];
    
    SummaryOpponentsView *opps = [[SummaryOpponentsView alloc] initWithFrame:CGRectMake(0, headerH, w, headerH) AndOpponents:bet.friends];
    [mainView addSubview:opps];
    
    // Betchyu button (to finish creating the bet)
    BigButton *betchyu = [[BigButton alloc] initWithFrame:CGRectMake(20, h - 120, w-40, 100)
                                                  primary:0
                                                    title:@"I'm Done"];
    [betchyu addTarget:self action:@selector(home) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:betchyu];
    
    
    // set the controller's view to the view we've been building in mainView
    self.view = mainView;
}

- (void) home {
    // go to the home page
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
