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

@implementation SettingsVC

@synthesize pagesForHowItWorks;

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
        self.screenName = @"Settings";
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
    
    // FAQ
    yOff = yOff + rH;
    UIButton *faq = [[UIButton alloc] initWithFrame:CGRectMake(0, yOff, f2.size.width, rH)];
    [faq addTarget:self action:@selector(faqPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:faq];
    
    // Analytics optout
    yOff = yOff + rH;
    UISwitch *analytics = [[UISwitch alloc] initWithFrame:CGRectMake(f2.size.width - 60, yOff+5, 40, rH-10)];
    analytics.on = ![GAI sharedInstance].optOut;
    analytics.tintColor = [UIColor whiteColor];
    [analytics addTarget:self action:@selector(setAnalytics:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:analytics];
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
    
    // TRACK THIS SHIT AND ANALYZE IT
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker set:kGAIScreenName value:@"Flyout Menu"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}
-(void)createGoal:(id)sender {
    //if (!self.canLeavePage) { return; }
    // change to the correct view
    CreateBetVC *createGoalController = [[CreateBetVC alloc] initWithStyle:UITableViewStylePlain];
    createGoalController.title = @"Create Bet";
    [self.navigationController pushViewController:createGoalController animated:true];
    
    // TRACK THIS SHIT AND ANALYZE IT
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker set:kGAIScreenName value:@"Create Bet"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

-(void)editProfile:(id)sender {
    EditProfileVC *vc = [[EditProfileVC alloc] init];
    [((AppDelegate *)([[UIApplication sharedApplication] delegate])).navController pushViewController:vc animated:YES];
}
-(void)editPayment:(id)sender {
    UIViewController *vc = [UIViewController new];
    CGRect f = [UIScreen mainScreen].applicationFrame;
    
    int y = self.navigationController.navigationBar.frame.size.height + f.origin.y; // navBar + statusBar
    int h = f.size.height - y;
    
    CGRect f2 = CGRectMake(f.origin.x, y, f.size.width, 2*h/3);
    
    vc.view = [UIView new];
    vc.view.backgroundColor = Blight;
    [vc.view addSubview:[[CardInfoView alloc] initWithFrame:f2]];
    
    [((AppDelegate *)([[UIApplication sharedApplication] delegate])).navController pushViewController:vc animated:YES];
}

-(void) howItWorksPressed:(id)sender {
    // TRACK THIS SHIT AND ANALYZE IT MANUALLY, b/c it'd do one for each page otherwise, and that's overkill
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker set:kGAIScreenName value:@"How It Works"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    // actually show the thing
    UIPageViewController *pvc = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    pvc.dataSource = self;
    pvc.view.frame = self.view.frame;
    
    self.pagesForHowItWorks = @[[HowItWorksVC new],[HowItWorksVC new],[HowItWorksVC new],[HowItWorksVC new],[HowItWorksVC new],[HowItWorksVC new],[HowItWorksVC new],[HowItWorksVC new]];
    ((HowItWorksVC *)[self.pagesForHowItWorks objectAtIndex:0]).index = 0;
    ((HowItWorksVC *)[self.pagesForHowItWorks objectAtIndex:1]).index = 1;
    ((HowItWorksVC *)[self.pagesForHowItWorks objectAtIndex:2]).index = 2;
    ((HowItWorksVC *)[self.pagesForHowItWorks objectAtIndex:3]).index = 3;
    ((HowItWorksVC *)[self.pagesForHowItWorks objectAtIndex:4]).index = 4;
    ((HowItWorksVC *)[self.pagesForHowItWorks objectAtIndex:5]).index = 5;
    ((HowItWorksVC *)[self.pagesForHowItWorks objectAtIndex:6]).index = 6;
    ((HowItWorksVC *)[self.pagesForHowItWorks objectAtIndex:7]).index = 7;
    NSArray *viewControllers = [NSArray arrayWithObject:[self.pagesForHowItWorks objectAtIndex:0]];
    
    [pvc setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    AppDelegate *app =(AppDelegate *)([[UIApplication sharedApplication] delegate]);
    
    [app.window setRootViewController:pvc];
    [app.window makeKeyAndVisible];
}
-(void) aboutUsPressed:(id)sender {
    [self setupAndShow:[[AboutUs alloc] initWithFrame:self.view.frame AndOwner:self] WithTitle:@"About Us"];
}
-(void) feedbackPressed:(id)sender {
    [self setupAndShow:[[Feedback alloc] initWithFrame:self.view.frame AndOwner:self] WithTitle:@"Feedback"];
}
-(void) faqPressed:(id)sender {
    [self setupAndShow:[[FrequentlyAskedQuestionsView alloc] initWithFrame:self.view.frame] WithTitle:@"FAQ"];
}
-(void) setAnalytics:(UISwitch *)sender {
    AppDelegate * app = ((AppDelegate *)([[UIApplication sharedApplication] delegate]));
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                    app.ownId,                      @"fb_id",
                                    app.token,                      @"device",
                                    sender.on ? @"true" : @"false", @"allow_analytics", nil];
    [[API sharedInstance] post:@"user" withParams:params onCompletion:^(NSDictionary *json) {
        // do nothing
    }];
}

// helper method
-(void) setupAndShow:(UIView *)v WithTitle:(NSString *)text{
    GAITrackedViewController *vc =[[GAITrackedViewController alloc] init];
    vc.view = v;
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.title = text;
    vc.screenName = text;
    
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
    
    return [self.pagesForHowItWorks objectAtIndex:index];
    
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
