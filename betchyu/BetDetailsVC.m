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
@synthesize betchyuOrange;

- (id)initWithBetVerb:(NSString *)verbName {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        bet = [TempBet new];
        bet.betVerb = [[verbName componentsSeparatedByString:@" "] objectAtIndex:0]; //first word passed
        bet.betNoun = [[verbName componentsSeparatedByString:@" "] objectAtIndex:1]; // second word
        if ([bet.betNoun isEqualToString:@"Weight"]) {
            bet.betNoun = @"pounds";
        } else if ([bet.betNoun isEqualToString:@"More"]){
            if ([bet.betVerb isEqualToString:@"Workout"]) {
                bet.betNoun = @"times";
            } else {
                bet.betNoun = @"miles";
            }
        }
        
        // useful variable
        self.betchyuOrange = [UIColor colorWithRed:1.0 green:(117.0/255.0) blue:(63/255.0) alpha:1.0];
    }
    return self;
}

- (void) loadView {
    // Create main UIScrollView (the container for what follows)
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    mainView.contentSize   = CGSizeMake(320, 1000);
    [mainView setBackgroundColor:[UIColor colorWithRed:(39/255.0) green:(37/255.0) blue:(37/255.0) alpha:1.0]];
    
    if ([bet.betNoun isEqualToString:@"Smoking"]){
        mainView = [self loadSingleDetailsHandler:mainView];
    } else {
        mainView = [self loadGenericDetailsHandler:mainView];
    }
    
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

-(UIScrollView *)loadSingleDetailsHandler:(UIScrollView *)mainView {
    ////////////////////////
    // Only selector stuff //
    ////////////////////////
    // The label indicating what the user is selecting
    UILabel *label1     = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 200)];
    label1.text         = [[@"I WILL " stringByAppendingString:[[[bet.betVerb uppercaseString] stringByAppendingString:@" "] stringByAppendingString:[bet.betNoun uppercaseString]]] stringByAppendingString:@" FOR:"];
    label1.textColor    = [UIColor whiteColor];
    label1.textAlignment= NSTextAlignmentCenter;
    label1.font = [UIFont fontWithName:@"ProximaNova-Black" size:35];
    label1.lineBreakMode = UILineBreakModeWordWrap;
    label1.numberOfLines = 0;
    [mainView addSubview:label1];
    
    /*// The slider the user uses to select values
    UISlider *slider1   = [[UISlider alloc] initWithFrame:CGRectMake(20, 80, 280, 70)];
    [slider1 setMinimumTrackTintColor:betchyuOrange];
    [slider1 addTarget:self
                action:@selector(updateSlider1Value:)
      forControlEvents:UIControlEventValueChanged];
    [mainView addSubview:slider1];
    
    // the label indicating the slider's value
    detailLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 130, 280, 100)];
    detailLabel1.textColor = betchyuOrange;
    detailLabel1.textAlignment = NSTextAlignmentCenter;
    detailLabel1.font = [UIFont fontWithName:@"ProximaNova-Black" size:35];
    [mainView addSubview:detailLabel1];*/
    
    ///////////////////////////
    // Bottom Selector stuff //
    ///////////////////////////
    // The label indicating what the user is selecting
    /*UILabel *label2     = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 280, 100)];
    label2.text         = @"FOR:";
    label2.textColor    = [UIColor whiteColor];
    label2.textAlignment= NSTextAlignmentCenter;
    label2.font = [UIFont fontWithName:@"ProximaNova-Black" size:35];
    [mainView addSubview:label2];*/
    
    // The slider the user uses to select values
    UISlider *slider2   = [[UISlider alloc] initWithFrame:CGRectMake(20, 200, 280, 70)];
    [slider2 setMinimumTrackTintColor:betchyuOrange];
    [slider2 addTarget:self
                action:@selector(updateSlider2Value:)
      forControlEvents:UIControlEventValueChanged];
    [mainView addSubview:slider2];
    
    // the label indicating the slider's value
    detailLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 250, 280, 100)];
    detailLabel2.textColor = betchyuOrange;
    detailLabel2.textAlignment = NSTextAlignmentCenter;
    detailLabel2.font = [UIFont fontWithName:@"ProximaNova-Black" size:35];
    [mainView addSubview:detailLabel2];

    ////////
    // Fake the first label details, because we arent showing it
    ////////
    detailLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 130, 280, 100)];
    int amount = 0;
    bet.betAmount = [NSNumber numberWithInt:amount];
    detailLabel1.text = [[@(amount) stringValue] stringByAppendingString:[@" " stringByAppendingString:bet.betNoun]];
    
    return mainView;
}

