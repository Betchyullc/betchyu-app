//
//  BetStakeConfirmVC.m
//  iBetchyu
//
//  Created by Betchyu Computer on 11/24/13.
//  Copyright (c) 2013 Betchyu Computer. All rights reserved.
//

#import "BetStakeConfirmVC.h"
#import "BigButton.h"
#import "BetFinalizeVC.h"

@interface BetStakeConfirmVC ()

@end

@implementation BetStakeConfirmVC

@synthesize stakeLabel;
@synthesize verboseLabel;
@synthesize stakeImageHeight;
@synthesize bet;
@synthesize currentStake;
@synthesize fbFriendVC;

- (id)initWithBet:(TempBet *)betObj {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        stakeImageHeight = 280;
        bet = betObj;
    }
    return self;
}

- (void) loadView {
    // Create main UIScrollView (the container for what follows)
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    mainView.contentSize   = CGSizeMake(320, 1000);
    [mainView setBackgroundColor:[UIColor colorWithRed:(39/255.0) green:(37/255.0) blue:(37/255.0) alpha:1.0]];
    
    /////////////////////
    // Stake Amount UI //
    /////////////////////
    UIImageView *stakePic = [[UIImageView alloc] initWithImage:
                             [UIImage imageNamed:
                              [bet.ownStakeType stringByAppendingString:@".jpg"]]];
    stakePic.frame = CGRectMake(0, 0, 320, stakeImageHeight);
    
    UIButton *up = [[UIButton alloc] initWithFrame:CGRectMake(130, 20, 50, 50)];
    [up setTitle:@"+" forState:UIControlStateNormal];
    [up addTarget:self action:@selector(increaseStake:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *dwn = [[UIButton alloc] initWithFrame:CGRectMake(130, 180, 50, 50)];
    [dwn setTitle:@"-" forState:UIControlStateNormal];
    [dwn addTarget:self action:@selector(lowerStake:) forControlEvents:UIControlEventTouchUpInside];
    
    stakeLabel               = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, 320, 70)];
    stakeLabel.textAlignment = NSTextAlignmentCenter;
    stakeLabel.textColor     = [UIColor whiteColor];
    
    [mainView addSubview:stakePic];
    [mainView addSubview:up];
    [mainView addSubview:dwn];
    [mainView addSubview:stakeLabel];
    
    verboseLabel               = [[UILabel alloc] initWithFrame:CGRectMake(10, 270, 300, 80)];
    verboseLabel.numberOfLines = 0;
    verboseLabel.textColor     = [UIColor whiteColor];
    [self updateLabels];
    [mainView addSubview:verboseLabel];
    
    /////////////////
    // Next Button //
    /////////////////
    BigButton *nextBtn = [[BigButton alloc] initWithFrame:CGRectMake(20, 380, 280, 100)
                                                  primary:0
                                                    title:@"Set Stake"];
    [nextBtn addTarget:self
                action:@selector(setBetStake:)
      forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:nextBtn];
    
    
    // add the UIScrollView we've been compiling to the actual screen.
    self.view = mainView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Move on to selecting their friend
-(void)setBetStake:(id)sender {
    if (!fbFriendVC) {
        fbFriendVC = [[FBFriendPickerViewController alloc] initWithNibName:nil bundle:nil];
        // Set the friend picker delegate
        fbFriendVC.delegate = self;
        
        fbFriendVC.title = @"Select friends";
    }
    
    [fbFriendVC loadData];
    [self.navigationController pushViewController:fbFriendVC animated:true];
}
-(void)increaseStake:(id)sender {
    currentStake++;
    [self updateLabels];
}
-(void)lowerStake:(id)sender {
    currentStake--;
    [self updateLabels];
}

- (void) updateLabels {
    stakeLabel.text = [[[@(currentStake) stringValue] stringByAppendingString:@" "] stringByAppendingString:bet.ownStakeType];
    verboseLabel.text = [@"If I successfully complete my challenge, you owe me " stringByAppendingString:stakeLabel.text];
    bet.ownStakeAmount = [NSNumber numberWithInt:currentStake];
    bet.opponentStakeAmount = bet.ownStakeAmount;
}

- (void)friendPickerViewControllerSelectionDidChange:(FBFriendPickerViewController *)friendPicker {
    bet.friends = friendPicker.selection;
}

// handles the user touching the done button on the FB friend selector
- (void)facebookViewControllerDoneWasPressed:(id)sender {
    BetFinalizeVC *vc = [[BetFinalizeVC alloc] initWithBet:bet];
    vc.title = @"Finalize Goal";
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
