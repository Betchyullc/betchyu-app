//  FlyoutMenuVC.m
//  betchyu
//
//  Created by Daniel Zapata on 12/21/13.
//  Copyright (c) 2013 BetchyuLLC. All rights reserved.

#import "FlyoutMenuVC.h"
#import "ProfileView.h"
#import "AboutUs.h"
#import "HowItWorksVC.h"
#import "AppDelegate.h"
#import "Feedback.h"
#import "SettingsVC.h"
#import "PastBetsVC.h"
#import "FriendsVC.h"
#import "EditProfileVC.h"

@implementation FlyoutMenuVC

@synthesize passedFrame;

@synthesize top;
@synthesize editBtn;

@synthesize dashBtn;
@synthesize dashImg;
@synthesize dashText;

@synthesize pastBtn;
@synthesize pastImg1;
@synthesize pastText1;

@synthesize friendsBtn;
@synthesize friendsImg;
@synthesize friendsText;

@synthesize setBtn;
@synthesize setImg;
@synthesize setText;

@synthesize last;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        passedFrame = frame;
        last = 0; // 0 means dashboard, 1 means Past Bets, 2 Friends, 3 Settings
    }
    return self;
}

-(void)loadView {
    NSLog(@"%f",self.passedFrame.size.height);
    int botY = 5*self.passedFrame.size.height/11;
    UIView *v = [[UIView alloc] initWithFrame:self.passedFrame];
    v.backgroundColor = [UIColor colorWithRed:(250/255.0) green:(250/255.0) blue:(250/255.0) alpha:1.0];
    self.view = v;
    
    // top section (picture, name, #bets won, #bets comleted)
    [self tryToAddTopSectionToView:NO];
    
    // TODO: edit profile button (overlaps top section)
    self.editBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [editBtn setTitle:@"Edit Profile" forState:UIControlStateNormal];
    [editBtn sizeToFit];
    [editBtn addTarget:self action:@selector(editProfile:) forControlEvents:UIControlEventTouchUpInside];
    editBtn.tintColor = Bmid;
    int editBtnYoff = passedFrame.size.height > 500 ? botY - 60 : botY - 70;
    editBtn.frame = CGRectMake(self.passedFrame.size.width/2 - 50, editBtnYoff, 100, 18);
    [self.view addSubview:editBtn];
    
    // dashboard button
    int butOff = 15;
    int butPad = butOff/2;
    int butH = 39;
    int fS = 20;
    self.dashBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    dashBtn.frame = CGRectMake(0, botY, self.passedFrame.size.width, butH+butPad);
    dashBtn.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0]; // transparent
    [dashBtn addTarget:self action:@selector(backToDashboard:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dashBtn];
        // add the label
    self.dashText = [[UILabel alloc] initWithFrame:CGRectMake(70, botY + butOff, self.passedFrame.size.width, 24)];
    self.dashText.font = [UIFont fontWithName:@"ProximaNovaT-Thin" size:fS];
    self.dashText.text = @"Dashboard";
    self.dashText.textColor = Bdark;
    [self.view addSubview:dashText];
        // add the icon
    self.dashImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home-10.png"]];
    dashImg.image = [dashImg.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    dashImg.tintColor = Bdark;
    dashImg.frame = CGRectMake(30, botY + butOff, 21, 21);
    [self.view addSubview:dashImg];
    
    // past bets button
    butOff = butOff + butH;
    self.pastBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    pastBtn.frame = CGRectMake(0, botY + butOff - butPad, self.passedFrame.size.width, butH);
    pastBtn.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    [pastBtn addTarget:self action:@selector(viewPastBets:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pastBtn];
        // add the label
    self.pastText1 = [[UILabel alloc] initWithFrame:CGRectMake(70, botY + butOff, self.passedFrame.size.width, 24)];
    pastText1.font = [UIFont fontWithName:@"ProximaNovaT-Thin" size:fS];
    pastText1.textColor = Bdark;
    pastText1.text = @"Past Bets";
    [self.view addSubview:pastText1];
        // add the icon
    self.pastImg1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bet-11.png"]];
    pastImg1.image = [pastImg1.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    pastImg1.tintColor = Bdark;
    pastImg1.frame = CGRectMake(32, botY + butOff, 16, 21);
    [self.view addSubview:pastImg1];
    
    // friends button
    butOff = butOff + butH;
    self.friendsBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    friendsBtn.frame = CGRectMake(0, botY + butOff -butPad, self.passedFrame.size.width, butH);
    friendsBtn.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    [friendsBtn addTarget:self action:@selector(viewFriends:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:friendsBtn];
        // add the label
    self.friendsText = [[UILabel alloc] initWithFrame:CGRectMake(70, botY + butOff, self.passedFrame.size.width, 24)];
    friendsText.font = [UIFont fontWithName:@"ProximaNovaT-Thin" size:fS];
    friendsText.textColor = Bdark;
    friendsText.text = @"Friends";
    [self.view addSubview:friendsText];
        // add the icon
    self.friendsImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"friends-12.png"]];
    friendsImg.image = [friendsImg.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    friendsImg.tintColor = Bdark;
    friendsImg.frame = CGRectMake(30, botY + butOff, 21, 21);
    [self.view addSubview:friendsImg];
    
    // settings button
    butOff = butOff + butH;
    self.setBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    setBtn.frame = CGRectMake(0, botY + butOff - butPad, self.passedFrame.size.width, butH);
    setBtn.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    [setBtn addTarget:self action:@selector(viewSettings:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:setBtn];
        // add the label
    self.setText = [[UILabel alloc] initWithFrame:CGRectMake(70, botY + butOff, self.passedFrame.size.width, 24)];
    setText.font = [UIFont fontWithName:@"ProximaNovaT-Thin" size:fS];
    setText.textColor = Bdark;
    setText.text = @"Settings";
    [self.view addSubview:setText];
        // add the icon
    self.setImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"settings-13.png"]];
    setImg.image = [setImg.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    setImg.tintColor = Bdark;
    setImg.frame = CGRectMake(30, botY + butOff, 21, 21);
    [self.view addSubview:setImg];
    
    // logout button
    butOff = butOff + butH + 5;
    if (passedFrame.size.height > 500) {
        butOff = butOff + butH;
    }
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    logoutBtn.frame = CGRectMake(0, botY + butOff, self.passedFrame.size.width, butH);
    logoutBtn.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    [logoutBtn addTarget:self action:@selector(logoutButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutBtn];
        // add the label
    UILabel *logoutText = [[UILabel alloc] initWithFrame:CGRectMake(70, botY + butOff, self.passedFrame.size.width, 24)];
    logoutText.font = [UIFont fontWithName:@"ProximaNovaT-Thin" size:fS];
    logoutText.textColor = Bdark;
    logoutText.text = @"Log Out";
    [self.view addSubview:logoutText];
        // add the icon
    UIImageView *logoutImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logout-14.png"]];
    logoutImg.image = [logoutImg.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    logoutImg.tintColor = Bdark;
    logoutImg.frame = CGRectMake(30, botY + butOff, 21, 21);
    [self.view addSubview:logoutImg];
    // add outlines
    UIView *l1 = [[UIView alloc] initWithFrame:CGRectMake(0, botY+butOff - 15, self.passedFrame.size.width, 2)];
    l1.backgroundColor = Blight;
    UIView *l2 = [[UIView alloc] initWithFrame:CGRectMake(0, botY+butOff + butH, self.passedFrame.size.width, 2)];
    l2.backgroundColor = Blight;
    [self.view addSubview:l1];
    [self.view addSubview:l2];
    
    // betchyu logo view
    UIImageView *logo   = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Betchyu_logo_gray.png"]];
    int lHt             = passedFrame.size.width > 500 ? 50 : 25;
    logo.frame          = CGRectMake(passedFrame.size.width/3, passedFrame.size.height - 14 - lHt, passedFrame.size.width/3, lHt);
    [self.view addSubview:logo];
}

- (void)tryToAddTopSectionToView:(BOOL)useless {
    if ([((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId isEqualToString:@""]) {
        // we need to wait a bit before setting up the profile pic
        [self performSelector:@selector(tryToAddTopSectionToView:) withObject:NO afterDelay:1];
        return;
    }
    
    self.top = [[FlyoutTopView alloc]initWithFrame:CGRectMake(0, 0, self.passedFrame.size.width, 5*self.passedFrame.size.height/11)];
    [self.view addSubview:top];
}

-(void) logoutButtonWasPressed:(id)sender {
    last = 0;// for highlighting dashboard
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

-(void) editProfile:(id)sender {
    // get out of the flyout menu
    self.stackViewController.leftViewControllerEnabled = YES;
    [(MTStackViewController *)((AppDelegate *)([[UIApplication sharedApplication] delegate])).window.rootViewController toggleLeftViewControllerAnimated:NO];
    self.stackViewController.leftViewControllerEnabled = NO;
    
    EditProfileVC *vc = [[EditProfileVC alloc] init];
    [((AppDelegate *)([[UIApplication sharedApplication] delegate])).navController pushViewController:vc animated:YES];
}
-(void) backToDashboard:(id)sender {
    last = 0;
    self.stackViewController.leftViewControllerEnabled = YES;
    [(MTStackViewController *)((AppDelegate *)([[UIApplication sharedApplication] delegate])).window.rootViewController toggleLeftViewControllerAnimated:YES];
    self.stackViewController.leftViewControllerEnabled = NO;
    
    [((AppDelegate *)([[UIApplication sharedApplication] delegate])).navController popToRootViewControllerAnimated:NO];
}
-(void) viewPastBets:(id)sender {
    last = 1;
    // get out of the flyout menu
    self.stackViewController.leftViewControllerEnabled = YES;
    [(MTStackViewController *)((AppDelegate *)([[UIApplication sharedApplication] delegate])).window.rootViewController toggleLeftViewControllerAnimated:NO];
    self.stackViewController.leftViewControllerEnabled = NO;
    
    PastBetsVC *vc = [[PastBetsVC alloc] init];
    vc.title = @"Past Bets";
    [((AppDelegate *)([[UIApplication sharedApplication] delegate])).navController pushViewController:vc animated:YES];
}
-(void) viewFriends:(id)sender {
    last = 2;
    // get out of the flyout menu
    self.stackViewController.leftViewControllerEnabled = YES;
    [(MTStackViewController *)((AppDelegate *)([[UIApplication sharedApplication] delegate])).window.rootViewController toggleLeftViewControllerAnimated:NO];
    self.stackViewController.leftViewControllerEnabled = NO;
    
    FriendsVC *vc = [[FriendsVC alloc] init];
    vc.title = @"Friends";
    [((AppDelegate *)([[UIApplication sharedApplication] delegate])).navController pushViewController:vc animated:YES];
}
-(void) viewSettings:(id)sender {
    last = 3;
    // get out of the flyout menu
    self.stackViewController.leftViewControllerEnabled = YES;
    [(MTStackViewController *)((AppDelegate *)([[UIApplication sharedApplication] delegate])).window.rootViewController toggleLeftViewControllerAnimated:NO];
    self.stackViewController.leftViewControllerEnabled = NO;
    
    SettingsVC *vc = [[SettingsVC alloc] init];
    vc.title = @"Settings";
    [((AppDelegate *)([[UIApplication sharedApplication] delegate])).navController pushViewController:vc animated:YES];
}

#pragma mark - MTStackViewControllerDelegate methods
- (void)stackViewController:(MTStackViewController *)stackViewController didRevealLeftViewController:(UIViewController *)viewController {
    
    UIColor *betchyu = [UIColor colorWithRed:(243/255.0) green:(116.0/255.0) blue:(67/255.0) alpha:1.0];
    UIColor *light = [UIColor colorWithRed:213.0/255 green:213.0/255 blue:214.0/255 alpha:1.0];
    UIColor *dark  = [UIColor colorWithRed:71.0/255 green:71.0/255 blue:82.0/255 alpha:1.0];
    
    [self clearAll]; // sets them all to load-blank state

    if (last == 0) {
        dashBtn.backgroundColor = light;
        [self.view bringSubviewToFront:pastBtn];[self.view bringSubviewToFront:pastImg1];[self.view bringSubviewToFront:pastText1];
        pastBtn.layer.shadowOffset = CGSizeMake(0, -4);
        pastBtn.layer.shadowColor = [dark CGColor];
        pastBtn.layer.shadowRadius = 1.0f;
        pastBtn.layer.shadowOpacity = 0.40f;
        pastBtn.layer.shadowPath = [[UIBezierPath bezierPathWithRect:pastBtn.layer.bounds] CGPath];
        pastBtn.backgroundColor = self.view.backgroundColor;
        
        [self.view bringSubviewToFront:top];[self.view bringSubviewToFront:editBtn];
        
        self.dashText.font = [UIFont fontWithName:@"ProximaNova-Regular" size:20];
        self.dashText.textColor = betchyu;
        
        dashImg.tintColor = betchyu;
    } else if (last == 1) {
        //[self.view bringSubviewToFront:dashBtn];
        pastBtn.backgroundColor = light;
        //top shadow
        [self.view bringSubviewToFront:dashBtn];[self.view bringSubviewToFront:dashText];[self.view bringSubviewToFront:dashImg];
        dashBtn.layer.shadowOffset = CGSizeMake(0, 4);
        dashBtn.layer.shadowColor = [dark CGColor];
        dashBtn.layer.shadowRadius = 1.0f;
        dashBtn.layer.shadowOpacity = 0.40f;
        dashBtn.layer.shadowPath = [[UIBezierPath bezierPathWithRect:dashBtn.layer.bounds] CGPath];
        dashBtn.backgroundColor = self.view.backgroundColor;
        // bottom shadow
        [self.view bringSubviewToFront:friendsBtn];[self.view bringSubviewToFront:friendsText];[self.view bringSubviewToFront:friendsImg];
        friendsBtn.layer.shadowOffset = CGSizeMake(0, -4);
        friendsBtn.layer.shadowColor = [dark CGColor];
        friendsBtn.layer.shadowRadius = 1.0f;
        friendsBtn.layer.shadowOpacity = 0.40f;
        friendsBtn.layer.shadowPath = [[UIBezierPath bezierPathWithRect:friendsBtn.layer.bounds] CGPath];
        friendsBtn.backgroundColor = self.view.backgroundColor;
        
        self.pastText1.font = [UIFont fontWithName:@"ProximaNova-Regular" size:20];
        self.pastText1.textColor = betchyu;
        
        pastImg1.tintColor = betchyu;
        
    } else if (last == 2) {
        //[self.view bringSubviewToFront:dashBtn];
        friendsBtn.backgroundColor = light;
        //top shadow
        [self.view bringSubviewToFront:pastBtn];[self.view bringSubviewToFront:pastText1];[self.view bringSubviewToFront:pastImg1];
        pastBtn.layer.shadowOffset = CGSizeMake(0, 4);
        pastBtn.layer.shadowColor = [dark CGColor];
        pastBtn.layer.shadowRadius = 1.0f;
        pastBtn.layer.shadowOpacity = 0.40f;
        pastBtn.layer.shadowPath = [[UIBezierPath bezierPathWithRect:pastBtn.layer.bounds] CGPath];
        pastBtn.backgroundColor = self.view.backgroundColor;
        // bottom shadow
        [self.view bringSubviewToFront:setBtn];[self.view bringSubviewToFront:setText];[self.view bringSubviewToFront:setImg];
        setBtn.layer.shadowOffset = CGSizeMake(0, -4);
        setBtn.layer.shadowColor = [dark CGColor];
        setBtn.layer.shadowRadius = 1.0f;
        setBtn.layer.shadowOpacity = 0.40f;
        setBtn.layer.shadowPath = [[UIBezierPath bezierPathWithRect:setBtn.layer.bounds] CGPath];
        setBtn.backgroundColor = self.view.backgroundColor;
        
        self.friendsText.font = [UIFont fontWithName:@"ProximaNova-Regular" size:20];
        self.friendsText.textColor = betchyu;
        
        friendsImg.tintColor = betchyu;
        
    } else if (last == 3) {
        //[self.view bringSubviewToFront:dashBtn];
        setBtn.backgroundColor = light;
        //top shadow
        [self.view bringSubviewToFront:friendsBtn];[self.view bringSubviewToFront:friendsText];[self.view bringSubviewToFront:friendsImg];
        friendsBtn.layer.shadowOffset = CGSizeMake(0, 4);
        friendsBtn.layer.shadowColor = [dark CGColor];
        friendsBtn.layer.shadowRadius = 1.0f;
        friendsBtn.layer.shadowOpacity = 0.40f;
        friendsBtn.layer.shadowPath = [[UIBezierPath bezierPathWithRect:friendsBtn.layer.bounds] CGPath];
        friendsBtn.backgroundColor = self.view.backgroundColor;
        // bottom shadow
        /*
        friendsBtn.layer.shadowOffset = CGSizeMake(0, -4);
        friendsBtn.layer.shadowColor = [dark CGColor];
        friendsBtn.layer.shadowRadius = 1.5f;
        friendsBtn.layer.shadowOpacity = 0.40f;
        friendsBtn.layer.shadowPath = [[UIBezierPath bezierPathWithRect:friendsBtn.layer.bounds] CGPath];
        friendsBtn.backgroundColor = self.view.backgroundColor;*/
        
        self.setText.font = [UIFont fontWithName:@"ProximaNova-Regular" size:20];
        self.setText.textColor = betchyu;
        
        setImg.tintColor = betchyu;
    }
}
-(void) clearAll {
    // clear last = 0, Dashboard
    dashBtn.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:0.0];//transparent
    pastBtn.layer.shadowColor = [dashBtn.backgroundColor CGColor];
    
    self.dashText.font = [UIFont fontWithName:@"ProximaNovaT-Thin" size:20];
    self.dashText.textColor = Bdark;
    
    dashImg.tintColor = Bdark;
    
    // clear Past Bets, last = 1
    pastBtn.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:0.0];//transparent
    dashBtn.layer.shadowColor = [dashBtn.backgroundColor CGColor];
    friendsBtn.layer.shadowColor = [dashBtn.backgroundColor CGColor];
    
    self.pastText1.font = [UIFont fontWithName:@"ProximaNovaT-Thin" size:20];
    self.pastText1.textColor = Bdark;
    
    pastImg1.tintColor = Bdark;
    
    // clear Friends, last = 2
    friendsBtn.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:0.0];//transparent
    pastBtn.layer.shadowColor = [dashBtn.backgroundColor CGColor];
    setBtn.layer.shadowColor = [dashBtn.backgroundColor CGColor];
    
    self.friendsText.font = [UIFont fontWithName:@"ProximaNovaT-Thin" size:20];
    self.friendsText.textColor = Bdark;
    
    friendsImg.tintColor = Bdark;
    
    // clear Settings, last = 3
    setBtn.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:0.0];//transparent
    friendsBtn.layer.shadowColor = [dashBtn.backgroundColor CGColor];
    //setBtn.layer.shadowColor = [dashBtn.backgroundColor CGColor];
    
    self.setText.font = [UIFont fontWithName:@"ProximaNovaT-Thin" size:20];
    self.setText.textColor = Bdark;
    
    setImg.tintColor = Bdark;
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
