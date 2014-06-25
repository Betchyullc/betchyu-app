//
//  SettingsVC.m
//  betchyu
//
//  Created by Adam Baratz on 6/11/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import "SettingsVC.h"
#import "EditProfileVC.h"
#import "Feedback.h"
#import "AboutUs.h"
#import "HowItWorksVC.h"

@interface SettingsVC ()

@end

@implementation SettingsVC

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
    self.view = [[SettingsView alloc]initWithFrame:f2];
    
    int rH = 43;
    int yOff = 64;
    // profile button
    UIButton *prof = [[UIButton alloc] initWithFrame:CGRectMake(0, yOff, f2.size.width, rH)];
    [prof addTarget:self action:@selector(editProfile:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:prof];
    
    // payment button
    yOff = yOff + rH;
    UIButton *pay = [[UIButton alloc] initWithFrame:CGRectMake(0, yOff, f2.size.width, rH)];
    [pay addTarget:self action:@selector(editPayment:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pay];
    
    // how it works
    yOff = yOff + rH;
    UIButton *how = [[UIButton alloc] initWithFrame:CGRectMake(0, yOff, f2.size.width, rH)];
    [how addTarget:self action:@selector(howItWorksPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:how];
    
    // feedback
    yOff = yOff + rH;
    UIButton *feed = [[UIButton alloc] initWithFrame:CGRectMake(0, yOff, f2.size.width, rH)];
    [feed addTarget:self action:@selector(feedbackPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:feed];
    
    // about us
    yOff = yOff + rH;
    UIButton *about = [[UIButton alloc] initWithFrame:CGRectMake(0, yOff, f2.size.width, rH)];
    [about addTarget:self action:@selector(aboutUsPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:about];
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

-(void)editProfile:(id)sender {
    EditProfileVC *vc = [[EditProfileVC alloc] init];
    [((AppDelegate *)([[UIApplication sharedApplication] delegate])).navController pushViewController:vc animated:YES];
}
-(void)editPayment:(id)sender {
    
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
    vc.view = [[AboutUs alloc] initWithFrame:self.view.frame AndOwner:self];
    vc.title = @"About Us";
    // Show it.
    [self.navigationController pushViewController:vc animated:true];
}
-(void) feedbackPressed:(id)sender {
    UIViewController *vc =[[UIViewController alloc] init];
    vc.view = [[Feedback alloc] initWithFrame:self.view.frame AndOwner:self];
    vc.title = @"Feedback";
    // Show it.
    [self.navigationController pushViewController:vc animated:true];
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
    
    if (index == 8) {
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
    return 8;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}

@end
