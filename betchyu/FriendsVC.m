//  FriendsVC.m
//  betchyu
//
//  Created by Daniel Zapata on 6/11/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.

#import "FriendsVC.h"

@interface FriendsVC ()

@end

@implementation FriendsVC

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
    self.view = [[UIView alloc]initWithFrame:f2];
    self.view.backgroundColor = [UIColor grayColor];
    
    UILabel *comingSoon = [[UILabel alloc] initWithFrame:CGRectMake(0, h/2 - 40, f.size.width, 60)];
    comingSoon.text = @"Coming Soon";
    comingSoon.textAlignment = NSTextAlignmentCenter;
    comingSoon.font = [UIFont fontWithName:@"ProximaNova-Regular" size:30];
    comingSoon.textColor = Borange;
    
    [self.view addSubview:comingSoon];
}

- (void)viewDidLoad {
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
