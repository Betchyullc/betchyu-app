//  PastBetsVC.m
//  betchyu
//
//  Created by Daniel Zapata on 6/11/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.

#import "PastBetsVC.h"

@interface PastBetsVC ()

@end

@implementation PastBetsVC

@synthesize yourView;
@synthesize friendsView;

- (id)init {
    self = [super init];
    if (self) {
        self.screenName = @"Past Bets";
        // Custom initialization
    }
    return self;
}

-(void) loadView {
    CGRect f = [UIScreen mainScreen].applicationFrame;
    
    int y = self.navigationController.navigationBar.frame.size.height + f.origin.y; // navBar + statusBar
    int h = f.size.height ;//- y;
    
    CGRect f2 = CGRectMake(f.origin.x, 0, f.size.width, h/2);
    self.view = [[UIScrollView alloc] init];
    ((UIScrollView *)self.view).contentSize = CGSizeMake(f.size.width, h);
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.yourView = [[YourPastBetsView alloc]initWithFrame:f2];
    self.friendsView = [[FriendsPastBetsView alloc]initWithFrame:CGRectMake(0, y+h/2, f.size.width, h/2)];
    
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
        NSArray *myPast = [json valueForKey:@"myPast"];
        NSArray *friendsPast = [json valueForKey:@"friendsPast"];
        
        [self.yourView removeFromSuperview];
        CGRect fr = self.yourView.frame;
        int ht = MAX((yourView.rowHt * myPast.count), yourView.rowHt);
        self.yourView = [[YourPastBetsView alloc] initWithFrame:CGRectMake(0, fr.origin.y, fr.size.width, ht + yourView.fontSize*1.8)];
        [self.yourView drawBets:myPast];
        [self.view addSubview:self.yourView];
        
        [self.friendsView removeFromSuperview];
        fr = self.friendsView.frame;
        int ht2 = MAX((friendsView.rowHt * friendsPast.count), friendsView.rowHt);
        self.friendsView = [[FriendsPastBetsView alloc]initWithFrame:CGRectMake(0, self.yourView.frame.origin.y + self.yourView.frame.size.height, fr.size.width, ht2 + friendsView.fontSize*1.8)];
        [self.friendsView drawBets:friendsPast];
        [self.view addSubview:self.friendsView];
        
        ((UIScrollView *)self.view).contentSize = CGSizeMake(fr.size.width, ht + ht2 + 100);
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
