//
//  DashboardVC.m
//  betchyu
//
//  Created by Adam Baratz on 6/2/14.
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
    return;
    // quick check to see that we know who we are
    NSString *userId = ((AppDelegate *)([UIApplication sharedApplication].delegate)).ownId;
    if ([userId isEqualToString:@""]) {
        [self performSelector:@selector(viewDidAppear:) withObject:NO afterDelay:1];
        return;
    }
    
    // check for new offered Bets
    NSMutableDictionary* params =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  @"count", @"restriction",
                                  userId, @"user",
                                  nil];
    
    //make the call to the web API to get the number of pending invites (which shows up on the screen)
    [[API sharedInstance] get:@"invites" withParams:params onCompletion:^(NSDictionary *json) {
        self.canLeavePage = YES; // allow the page to be switched (initially not for API calling reasons)
        self.numberOfInvites = [[json valueForKey:@"count"] stringValue];
        
        if ([self.numberOfInvites isEqualToString:@"0"]) {
            [self.numNotif removeFromSuperview];
        } else {
            CGFloat w = self.view.frame.size.width;
            CGFloat h = self.view.frame.size.height;
            int bH = h / 3.7;
            int buffer = 50;
            
            [self.numNotif removeFromSuperview];
            self.numNotif   = [[UILabel alloc] initWithFrame:CGRectMake(w-39, bH+19+buffer, 30, 30)];
            self.numNotif.text       = numberOfInvites;
            self.numNotif.textAlignment      = NSTextAlignmentCenter;
            self.numNotif.backgroundColor    = [UIColor colorWithRed:1.0 green:(117.0/255.0) blue:(63/255.0) alpha:1.0];
            self.numNotif.textColor  = [UIColor whiteColor];
            self.numNotif.font       = [UIFont fontWithName:@"ProximaNova-Black" size:25];
            self.numNotif.layer.cornerRadius = 15;
            [self.view addSubview:self.numNotif];
        }
    }];
    
    // check for new pop-up notifications
    [params removeObjectForKey:@"restriction"]; // remove a parameter from the last request
    [[API sharedInstance] get:@"notifications" withParams:params onCompletion:^(NSDictionary *json) {
        for (NSDictionary* obj in json) {
            // if it is an accept/rejected bet notification
            if ([[obj valueForKey:@"kind"] integerValue] <= 2) {
                [FBRequestConnection startWithGraphPath:[obj valueForKey:@"data"] completionHandler:
                 ^(FBRequestConnection *connection, id result, NSError *error) {
                     if ([[obj valueForKey:@"kind"] integerValue] == 1) {        // rejected invite
                         [[[UIAlertView alloc] initWithTitle:@"Notification"
                                                     message:[NSString stringWithFormat:@"Your friend %@ rejected your bet.",[result valueForKey:@"name"]]
                                                    delegate:nil
                                           cancelButtonTitle:@"Oh well..."
                                           otherButtonTitles:nil]
                          show];
                     } else if ([[obj valueForKey:@"kind"] integerValue] == 2) { // accepted invite
                         [[[UIAlertView alloc] initWithTitle:@"Notification"
                                                     message:[NSString stringWithFormat:@"Your friend %@ accepted your bet! Yay!", [result valueForKey:@"name"]]
                                                    delegate:nil
                                           cancelButtonTitle:@"OK!"
                                           otherButtonTitles:nil]
                          show];
                     }
                 }];
                // if it's a won a bet notif
            } else if ([[obj valueForKey:@"kind"] integerValue] == 3) {
                [[[UIAlertView alloc] initWithTitle:@"Notification"
                                            message:[NSString stringWithFormat:@"You've won a bet. You'll get a $%@ gift card.", [obj valueForKey:@"data"]]
                                           delegate:nil
                                  cancelButtonTitle:@"Sweet!"
                                  otherButtonTitles:nil]
                 show];
                // it's a 'lost a bet' notif
            } else if ([[obj valueForKey:@"kind"] integerValue] == 4) {
                [[[UIAlertView alloc] initWithTitle:@"Notification"
                                            message:[NSString stringWithFormat:@"You've lost a bet. Your friend is getting a $%@ gift card on you.", [obj valueForKey:@"data"]]
                                           delegate:nil
                                  cancelButtonTitle:@"fine..."
                                  otherButtonTitles:nil]
                 show];
            }
            // DELETE /notifications/:id the notificaiton we just displayed, because it's done.
            NSString *newPath = [NSString stringWithFormat:@"notifications/%@", [obj valueForKey:@"id"]];
            [[API sharedInstance] deletePath:newPath parameters:nil success:nil failure:nil];
        }
    }];
    
    // set up the profile picture
    FBProfilePictureView *mypic = [[FBProfilePictureView alloc]
                                   initWithProfileID:((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId
                                   pictureCropping:FBProfilePictureCroppingSquare];
    mypic.frame = CGRectMake(0, 0, 26, 26);
    mypic.layer.cornerRadius = 13;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:mypic];
    
    // show them the how it works if it's their first time.
    if (self.hasShownHowItWorks) { return; }
    NSString *path = [NSString stringWithFormat:@"user/%@", ((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId];
    [[API sharedInstance] get:path withParams:nil onCompletion:^(NSDictionary *json) {
        if ([[json valueForKey:@"has_acted"] boolValue] == NO) {
            self.hasShownHowItWorks = YES;
            [self showMenu:nil];
            [((UINavigationController *)((AppDelegate *)([[UIApplication sharedApplication] delegate])).stackViewController.leftViewController).topViewController performSelector:@selector(howItWorksPressed:) withObject:nil afterDelay:1];
        }
    }];
}

// actions
-(void)showMenu:(id)sender {
    [(MTStackViewController *)((AppDelegate *)([[UIApplication sharedApplication] delegate])).window.rootViewController toggleLeftViewControllerAnimated:YES];
}
-(IBAction)createGoal:(id)sender {
    if (!self.canLeavePage) { return; }
    // change to the correct view
    if (!self.createGoalController) {
        self.createGoalController = [[BetTypeViewController alloc]
                                     initWithNibName:nil bundle:nil];
        self.createGoalController.title = @"I want to:";
    }
    
    [self.navigationController pushViewController:self.createGoalController
                                         animated:true];
}
-(void)showMyBets:(id)sender {
    if (!self.canLeavePage) { return; }
    // get the bets from the server
    NSString *ownerString = ((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId;
    
    NSMutableDictionary* params =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  @"ongoingBetsandopenBets", @"restriction",
                                  ownerString, @"user",
                                  nil];
    
    //make the call to the web API
    [[API sharedInstance] get:@"bets" withParams:params
                 onCompletion:^(NSDictionary *json) {
                     //success
                     MyBetsVC *vc =[[MyBetsVC alloc] initWithOngoingBets:(NSArray *)[json objectForKey:@"ongoingBets"]
                                                             andOpenBets:(NSArray *)[json objectForKey:@"openBets"]];
                     vc.title = @"FRIEND'S GOALS";
                     // Show it.
                     [self.navigationController pushViewController:vc animated:true];
                 }];
}
-(void)showMyGoals:(id)sender {
    if (!self.canLeavePage) { return; }
    // get the bets from the server
    NSString *ownerString = ((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId;
    
    NSString *path = [NSString stringWithFormat:@"goals/%@", ownerString];
    
    //make the call to the web API
    [[API sharedInstance] get:path withParams:nil onCompletion:^(NSDictionary *json) {
        //success
        MyGoalsVC *vc =[[MyGoalsVC alloc] initWithGoals:(NSArray *)json];
        vc.title = @"MY GOALS";
        // Show it.
        [self.navigationController pushViewController:vc animated:true];
    }];
}

@end
