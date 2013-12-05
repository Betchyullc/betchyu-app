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
        [betTypes addObject:@"Save Money"];
        [betTypes addObject:@"Run More"];
        [betTypes addObject:@"Eat Less"];
        [betTypes addObject:@"Workout More"];
    }
    return self;
}

- (void) loadView {
    // Create main UIScrollView (the container for betType page buttons)
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    mainView.contentSize   = CGSizeMake(320, 1000);
    [mainView setBackgroundColor:[UIColor darkGrayColor]];
    
    // Make the Buttons list
    for (int i = 0; i < betTypes.count; i++) {
        BigButton *button = [[BigButton alloc] initWithFrame:CGRectMake(20, (20 + i*140), 280, 100)
                                                     primary:1
                                                       title:[betTypes objectAtIndex:i]];
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
