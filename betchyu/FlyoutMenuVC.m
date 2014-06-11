//
//  FlyoutMenuVC.m
//  betchyu
//
//  Created by Adam Baratz on 12/21/13.
//  Copyright (c) 2013 BetchyuLLC. All rights reserved.
//

#import "FlyoutMenuVC.h"
#import "ProfileView.h"
#import "AboutUs.h"
#import "HowItWorksVC.h"
#import "AppDelegate.h"
#import "Feedback.h"
#import "FlyoutTopView.h"
#import "SettingsVC.h"
#import "PastBetsVC.h"
#import "FriendsVC.h"

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
    UIColor *betchyu = [UIColor colorWithRed:(243/255.0) green:(116.0/255.0) blue:(67/255.0) alpha:1.0];
    UIColor *light = [UIColor colorWithRed:213.0/255 green:213.0/255 blue:214.0/255 alpha:1.0];
    int botY = 5*self.passedFrame.size.height/11;
    self.view = [[UIView alloc] initWithFrame:self.passedFrame];
    self.view.backgroundColor = [UIColor colorWithRed:(250/255.0) green:(250/255.0) blue:(250/255.0) alpha:1.0];
    
    // top section (picture, name, #bets won, #bets comleted)
    [self tryToAddTopSectionToView:NO];
    
    // TODO: edit profile button (overlaps top section)
    // dashboard button
    int butOff = 10;
    int butH = 39;
    UIButton *goToDashboardBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    goToDashboardBtn.frame = CGRectMake(0, botY + butOff, self.passedFrame.size.width, butH);
    goToDashboardBtn.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    [goToDashboardBtn addTarget:self action:@selector(backToDashboard:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goToDashboardBtn];
        // add the label
    UILabel *dashText = [[UILabel alloc] initWithFrame:CGRectMake(70, botY + butOff, self.passedFrame.size.width, 24)];
    dashText.font = [UIFont fontWithName:@"ProximaNova-Regular" size:22];
    dashText.text = @"Dashboard";
    dashText.textColor = light;
    [self.view addSubview:dashText];
        // add the icon
    UIImageView *dashImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home-10.png"]];
    dashImg.image = [dashImg.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    dashImg.tintColor = light;
    dashImg.frame = CGRectMake(30, botY + butOff, 21, 21);
    [self.view addSubview:dashImg];
    
    // past bets button
    butOff = butOff + butH;
    UIButton *pastBetsBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    pastBetsBtn.frame = CGRectMake(0, botY + butOff, self.passedFrame.size.width, butH);
    pastBetsBtn.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    [pastBetsBtn addTarget:self action:@selector(viewPastBets:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pastBetsBtn];
        // add the label
    UILabel *pastText = [[UILabel alloc] initWithFrame:CGRectMake(70, botY + butOff, self.passedFrame.size.width, 24)];
    pastText.font = [UIFont fontWithName:@"ProximaNova-Regular" size:22];
    pastText.textColor = light;
    pastText.text = @"Past Bets";
    [self.view addSubview:pastText];
        // add the icon
    UIImageView *pastBetsImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bet-11.png"]];
    pastBetsImg.image = [pastBetsImg.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    pastBetsImg.tintColor = light;
    pastBetsImg.frame = CGRectMake(30, botY + butOff, 21, 21);
    [self.view addSubview:pastBetsImg];
    
    // friends button
    butOff = butOff + butH;
    UIButton *friendsBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    friendsBtn.frame = CGRectMake(0, botY + butOff, self.passedFrame.size.width, butH);
    friendsBtn.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    [friendsBtn addTarget:self action:@selector(viewFriends:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:friendsBtn];
        // add the label
    UILabel *friendsText = [[UILabel alloc] initWithFrame:CGRectMake(70, botY + butOff, self.passedFrame.size.width, 24)];
    friendsText.font = [UIFont fontWithName:@"ProximaNova-Regular" size:22];
    friendsText.textColor = light;
    friendsText.text = @"Friends";
    [self.view addSubview:friendsText];
        // add the icon
    UIImageView *friendsImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"friends-12.png"]];
    friendsImg.image = [friendsImg.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    friendsImg.tintColor = light;
    friendsImg.frame = CGRectMake(30, botY + butOff, 21, 21);
    [self.view addSubview:friendsImg];
    
    // settings button
    butOff = butOff + butH;
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    setBtn.frame = CGRectMake(0, botY + butOff, self.passedFrame.size.width, butH);
    setBtn.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    [setBtn addTarget:self action:@selector(viewSettings:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:setBtn];
        // add the label
    UILabel *setText = [[UILabel alloc] initWithFrame:CGRectMake(70, botY + butOff, self.passedFrame.size.width, 24)];
    setText.font = [UIFont fontWithName:@"ProximaNova-Regular" size:22];
    setText.textColor = light;
    setText.text = @"Settings";
    [self.view addSubview:setText];
        // add the icon
    UIImageView *setImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"settings-13.png"]];
    setImg.image = [setImg.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    setImg.tintColor = light;
    setImg.frame = CGRectMake(30, botY + butOff, 21, 21);
    [self.view addSubview:setImg];
    
    // logout button
    butOff = butOff + butH + butH;
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    logoutBtn.frame = CGRectMake(0, botY + butOff, self.passedFrame.size.width, butH);
    logoutBtn.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    [logoutBtn addTarget:self action:@selector(logoutButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutBtn];
        // add the label
    UILabel *logoutText = [[UILabel alloc] initWithFrame:CGRectMake(70, botY + butOff, self.passedFrame.size.width, 24)];
    logoutText.font = [UIFont fontWithName:@"ProximaNova-Regular" size:22];
    logoutText.textColor = light;
    logoutText.text = @"Logout";
    [self.view addSubview:logoutText];
        // add the icon
    UIImageView *logoutImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logout-14.png"]];
    logoutImg.image = [logoutImg.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    logoutImg.tintColor = light;
    logoutImg.frame = CGRectMake(30, botY + butOff, 21, 21);
    [self.view addSubview:logoutImg];
    // add outlines
    UIView *l1 = [[UIView alloc] initWithFrame:CGRectMake(0, botY+butOff - 15, self.passedFrame.size.width, 2)];
    l1.backgroundColor = light;
    UIView *l2 = [[UIView alloc] initWithFrame:CGRectMake(0, botY+butOff + butH, self.passedFrame.size.width, 2)];
    l2.backgroundColor = light;
    [self.view addSubview:l1];
    [self.view addSubview:l2];
    
    // betchyu logo view
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tryToAddTopSectionToView:(BOOL)useless {
    if ([((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId isEqualToString:@""]) {
        // we need to wait a bit before setting up the profile pic
        [self performSelector:@selector(tryToAddTopSectionToView:) withObject:NO afterDelay:1];
        return;
    }
    
    FlyoutTopView *top = [[FlyoutTopView alloc]initWithFrame:CGRectMake(0, 0, self.passedFrame.size.width, 5*self.passedFrame.size.height/11)];
    [self.view addSubview:top];
}

-(void) logoutButtonWasPressed:(id)sender {
    // switch back to the main menu for when they log back in
    [(MTStackViewController *)((AppDelegate *)([[UIApplication sharedApplication] delegate])).window.rootViewController toggleLeftViewControllerAnimated:YES];
    // actual FB API call to log out
    [FBSession.activeSession closeAndClearTokenInformation];
}
-(void) profileButtonWasPressed:(id)sender {
    UIViewController *vc =[[UIViewController alloc] init];
    vc.view = [[ProfileView alloc] initWithFrame:self.passedFrame AndOwner:self];
    // Show it.
    [self.navigationController pushViewController:vc animated:true];
}
-(void) howItWorksPressed:(id)sender {
    UIPageViewController *pvc = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    pvc.dataSource = self;
    pvc.view.frame = self.view.frame;
    
    HowItWorksVC *firstPage = [self viewControllerAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:firstPage];
    
    [pvc setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    AppDelegate *app =(AppDelegate *)([[UIApplication sharedApplication] delegate]);
    
    [app.window setRootViewController:pvc];
    [app.window makeKeyAndVisible];
}
-(void) aboutUsPressed:(id)sender {
    UIViewController *vc =[[UIViewController alloc] init];
    vc.view = [[AboutUs alloc] initWithFrame:self.passedFrame AndOwner:self];
    // Show it.
    [self.navigationController pushViewController:vc animated:true];
}
-(void) feedbackPressed:(id)sender {
    UIViewController *vc =[[UIViewController alloc] init];
    vc.view = [[Feedback alloc] initWithFrame:self.passedFrame AndOwner:self];
    // Show it.
    [self.navigationController pushViewController:vc animated:true];
}
-(void) backToDashboard:(id)sender {
    self.stackViewController.leftViewControllerEnabled = YES;
    [(MTStackViewController *)((AppDelegate *)([[UIApplication sharedApplication] delegate])).window.rootViewController toggleLeftViewControllerAnimated:YES];
    self.stackViewController.leftViewControllerEnabled = NO;
    
    [((AppDelegate *)([[UIApplication sharedApplication] delegate])).navController popToRootViewControllerAnimated:NO];
}
-(void) viewPastBets:(id)sender {
    // get out of the flyout menu
    self.stackViewController.leftViewControllerEnabled = YES;
    [(MTStackViewController *)((AppDelegate *)([[UIApplication sharedApplication] delegate])).window.rootViewController toggleLeftViewControllerAnimated:NO];
    self.stackViewController.leftViewControllerEnabled = NO;
    
    PastBetsVC *vc = [[PastBetsVC alloc] init];
    vc.title = @"Past Bets";
    [((AppDelegate *)([[UIApplication sharedApplication] delegate])).navController pushViewController:vc animated:YES];
}
-(void) viewFriends:(id)sender {
    // get out of the flyout menu
    self.stackViewController.leftViewControllerEnabled = YES;
    [(MTStackViewController *)((AppDelegate *)([[UIApplication sharedApplication] delegate])).window.rootViewController toggleLeftViewControllerAnimated:NO];
    self.stackViewController.leftViewControllerEnabled = NO;
    
    FriendsVC *vc = [[FriendsVC alloc] init];
    vc.title = @"Friends";
    [((AppDelegate *)([[UIApplication sharedApplication] delegate])).navController pushViewController:vc animated:YES];
}
-(void) viewSettings:(id)sender {
    // get out of the flyout menu
    self.stackViewController.leftViewControllerEnabled = YES;
    [(MTStackViewController *)((AppDelegate *)([[UIApplication sharedApplication] delegate])).window.rootViewController toggleLeftViewControllerAnimated:NO];
    self.stackViewController.leftViewControllerEnabled = NO;
    
    SettingsVC *vc = [[SettingsVC alloc] init];
    vc.title = @"Settings";
    [((AppDelegate *)([[UIApplication sharedApplication] delegate])).navController pushViewController:vc animated:YES];
}


#pragma mark - UIPageViewControllerDataSource methods implementation
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(HowItWorksVC *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(HowItWorksVC *)viewController index];
    
    
    index++;
    
    if (index == 6) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}

- (HowItWorksVC *)viewControllerAtIndex:(NSUInteger)index {
    
    HowItWorksVC *childViewController = [[HowItWorksVC alloc] initWithNibName:nil bundle:nil];
    childViewController.index = index;
    
    return childViewController;
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return 6;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}

@end
