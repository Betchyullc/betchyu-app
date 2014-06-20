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
    int h = f.size.height ;//- y;
    
    CGRect f2 = CGRectMake(f.origin.x, y, f.size.width, h);
    self.view = [[UIView alloc] init];
    
    self.yourView = [[YourPastBetsView alloc]initWithFrame:f2];
    //self.friendsView = [[FriendsPastBetsView alloc]initWithFrame:CGRectMake(0, y+h/2, f.size.width, h/2)];
    
    [self.view addSubview:self.yourView];
    //[self.view addSubview:self.friendsView];
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
    
    UIButton *bu2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [bu2 setImage:[UIImage imageNamed:@"menu-17.png"] forState:UIControlStateNormal];
    bu2.frame = CGRectMake(0, 0, 20, 18);
    bu2.tintColor = [UIColor whiteColor];
    [bu2 addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:bu2];
}

-(void)viewWillAppear:(BOOL)animated {
    NSString *path = [NSString stringWithFormat:@"past-bets/%@", ((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId];
    [[API sharedInstance] get:path withParams:nil onCompletion:^(NSDictionary *json) {
        NSLog(@"response: %@", json);
        [self.yourView drawBets:json];
        CGRect fr = self.yourView.frame;
        self.yourView.frame = CGRectMake(0, fr.origin.y, fr.size.width, yourView.rowHt * ((NSArray *)json).count + yourView.fontSize*1.8);
    }];
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
    CreateBetVC *createGoalController = [[CreateBetVC alloc] initWithStyle:UITableViewStylePlain];
    createGoalController.title = @"Create Bet";
    [self.navigationController pushViewController:createGoalController animated:true];
}

@end
