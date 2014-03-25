//
//  ViewController.m
//  iBetchyu
//
//  Created by Betchyu Computer on 11/16/13.
//  Copyright (c) 2013 Betchyu Computer. All rights reserved.
//

#import "ViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import "BetTypeViewController.h"
#import "BigButton.h"
#import "MyBetsVC.h"
#import "MyGoalsVC.h"
#import "API.h"
#import "MTStackViewController.h"
#import "FlyoutMenuVC.h"

@interface ViewController ()

-(IBAction)createGoal:(id)sender;
-(void)showMyGoals:(id)sender;
-(void)showMyBets:(id)sender;

@property (strong, nonatomic) BetTypeViewController *createGoalController;

@end

@implementation ViewController

@synthesize createGoalController = _createGoalController;
@synthesize numberOfInvites;
@synthesize numNotif;
@synthesize hasShownHowItWorks;
@synthesize canLeavePage;

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
    // Create main UIScrollView (the container for home page buttons)
    UIView *mainView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    [mainView setBackgroundColor:[UIColor colorWithRed:(39/255.0) green:(37/255.0) blue:(37/255.0) alpha:1.0]];
    CGFloat w = mainView.frame.size.width;
    CGFloat h = mainView.frame.size.height;
    
    int bH = h / 3.7;
    int buffer = 50;
    
    // Make the homepage Buttons
    // "My Goals" button
    BigButton *myGoals = [[BigButton alloc] initWithFrame:CGRectMake(20, 20+buffer, w-40, bH)
                                                     primary:1 title:@"MY GOALS"];
    [myGoals addTarget:self
                action:@selector(showMyGoals:)
         forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:myGoals];
    // "My Bets" button
    BigButton *myBets = [[BigButton alloc] initWithFrame:CGRectMake(20, bH+30+buffer, w-40, bH)
                                                     primary:1 title:@"FRIEND'S GOALS"];
    [myBets addTarget:self
                   action:@selector(showMyBets:)
         forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:myBets];
    
    if (![self.numberOfInvites isEqualToString:@"0"]) {
        self.numNotif   = [[UILabel alloc] initWithFrame:CGRectMake(w-39, bH+19+buffer, 30, 30)];
        self.numNotif.text       = numberOfInvites;
        self.numNotif.textAlignment      = UITextAlignmentCenter;
        self.numNotif.backgroundColor    = [UIColor colorWithRed:1.0 green:(117.0/255.0) blue:(63/255.0) alpha:1.0];
        self.numNotif.textColor  = [UIColor whiteColor];
        self.numNotif.font       = [UIFont fontWithName:@"ProximaNova-Black" size:25];
        self.numNotif.layer.cornerRadius = 15;
        [mainView addSubview:self.numNotif];
    }
    
    
    // "Create Goal" button
    BigButton *createGoal = [[BigButton alloc] initWithFrame:CGRectMake(20, 2*bH+40+buffer, w-40, bH)
                                                     primary:0 title:@"CREATE\nGOAL"];
    [createGoal addTarget:self
                   action:@selector(createGoal:)
         forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:createGoal];
    
    self.view = mainView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    /*self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"Logout"
                                              style:UIBarButtonItemStyleBordered
                                              target:self
                                              action:@selector(logoutButtonWasPressed:)];*/
    FBProfilePictureView *mypic = [[FBProfilePictureView alloc]
                                   initWithProfileID:((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId
                                   pictureCropping:FBProfilePictureCroppingSquare];
    mypic.frame = CGRectMake(0, 0, 26, 26);
    mypic.layer.cornerRadius = 13;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:mypic];
    self.navigationItem.title = @"BETCHYU";
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
    [[API sharedInstance] get:@"notifications" withParams:params onCompletion:^(NSDictionary *json) {
        for (NSDictionary* obj in json) {
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
                NSString *newPath = [NSString stringWithFormat:@"notifications/%@", [obj valueForKey:@"id"]];
                [[API sharedInstance] deletePath:newPath parameters:nil success:nil failure:nil];

            }];
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
    
    NSMutableDictionary* params =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  @"goals", @"restriction",
                                  ownerString, @"user",
                                  nil];
    
    //make the call to the web API
    [[API sharedInstance] get:@"bets" withParams:params
                 onCompletion:^(NSDictionary *json) {
                     //success
                     MyGoalsVC *vc =[[MyGoalsVC alloc] initWithGoals:(NSArray *)json];
                     vc.title = @"MY GOALS";
                     // Show it.
                     [self.navigationController pushViewController:vc animated:true];
                 }];
}

@end
