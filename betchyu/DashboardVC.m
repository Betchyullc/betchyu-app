//
//  DashboardVC.m
//  betchyu
//
//  Created by Daniel Zapata on 6/2/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import "DashboardVC.h"

@interface DashboardVC ()

@end

@implementation DashboardVC

@synthesize numberOfInvites;
@synthesize numNotif;
@synthesize hasShownHowItWorks;
@synthesize canLeavePage;
@synthesize createGoalController;

- (id)initWithInviteNumber:(NSString *)numInvs {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        self.numberOfInvites = numInvs;
        self.hasShownHowItWorks = NO;
        self.canLeavePage = NO;
        
        // remove the "Dasboard" from the back button on following pages
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    }
    
    return self;
}

- (void) loadView {
    CGRect f = [UIScreen mainScreen].applicationFrame;
    //NSLog(@"fy:%f fh:%f",f.origin.y,f.size.height);

    int y = self.navigationController.navigationBar.frame.size.height + f.origin.y; // navBar + statusBar
    int h = f.size.height - y;
    //NSLog(@"y:%i h:%i",y,h);
    
    CGRect f2 = CGRectMake(f.origin.x, y, f.size.width, h);
    self.view = [[Dashboard alloc] initWithFrame:f2];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    // make a plus button for new goal/bet
    UIButton *bu = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [bu setImage:[UIImage imageNamed:@"plus-18.png"] forState:UIControlStateNormal];
    bu.frame = CGRectMake(0, 0, 20, 20);
    bu.tintColor = [UIColor whiteColor];
    [bu addTarget:self action:@selector(createGoal:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:bu];
    
    self.navigationItem.title = @"Dashboard";
    
    UIButton *bu2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [bu2 setImage:[UIImage imageNamed:@"menu-17.png"] forState:UIControlStateNormal];
    bu2.frame = CGRectMake(0, 0, 20, 18);
    bu2.tintColor = [UIColor whiteColor];
    [bu2 addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:bu2];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getAndAddPendingBets:nil];
    [self getAndAddMyBets:nil];
    [self getAndAddFriendsBets:nil];
}

// API call methods
- (void)getAndAddPendingBets:(id)useless {
    NSString *ownId = ((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId;
    
    // ensuring the app ain't just started
    if ([ownId isEqualToString:@""]) {
        // we need to wait a bit before setting up the profile pic
        [self performSelector:@selector(getAndAddPendingBets:) withObject:NO afterDelay:1];
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"pending-bets/%@",ownId];
    
    //make the call to the web API
    [[API sharedInstance] get:path withParams:nil onCompletion:^(NSDictionary *json) {
        // json is our array of Bets, hopefully
        [((Dashboard *)self.view) adjustPendingHeight:((NSArray *)json).count];
        [((Dashboard *)self.view).pending addBets:(NSArray *)json];
    }];

}
- (void) getAndAddMyBets:(id)useless {
    NSString *ownId = ((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId;
    
    // ensuring the app ain't just started
    if ([ownId isEqualToString:@""]) {
        // we need to wait a bit before setting up the profile pic
        [self performSelector:@selector(getAndAddMyBets:) withObject:NO afterDelay:1];
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"my-bets/%@",ownId];
    
    //make the call to the web API
    [[API sharedInstance] get:path withParams:nil onCompletion:^(NSDictionary *json) {
        // json is our array of Bets, hopefully
        [((Dashboard *)self.view) adjustMyBetsHeight:((NSArray *)json).count];
        [((Dashboard *)self.view).my addBets:(NSArray *)json];
    }];
}
- (void) getAndAddFriendsBets:(id)useless {
    NSString *ownId = ((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId;
    
    // ensuring the app ain't just started
    if ([ownId isEqualToString:@""]) {
        // we need to wait a bit before setting up the profile pic
        [self performSelector:@selector(getAndAddFriendsBets:) withObject:NO afterDelay:1];
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"friend-bets/%@",ownId];
    
    //make the call to the web API
    [[API sharedInstance] get:path withParams:nil onCompletion:^(NSDictionary *json) {
        // json is our array of Bets, hopefully
        [((Dashboard *)self.view) adjustFriendsBetsHeight:((NSArray *)json).count];
        [((Dashboard *)self.view).friends addBets:(NSArray *)json];
        self.canLeavePage = YES; // this is usually the last thing to get updated, so we allow them to leave the page after this loads.
    }];
}

// actions
-(void)showMenu:(id)sender {
    if (!self.canLeavePage) { return; }
    
    self.stackViewController.leftViewControllerEnabled = YES;
    [(MTStackViewController *)((AppDelegate *)([[UIApplication sharedApplication] delegate])).window.rootViewController toggleLeftViewControllerAnimated:YES];
    self.stackViewController.leftViewControllerEnabled = NO;
}
-(IBAction)createGoal:(id)sender {
    if (!self.canLeavePage) { return; }
    
    // change to the correct view
    if (!self.createGoalController) {
        self.createGoalController = [[CreateBetVC alloc] initWithStyle:UITableViewStylePlain];
        self.createGoalController.title = @"Create Bet";
    }
    
    [self.navigationController pushViewController:self.createGoalController
                                         animated:true];
}

@end
