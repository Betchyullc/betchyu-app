//
//  PastBetsVC.m
//  betchyu
//
//  Created by Adam Baratz on 6/11/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import "PastBetsVC.h"

@interface PastBetsVC ()

@end

@implementation PastBetsVC

@synthesize yourView;
@synthesize friendsView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) loadView {
    CGRect f = [UIScreen mainScreen].applicationFrame;
    
    int y = self.navigationController.navigationBar.frame.size.height + f.origin.y; // navBar + statusBar
    int h = f.size.height - y;
    
    CGRect f2 = CGRectMake(f.origin.x, y, f.size.width, h);
    self.view = [[UIView alloc] initWithFrame:f2];
    
    self.yourView = [[YourPastBetsView alloc]initWithFrame:CGRectMake(0, 0, f.size.width, h/2)];
    self.friendsView = [[FriendsPastBetsView alloc]initWithFrame:CGRectMake(0, h/2, f.size.width, h/2)];
    
    [self.view addSubview:self.yourView];
    [self.view addSubview:self.friendsView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIButton *bu = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [bu setImage:[UIImage imageNamed:@"plus-18.png"] forState:UIControlStateNormal];
    bu.frame = CGRectMake(0, 0, 22, 22);
    bu.tintColor = [UIColor whiteColor];
    [bu addTarget:self action:@selector(createGoal:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:bu];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"flyout_menu.png"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(showMenu:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// actions
-(void)showMenu:(id)sender {
    self.stackViewController.leftViewControllerEnabled = YES;
    [(MTStackViewController *)((AppDelegate *)([[UIApplication sharedApplication] delegate])).window.rootViewController toggleLeftViewControllerAnimated:YES];
    self.stackViewController.leftViewControllerEnabled = NO;
}
-(void)createGoal:(id)sender {
    //if (!self.canLeavePage) { return; }
    // change to the correct view
    BetTypeViewController *createGoalController = [[BetTypeViewController alloc] initWithNibName:nil bundle:nil];
    createGoalController.title = @"I want to:";
    [self.navigationController pushViewController:createGoalController animated:true];
}

@end
