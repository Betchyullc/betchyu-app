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

@interface ViewController ()

-(IBAction)createGoal:(id)sender;
-(void)showMyGoals:(id)sender;
-(void)showMyBets:(id)sender;

@property (strong, nonatomic) BetTypeViewController *createGoalController;

@end

@implementation ViewController

@synthesize createGoalController = _createGoalController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (!FBSession.activeSession.isOpen) {
            [FBSession openActiveSessionWithAllowLoginUI: YES];
        }
        // Fetch user data
        [FBRequestConnection
         startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                           id<FBGraphUser> user,
                                           NSError *error) {
             if (!error) {
                 ((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId = user.id;
                 NSLog(@"inner: %@", user.id);
             } else {
                 ((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId = @"";
             }
         }];
        
    }
    
    return self;
}

- (void) loadView {
    // Create main UIScrollView (the container for home page buttons)
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    mainView.contentSize   = CGSizeMake(320, 1000);
    [mainView setBackgroundColor:[UIColor colorWithRed:(39/255.0) green:(37/255.0) blue:(37/255.0) alpha:1.0]];
    
    // Make the homepage Buttons
    // "My Goals" button
    BigButton *myGoals = [[BigButton alloc] initWithFrame:CGRectMake(20, 20, 280, 140)
                                                     primary:1 title:@"MY GOALS"];
    [myGoals addTarget:self
                action:@selector(showMyGoals:)
         forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:myGoals];
    // "My Bets" button
    BigButton *myBets = [[BigButton alloc] initWithFrame:CGRectMake(20, 180, 280, 140)
                                                     primary:1 title:@"MY BETS"];
    [myBets addTarget:self
                   action:@selector(showMyBets:)
         forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:myBets];
    // "Create Goal" button
    BigButton *createGoal = [[BigButton alloc] initWithFrame:CGRectMake(20, 340, 280, 140)
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"Logout"
                                              style:UIBarButtonItemStyleBordered
                                              target:self
                                              action:@selector(logoutButtonWasPressed:)];
    self.navigationItem.title = @"BETCHYU";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) logoutButtonWasPressed:(id)sender {
    [FBSession.activeSession closeAndClearTokenInformation];
}

-(IBAction)createGoal:(id)sender {
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
    // get the bets from the server
    NSString *ownerString = ((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId;
    
    NSMutableDictionary* params =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  @"ongoingBets", @"restriction",
                                  ownerString, @"user",
                                  nil];
    
    //make the call to the web API
    [[API sharedInstance] get:@"bets" withParams:params
                 onCompletion:^(NSDictionary *json) {
                         //success
                         MyBetsVC *vc =[[MyBetsVC alloc] initWithOngoingBets:(NSArray *)json];
                         vc.title = @"MY BETS";
                         // Show it.
                         [self.navigationController pushViewController:vc animated:true];
                 }];
}
-(void)showMyGoals:(id)sender {
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
