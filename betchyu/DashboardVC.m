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
    /*FBProfilePictureView *mypic = [[FBProfilePictureView alloc]
                                   initWithProfileID:((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId
                                   pictureCropping:FBProfilePictureCroppingSquare];
    mypic.frame = CGRectMake(0, 0, 26, 26);
    mypic.layer.cornerRadius = 13;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:mypic];*/
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(createGoal:)];
    self.navigationItem.title = @"Dashboard";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"flyout_menu.png"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(showMenu:)];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getAndAddPendingBets:nil];
    [self getAndAddMyBets:nil];
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

// actions
-(void)showMenu:(id)sender {
    self.stackViewController.leftViewControllerEnabled = YES;
    [(MTStackViewController *)((AppDelegate *)([[UIApplication sharedApplication] delegate])).window.rootViewController toggleLeftViewControllerAnimated:YES];
    self.stackViewController.leftViewControllerEnabled = NO;
}
-(IBAction)createGoal:(id)sender {
    //if (!self.canLeavePage) { return; }
    // change to the correct view
    if (!self.createGoalController) {
        self.createGoalController = [[BetTypeViewController alloc]
                                     initWithNibName:nil bundle:nil];
        self.createGoalController.title = @"I want to:";
    }
    
    [self.navigationController pushViewController:self.createGoalController
                                         animated:true];
}

@end
