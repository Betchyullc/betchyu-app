//  DashboardVC.m
//  betchyu
//
//  Created by Daniel Zapata on 6/2/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.

#import "DashboardVC.h"

@interface DashboardVC ()

@end

@implementation DashboardVC

@synthesize numberOfInvites;
@synthesize numNotif;
@synthesize hasShownHowItWorks;
@synthesize canLeavePage;
@synthesize createGoalController;
@synthesize howItWorksContainerVC;
@synthesize spinner;

- (id)initWithInviteNumber:(NSString *)numInvs {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        self.numberOfInvites = numInvs;
        self.hasShownHowItWorks = NO;
        self.canLeavePage = NO;
        self.screenName = @"Dashboard";
        
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
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.center = CGPointMake(f.size.width/2, h/2);
    [self.view addSubview:self.spinner];
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
    [self.spinner startAnimating];
    [self.view bringSubviewToFront:spinner];
    
    [self getAndAddPendingBets:nil];
    [self getAndAddMyBets:nil];
    [self getAndAddFriendsBets:nil];  // also stops the spinner from animating
    [self checkAndShowHowItWorks:nil];
}

// API call methods
- (void) getAndAddPendingBets:(id)useless {
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
        if ([((NSArray *)json) respondsToSelector:@selector(objectAtIndex:)]) {
            // json is our array of Bets, hopefully
            [((Dashboard *)self.view) adjustPendingHeight:((NSArray *)json).count];
            [((Dashboard *)self.view).pending addBets:(NSArray *)json];
        } else {
            NSLog(@"something went wrong: %@", json);
        }
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
        
        if ([((NSArray *)json) respondsToSelector:@selector(objectAtIndex:)]) {
            // json is our array of Bets, hopefully
            [((Dashboard *)self.view) adjustMyBetsHeight:((NSArray *)json).count];
            [((Dashboard *)self.view).my addBets:(NSArray *)json];
        } else {
            NSLog(@"something went wrong: %@", json);
        }
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
        [self.spinner stopAnimating]; // we done with getting stuff from the server, so we stop the spinner
        
        if ([((NSArray *)json) respondsToSelector:@selector(objectAtIndex:)]) {
            // json is our array of Bets, hopefully
            [((Dashboard *)self.view) adjustFriendsBetsHeight:((NSArray *)json).count];
            [((Dashboard *)self.view).friends addBets:(NSArray *)json];
        } else {
            NSLog(@"something went wrong: %@", json);
        }
        
        self.canLeavePage = YES; // this is usually the last thing to get updated, so we allow them to leave the page after this loads.
    }];
}
- (void) checkAndShowHowItWorks:(id)useless {
    if (self.hasShownHowItWorks) { return; }
    NSString *ownId = ((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId;
    // ensuring the app ain't just started
    if ([ownId isEqualToString:@""]) {
        // we need to wait a bit before setting up the profile pic
        [self performSelector:@selector(checkAndShowHowItWorks:) withObject:NO afterDelay:1];
        return;
    }
    
    /// the path to retrieve notificaitons from
    NSString *path =[NSString stringWithFormat:@"user/%@", ownId];
    
    //make the call to the web API
    [[API sharedInstance] get:path withParams:nil onCompletion:^(NSDictionary *json) {
        self.hasShownHowItWorks = YES;//dont want to bother with this request again, regardless of whether it worked or not.
        BOOL has_acted = [[json valueForKey:@"has_acted"] boolValue];
        if (!has_acted) {
            self.howItWorksContainerVC = [[SettingsVC alloc] init];
            [self.howItWorksContainerVC performSelector:@selector(howItWorksPressed:) withObject:nil afterDelay:1];
            [[[UIAlertView alloc]initWithTitle:@"New?" message:@"This looks like your first time here! Here's how it all works." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        }
    }];
}
// actions
-(void)showMenu:(id)sender {
    if (!self.canLeavePage) { return; }
    
    self.stackViewController.leftViewControllerEnabled = YES;
    [(MTStackViewController *)((AppDelegate *)([[UIApplication sharedApplication] delegate])).window.rootViewController toggleLeftViewControllerAnimated:YES];
    self.stackViewController.leftViewControllerEnabled = NO;
    
    // TRACK THIS SHIT AND ANALYZE IT
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker set:kGAIScreenName value:@"Flyout Menu"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];

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
    
    // TRACK THIS SHIT AND ANALYZE IT
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker set:kGAIScreenName value:@"Create Goal (step 1)"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

@end
