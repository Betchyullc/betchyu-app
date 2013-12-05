//
//  BetStakeVC.m
//  iBetchyu
//
//  Created by Betchyu Computer on 11/24/13.
//  Copyright (c) 2013 Betchyu Computer. All rights reserved.
//

#import "BetStakeVC.h"
#import "BetStakeConfirmVC.h"

@interface BetStakeVC ()

@end

@implementation BetStakeVC

@synthesize stakes;
@synthesize stakeImageHeight;
@synthesize bet;

- (id)initWithBet:(TempBet *)betObj {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        stakes = [[NSArray alloc] initWithObjects:@"Beer", @"Amazon", nil];
        stakeImageHeight = 220;
        
        bet = betObj;
    }
    return self;
}

- (void) loadView {
    // Create main UIScrollView (the container for what follows)
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    mainView.contentSize   = CGSizeMake(320, 1000);
    [mainView setBackgroundColor:[UIColor darkGrayColor]];
    
    // code
    for (int i = 0; i < stakes.count; i++) {
        UIImageView *stakePic = [[UIImageView alloc] initWithImage:
                                 [UIImage imageNamed:
                                  [[stakes objectAtIndex:i] stringByAppendingString:@".jpg"]]];
        stakePic.frame = CGRectMake(20, (i*(stakeImageHeight+20))+20, 280, stakeImageHeight);
        stakePic.userInteractionEnabled = YES;
        UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stakeTapped:)];
        [stakePic addGestureRecognizer:gr];
        [mainView addSubview:stakePic];

    }
    
    
    // add the UIScrollView we've been compiling to the actual screen.
    self.view = mainView;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) stakeTapped:(UITapGestureRecognizer *)sender{
    int i                 = (((UIImageView *)sender.view).frame.origin.y - 20)
                                /(stakeImageHeight+20);
    bet.opponentStakeType = [stakes objectAtIndex:i];
    bet.ownStakeType      = [stakes objectAtIndex:i];
    BetStakeConfirmVC *vc = [[BetStakeConfirmVC alloc] initWithBet:bet];
    vc.title = @"Confirm Stake";
    
    [self.navigationController pushViewController:vc animated:true];
}

@end
