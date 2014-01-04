//
//  FlyoutMenuVC.m
//  betchyu
//
//  Created by Adam Baratz on 12/21/13.
//  Copyright (c) 2013 BetchyuLLC. All rights reserved.
//

#import "FlyoutMenuVC.h"
#import "ProfileView.h"
#import "HowItWorks.h"

@interface FlyoutMenuVC ()

@end

@implementation FlyoutMenuVC

@synthesize passedFrame;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        passedFrame = frame;
    }
    return self;
}

-(void)loadView {
    self.view = [[UIView alloc] initWithFrame:self.passedFrame];
    self.view.backgroundColor = [UIColor colorWithRed:(69/255.0) green:(69/255.0) blue:(69/255.0) alpha:1.0];
    UIView *lineView;
    ///////////////////////
    // My Profile Button
    ///////////////////////
    // The line above it
    lineView = [[UIView alloc] initWithFrame:CGRectMake(25, 50, passedFrame.size.width, 2)];
    lineView.backgroundColor = [UIColor whiteColor];
    // convenience frame
    CGRect useRect = CGRectMake(25, 60, 280, 40);
    // the button
    UIButton *myProfile = [[UIButton alloc] initWithFrame:useRect];
    [myProfile addTarget:self action:@selector(profileButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
    // The separate Text label for easier control
    UILabel *myProfileLabel = [[UILabel alloc] initWithFrame:useRect];
    myProfileLabel.text = @"My Profile";
    myProfileLabel.textColor = [UIColor whiteColor];
    myProfileLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:20];
    // add all the subviews
    [self.view addSubview:myProfile];
    [self.view addSubview:myProfileLabel];
    [self.view addSubview:lineView];
    
    ///////////////////////
    // How It Works Button
    ///////////////////////
    // The line above it
    lineView = [[UIView alloc] initWithFrame:CGRectMake(25, 110, passedFrame.size.width, 2)];
    lineView.backgroundColor = [UIColor whiteColor];
    // convenience frame
    useRect = CGRectMake(25, 120, 280, 40);
    // the button
    UIButton *howWork = [[UIButton alloc] initWithFrame:useRect];
    [howWork addTarget:self action:@selector(howItWorksPressed:) forControlEvents:UIControlEventTouchUpInside];
    // The separate Text label for easier control
    UILabel *howWorkLabel = [[UILabel alloc] initWithFrame:useRect];
    howWorkLabel.text = @"How It Works";
    howWorkLabel.textColor = [UIColor whiteColor];
    howWorkLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:20];
    // add all the subviews
    [self.view addSubview:howWork];
    [self.view addSubview:howWorkLabel];
    [self.view addSubview:lineView];
    
    ///////////////////////
    // About Us Button
    ///////////////////////
    // The line above it
    lineView = [[UIView alloc] initWithFrame:CGRectMake(25, 170, passedFrame.size.width, 2)];
    lineView.backgroundColor = [UIColor whiteColor];
    // convenience frame
    useRect = CGRectMake(25, 180, 280, 40);
    // the button
    UIButton *about = [[UIButton alloc] initWithFrame:useRect];
    [about addTarget:self action:@selector(aboutUsPressed:) forControlEvents:UIControlEventTouchUpInside];
    // The separate Text label for easier control
    UILabel *aboutLabel = [[UILabel alloc] initWithFrame:useRect];
    aboutLabel.text = @"About Us";
    aboutLabel.textColor = [UIColor whiteColor];
    aboutLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:20];
    // add all the subviews
    [self.view addSubview:about];
    [self.view addSubview:aboutLabel];
    [self.view addSubview:lineView];
    
    ///////////////////////
    // Logout Button
    ///////////////////////
    // The line above it
    lineView = [[UIView alloc] initWithFrame:CGRectMake(25, passedFrame.size.height-50, passedFrame.size.width, 2)];
    lineView.backgroundColor = [UIColor whiteColor];
    // convenience frame
    CGRect logoutRect = CGRectMake(25, passedFrame.size.height-50, 280, 40);
    // the button
    UIButton *logout = [[UIButton alloc] initWithFrame:logoutRect];
    [logout addTarget:self action:@selector(logoutButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
    // The separate Text label for easier control
    UILabel *logoutLabel = [[UILabel alloc] initWithFrame:logoutRect];
    logoutLabel.text = @"Logout";
    logoutLabel.textColor = [UIColor whiteColor];
    logoutLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:20];
    // add all the subviews
    [self.view addSubview:logout];
    [self.view addSubview:logoutLabel];
    [self.view addSubview:lineView];
    
}
-(void) logoutButtonWasPressed:(id)sender {
    [FBSession.activeSession closeAndClearTokenInformation];
}
-(void) profileButtonWasPressed:(id)sender {
    UIViewController *vc =[[UIViewController alloc] init];
    vc.view = [[ProfileView alloc] initWithFrame:self.passedFrame AndOwner:self];
    // Show it.
    [self.navigationController pushViewController:vc animated:true];
}
-(void) howItWorksPressed:(id)sender {
    
}
-(void) aboutUsPressed:(id)sender {
    UIViewController *vc =[[UIViewController alloc] init];
    vc.view = [[HowItWorks alloc] initWithFrame:self.passedFrame AndOwner:self];
    // Show it.
    [self.navigationController pushViewController:vc animated:true];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