-(UIScrollView *)loadGenericDetailsHandler:(UIScrollView *)mainView {
    ////////////////////////
    // Top selector stuff //
    ////////////////////////
    // The label indicating what the user is selecting
    UILabel *label1     = [[UILabel alloc] initWithFrame:CGRectMake(00, 20, 320, 100)];
    label1.text         = [[@"I WILL " stringByAppendingString:[bet.betVerb uppercaseString]] stringByAppendingString:@":"];
    label1.textColor    = [UIColor whiteColor];
    label1.textAlignment= NSTextAlignmentCenter;
    label1.font = [UIFont fontWithName:@"ProximaNova-Black" size:30];
    [mainView addSubview:label1];
    
    // The slider the user uses to select values
    UISlider *slider1   = [[UISlider alloc] initWithFrame:CGRectMake(20, 80, 280, 70)];
    [slider1 setMinimumTrackTintColor:betchyuOrange];
    [slider1 addTarget:self
                action:@selector(updateSlider1Value:)
      forControlEvents:UIControlEventValueChanged];
    [mainView addSubview:slider1];
    
    // the label indicating the slider's value
    detailLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 130, 280, 100)];
    detailLabel1.textColor = betchyuOrange;
    detailLabel1.textAlignment = NSTextAlignmentCenter;
    detailLabel1.font = [UIFont fontWithName:@"ProximaNova-Black" size:35];
    [mainView addSubview:detailLabel1];
    
    ///////////////////////////
    // Bottom Selector stuff //
    ///////////////////////////
    // The label indicating what the user is selecting
    UILabel *label2     = [[UILabel alloc] initWithFrame:CGRectMake(20, 220, 280, 100)];
    label2.text         = @"IN:";
    label2.textColor    = [UIColor whiteColor];
    label2.textAlignment= NSTextAlignmentCenter;
    label2.font = [UIFont fontWithName:@"ProximaNova-Black" size:35];
    [mainView addSubview:label2];
    
    // The slider the user uses to select values
    UISlider *slider2   = [[UISlider alloc] initWithFrame:CGRectMake(20, 280, 280, 70)];
    [slider2 setMinimumTrackTintColor:betchyuOrange];
    [slider2 addTarget:self
                action:@selector(updateSlider2Value:)
      forControlEvents:UIControlEventValueChanged];
    [mainView addSubview:slider2];
    
    // the label indicating the slider's value
    detailLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 330, 280, 100)];
    detailLabel2.textColor = betchyuOrange;
    detailLabel2.textAlignment = NSTextAlignmentCenter;
    detailLabel2.font = [UIFont fontWithName:@"ProximaNova-Black" size:35];
    [mainView addSubview:detailLabel2];
    
    return mainView;
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
    int amount;
    if ([bet.betVerb isEqualToString:@"Run"]) {
        amount = (int)((((UISlider *)sender).value)*199)+1;
    } else if ([bet.betVerb isEqualToString:@"Lose"]) {
        amount = (int)((((UISlider *)sender).value)*19)+1;
    } else if ([bet.betVerb isEqualToString:@"Workout"]) {
        amount = (int)((((UISlider *)sender).value)*59)+1;
    } else {
        amount = (int)((((UISlider *)sender).value)*10);
    }
    
    bet.betAmount = [NSNumber numberWithInt:amount];
    detailLabel1.text = [NSString stringWithFormat:@"%i %@", amount, bet.betNoun];
}
- (void) updateSlider2Value:(id)sender {
    int days = (int)((((UISlider *)sender).value)*29)+1;
    bet.endDate = [[NSDate alloc] initWithTimeIntervalSinceNow:(days*24*60*60)];
    detailLabel2.text = [[@(days) stringValue] stringByAppendingString:@" days"];
}

- (void) setBetStake:(id)sender{
    // If user has not selected bet Details...
    if ([detailLabel1.text length] == 0 || [detailLabel2.text length] == 0) {
        // Show warning message
        [[[UIAlertView alloc] initWithTitle: @"Wait!"
                                    message: @"I think you forgot to define your bet..."
                                   delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        
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
