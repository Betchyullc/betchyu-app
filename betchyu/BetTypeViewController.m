//
//  BetTypeViewController.m
//  iBetchyu
//
//  Created by Betchyu Computer on 11/20/13.
//  Copyright (c) 2013 Betchyu Computer. All rights reserved.
//

#import "BetTypeViewController.h"
#import "BetDetailsVC.h"
#import "BigButton.h"

@interface BetTypeViewController ()

-(void)setBetDetails:(id)sender;
@property (strong) NSMutableArray *betTypes;

@end

@implementation BetTypeViewController

@synthesize betTypes;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        betTypes = [[NSMutableArray alloc] init];
        [betTypes addObject:@"Lose Weight"];
        [betTypes addObject:@"Stop Smoking"];
        [betTypes addObject:@"Run More"];
        [betTypes addObject:@"Workout More"];
    }
    return self;
}

- (void) loadView {
    // Create main UIScrollView (the container for betType page buttons)
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    mainView.contentSize   = CGSizeMake(320, 1000);
    [mainView setBackgroundColor:[UIColor colorWithRed:(39/255.0) green:(37/255.0) blue:(37/255.0) alpha:1.0]];
    
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    //CGRect screenRect = self.view.frame;
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height - 50; // 50 px is the navbar at the top + 10 px bottom border
    
    // Make the Buttons list
    for (int i = 0; i < betTypes.count; i++) {
        BigButton *button = [[BigButton alloc] initWithFrame:CGRectMake(20, ((screenHeight/4)*i +10), (screenWidth - 40), (screenHeight / 4) -10)
                                                     primary:1
                                                       title:[betTypes objectAtIndex:i]];
        UIImage *btnImg = [UIImage imageNamed:[[betTypes objectAtIndex:i] stringByAppendingString:@".jpg"]];
        
        [button setBackgroundImage:btnImg forState:UIControlStateNormal];
        [button addTarget:self
                   action:@selector(setBetDetails:)
         forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:button];
    }
    
    self.view       = mainView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setBetDetails:(id)sender {
    NSString *verb = ((BigButton *)sender).currentTitle;
    BetDetailsVC *vc =[[BetDetailsVC alloc] initWithBetVerb:verb];
    vc.title = verb;
    
    [self.navigationController pushViewController:vc animated:true];
}

@end
