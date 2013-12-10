//
//  BetDetailsVC.m
//  iBetchyu
//
//  Created by Betchyu Computer on 11/20/13.
//  Copyright (c) 2013 Betchyu Computer. All rights reserved.
//

#import "BetDetailsVC.h"
#import "BetStakeVC.h"
#import "BigButton.h"

@interface BetDetailsVC ()

@end

@implementation BetDetailsVC

@synthesize bet;
@synthesize detailLabel1;
@synthesize detailLabel2;

- (id)initWithBetVerb:(NSString *)verbName {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        bet = [TempBet new];
        bet.betVerb = [[verbName componentsSeparatedByString:@" "] objectAtIndex:0]; //first word passed
        bet.betNoun = [[verbName componentsSeparatedByString:@" "] objectAtIndex:1]; // second word
        if ([bet.betNoun isEqualToString:@"Weight"]) {
            bet.betNoun = @"pounds";
        } else if ([bet.betNoun isEqualToString:@"Smoking"]){
            bet.betNoun = @"cigarettes";
        } else if ([bet.betNoun isEqualToString:@"More"]){
            if ([bet.betVerb isEqualToString:@"Workout"]) {
                bet.betNoun = @"times";
            } else {
                bet.betNoun = @"miles";
            }
        }
    }
    return self;
}

- (void) loadView {
    // useful variables
    UIColor *bethcyuOrange =[UIColor colorWithRed:1.0 green:(117.0/255.0) blue:(63/255.0) alpha:1.0];
    // Create main UIScrollView (the container for what follows)
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    mainView.contentSize   = CGSizeMake(320, 1000);
    [mainView setBackgroundColor:[UIColor colorWithRed:(39/255.0) green:(37/255.0) blue:(37/255.0) alpha:1.0]];
    
    ////////////////////////
    // Top selector stuff //
    ////////////////////////
    // The label indicating what the user is selecting
    UILabel *label1     = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 100)];
    label1.text         = [[@"I bet I can " stringByAppendingString:bet.betVerb] stringByAppendingString:@":"];
    label1.textColor    = [UIColor whiteColor];
    label1.textAlignment= NSTextAlignmentCenter;
    [mainView addSubview:label1];
    
    // The slider the user uses to select values
    UISlider *slider1   = [[UISlider alloc] initWithFrame:CGRectMake(20, 80, 280, 70)];
    [slider1 setMinimumTrackTintColor:bethcyuOrange];
    [slider1 addTarget:self
                action:@selector(updateSlider1Value:)
      forControlEvents:UIControlEventValueChanged];
    [mainView addSubview:slider1];
    
    // the label indicating the slider's value
    detailLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 130, 280, 100)];
    detailLabel1.textColor = bethcyuOrange;
    detailLabel1.textAlignment = NSTextAlignmentCenter;
    [mainView addSubview:detailLabel1];
    
    ///////////////////////////
    // Bottom Selector stuff //
    ///////////////////////////
    // The label indicating what the user is selecting
    UILabel *label2     = [[UILabel alloc] initWithFrame:CGRectMake(20, 220, 280, 100)];
    label2.text         = @"In:";
    label2.textColor    = [UIColor whiteColor];
    label2.textAlignment= NSTextAlignmentCenter;
    [mainView addSubview:label2];
    
    // The slider the user uses to select values
    UISlider *slider2   = [[UISlider alloc] initWithFrame:CGRectMake(20, 280, 280, 70)];
    [slider2 setMinimumTrackTintColor:bethcyuOrange];
    [slider2 addTarget:self
                action:@selector(updateSlider2Value:)
      forControlEvents:UIControlEventValueChanged];
    [mainView addSubview:slider2];
    
    // the label indicating the slider's value
    detailLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 330, 280, 100)];
    detailLabel2.textColor = bethcyuOrange;
    detailLabel2.textAlignment = NSTextAlignmentCenter;
    [mainView addSubview:detailLabel2];
    
    /////////////////
    // Next Button //
    /////////////////
    BigButton *nextBtn = [[BigButton alloc] initWithFrame:CGRectMake(20, 400, 280, 100)
                                                  primary:0
                                                    title:@"Next"];
    [nextBtn addTarget:self
               action:@selector(setBetStake:)
     forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:nextBtn];
    
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

- (void) updateSlider1Value:(id)sender {
    int amount = (int)((((UISlider *)sender).value)*10);
    bet.betAmount = [NSNumber numberWithInt:amount];
    detailLabel1.text = [[@(amount) stringValue] stringByAppendingString:[@" " stringByAppendingString:bet.betNoun]];
}
- (void) updateSlider2Value:(id)sender {
    int days = (int)((((UISlider *)sender).value)*10);
    bet.endDate = [[NSDate alloc] initWithTimeIntervalSinceNow:(days*24*60*60)];
    detailLabel2.text = [[@(days) stringValue] stringByAppendingString:@" days"];
}

- (void) setBetStake:(id)sender{
    // If user has not selected bet Details...
    if ([detailLabel1.text length] == 0 && [detailLabel2.text length] == 0) {
        // Show warning message
        // TODO
        
        // and bail from the method
        return;
    }
    // Make the next view
    BetStakeVC *vc =[[BetStakeVC alloc] initWithBet:bet];
    vc.title = @"Set Stake";
    // Show it.
    [self.navigationController pushViewController:vc animated:true];
}
@end
