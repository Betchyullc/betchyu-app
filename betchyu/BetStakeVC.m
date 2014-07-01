//
//  BetStakeVC.m
//  iBetchyu
//
//  Created by Betchyu Computer on 11/24/13.
//  Copyright (c) 2013 Betchyu Computer. All rights reserved.
//

#import "BetStakeVC.h"
#import "StakeDetailsVC.h"

@interface BetStakeVC ()

@end

@implementation BetStakeVC

@synthesize stakes;
@synthesize stakeImageHeight;
@synthesize bet;

- (id)initWithBet:(TempBet *)betObj {
    self = [super init];
    if (self) {
        self.screenName = @"Bet Stake (step 3)";
        // Custom initialization
        stakes = [[NSArray alloc] initWithObjects:/*@"Drink", @"Meal",*/@"Target Gift Card", @"Amazon Gift Card", @"iTunes Gift Card", nil];
        stakeImageHeight = 70;
        
        bet = betObj;
        
        // remove the "Set Stake" from the back button on following pages
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    }
    return self;
}

- (void) loadView {
    // Create main UIScrollView (the container for what follows)
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    int h = mainView.frame.size.height;
    int w = mainView.frame.size.width;
    int topHeight = w>500 ? 320 : 180;
    
    //self.stakeImageHeight = 0.78 * w;
    mainView.contentSize   = CGSizeMake(w, topHeight + 36 + ((stakeImageHeight)*stakes.count));
    [mainView setBackgroundColor:Blight];
    
    BetOptionsTopView *top = [[BetOptionsTopView alloc] initWithFrame:CGRectMake(0, 0, w, topHeight) AndBetName:[NSString stringWithFormat:@"%@ %@",bet.verb, bet.noun]];
    top.textLabel.text = [self getBetDescription];
    [mainView addSubview:top];
    
    UILabel *msg = [[UILabel alloc] initWithFrame:CGRectMake(0, topHeight, w, 36)];
    msg.backgroundColor = [UIColor whiteColor];
    msg.textColor = Borange;
    msg.text = @"\tThe stake is a:";
    msg.font = [UIFont fontWithName:@"ProximaNova-Regular" size:20];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, msg.frame.size.height-2, w, 2)];
    line.backgroundColor = Bmid;
    [msg addSubview:line];
    [mainView addSubview:msg];
    
    for (int i = 0; i < stakes.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, (i*(stakeImageHeight)) +(topHeight + 36) - i, w, stakeImageHeight)];
        btn.backgroundColor = [UIColor whiteColor];
        
        // add giftcard img
        UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[[stakes objectAtIndex:i] stringByAppendingString:@".jpg"]]];
        img.frame = CGRectMake(10, 10, stakeImageHeight-20, stakeImageHeight-20);
        img.layer.cornerRadius = (stakeImageHeight-20)/2;
        img.layer.masksToBounds = YES;
        img.layer.borderColor = [Borange CGColor];
        img.layer.borderWidth = 2;
        [btn addSubview:img];
        
        // add arrow to btn
        UIImageView * arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow-16.png"]];
        arrow.frame = CGRectMake(w - 22, 18, 10, 24);
        arrow.image = [arrow.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        arrow.tintColor = Bmid;
        [btn addSubview:arrow];
        
        // set button properties
        [btn addTarget:self action:@selector(stakeTapped:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:[stakes objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitle:[stakes objectAtIndex:i] forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:20];
        [btn setTitleColor:Bmid forState:UIControlStateSelected];
        [btn setTitleColor:Bmid forState:UIControlStateNormal];
        [btn setTitleColor:Bmid forState:UIControlStateHighlighted];
        [btn setTitleColor:Bmid forState:UIControlStateReserved];
        btn.tintColor = Bmid;
        btn.tag = i;
        
        // add shadow to btn
        btn.layer.shadowColor   = [Bdark CGColor];
        btn.layer.shadowOffset  = CGSizeMake(0, 4);
        btn.layer.shadowOpacity = 0.9f;
        btn.layer.shadowRadius  = 3.0f;
        btn.layer.shadowPath    = [[UIBezierPath bezierPathWithRect:btn.layer.bounds] CGPath];
        
        [mainView addSubview:btn];
    }
    
    // add the UIScrollView we've been compiling to the actual screen.
    self.view = mainView;
}

- (void) stakeTapped:(UIButton *)sender {
    bet.stakeType      = [stakes objectAtIndex:sender.tag];
    StakeDetailsVC *vc = [[StakeDetailsVC alloc] initWithBet:bet];
    vc.title = @"Stake Details";
    
    [self.navigationController pushViewController:vc animated:true];
}

-(NSString *) getBetDescription {
    if ([bet.verb isEqualToString:@"Stop"]) {
        return [NSString stringWithFormat:@"I will %@ %@ for %@ days",bet.verb, bet.noun, bet.duration];
    }
    return [NSString stringWithFormat:@"I will %@ %@ %@ in %@ days",bet.verb, bet.amount, bet.noun, bet.duration];
}
@end
