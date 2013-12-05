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

@interface ViewController ()

-(IBAction)createGoal:(id)sender;
@property (strong, nonatomic) BetTypeViewController *createGoalController;

@end

@implementation ViewController

@synthesize createGoalController = _createGoalController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void) loadView {
    // Create main UIScrollView (the container for home page buttons)
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    mainView.contentSize   = CGSizeMake(320, 1000);
    [mainView setBackgroundColor:[UIColor darkGrayColor]];
    
    // Make the homepage Buttons
    // "My Goals" button
    BigButton *myGoals = [[BigButton alloc] initWithFrame:CGRectMake(20, 20, 280, 100)
                                                     primary:1 title:@"My Goals"];
    /*[myGoals addTarget:self
                   action:@selector(SOMETHING GOES HERE)
         forControlEvents:UIControlEventTouchUpInside];*/
    [mainView addSubview:myGoals];
    // "My Bets" button
    BigButton *myBets = [[BigButton alloc] initWithFrame:CGRectMake(20, 200, 280, 100)
                                                     primary:1 title:@"My Bets"];
    /*[myBets addTarget:self
                   action:@selector(SOMETHING GOES HERE)
         forControlEvents:UIControlEventTouchUpInside];*/
    [mainView addSubview:myBets];
    // "Create Goal" button
    BigButton *createGoal = [[BigButton alloc] initWithFrame:CGRectMake(20, 380, 280, 100)
                                                     primary:0 title:@"Create Goal"];
    [createGoal addTarget:self
                   action:@selector(createGoal:)
         forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:createGoal];
    
    self.view = mainView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"Logout"
                                              style:UIBarButtonItemStyleBordered
                                              target:self
                                              action:@selector(logoutButtonWasPressed:)];
    self.navigationItem.title = @"BETCHYU";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:1.0
                                                                        green:(117.0/255.0)
                                                                         blue:(63/255.0)
                                                                        alpha:1.0];
}

- (void)didReceiveMemoryWarning
{
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

@end
