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
@synthesize weightInput;

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
    int h = mainView.frame.size.height- 40;
    int w = mainView.frame.size.width;
    mainView.contentSize = CGSizeMake(w, h);
    [mainView setBackgroundColor:[UIColor colorWithRed:(39/255.0) green:(37/255.0) blue:(37/255.0) alpha:1.0]];
    
    if ([bet.betNoun isEqualToString:@"Smoking"]){
        mainView = [self loadSingleDetailsHandler:mainView];
    } else if ([bet.betNoun isEqualToString:@"pounds"]) {
        mainView.contentSize = CGSizeMake(w, h+(h/9));  // the weight specific view needs more content than just one screen.
        mainView = [self loadWeightDetailsHandler:mainView]; // it's special.
    } else {
        mainView = [self loadGenericDetailsHandler:mainView];
    }
    
    /////////////////
    // Next Button //
    /////////////////
    BigButton *nextBtn;
    if ([bet.betNoun isEqualToString:@"Smoking"]) {
        nextBtn = [[BigButton alloc] initWithFrame:CGRectMake(20, h - (h/4), w-40, h/4.2) primary:0 title:@"Next"];
    } else if ([bet.betNoun isEqualToString:@"pounds"]){
        nextBtn = [[BigButton alloc] initWithFrame:CGRectMake(20, ((h/12)+20)+(7*h/9)-20, w-40, 2*h/9) primary:0 title:@"Next"];
    } else {
        nextBtn = [[BigButton alloc] initWithFrame:CGRectMake(20, (7*h/9)-20, w-40, 2*h/9) primary:0 title:@"Next"];
    }
    [nextBtn addTarget:self
               action:@selector(setBetStake:)
     forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:nextBtn];
    
    self.view = mainView;
}

-(UIScrollView *)loadSingleDetailsHandler:(UIScrollView *)mainView {
    int h = mainView.frame.size.height;
    int w = mainView.frame.size.width;
    ////////////////////////
    // Only selector stuff //
    ////////////////////////
    // The label indicating what the user is selecting
    UILabel *label1     = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, w-40, h/4)];
    label1.text         = [[@"I WILL " stringByAppendingString:[[[bet.betVerb uppercaseString] stringByAppendingString:@" "] stringByAppendingString:[bet.betNoun uppercaseString]]] stringByAppendingString:@" FOR:"];
    label1.textColor    = [UIColor whiteColor];
    label1.textAlignment= NSTextAlignmentCenter;
    label1.font = [UIFont fontWithName:@"ProximaNova-Black" size:35];
    label1.lineBreakMode = NSLineBreakByWordWrapping;
    label1.numberOfLines = 0;
    [mainView addSubview:label1];
    
    // The slider the user uses to select values
    UISlider *slider2   = [[UISlider alloc] initWithFrame:CGRectMake(20, h/4, w-40, h/5)];
    [slider2 setMinimumTrackTintColor:betchyuOrange];
    [slider2 addTarget:self
                action:@selector(updateSlider2Value:)
      forControlEvents:UIControlEventValueChanged];
    [mainView addSubview:slider2];
    
    // the label indicating the slider's value
    detailLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(20, h/5 + h/4, w-40, h/4)];
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
    int h = mainView.frame.size.height-40;
    int w = mainView.frame.size.width;
    int w2 = w-40;
    ////////////////////////
    // Top selector stuff //
    ////////////////////////
    // The label indicating what the user is selecting
    UILabel *label1     = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, w2, h/9)];
    label1.text         = [[@"I WILL " stringByAppendingString:[bet.betVerb uppercaseString]] stringByAppendingString:@":"];
    label1.textColor    = [UIColor whiteColor];
    label1.textAlignment= NSTextAlignmentCenter;
    label1.font = [UIFont fontWithName:@"ProximaNova-Black" size:30];
    [mainView addSubview:label1];
    
    // The slider the user uses to select values
    UISlider *slider1   = [[UISlider alloc] initWithFrame:CGRectMake(20, h/9, w2, h/9)];
    [slider1 setMinimumTrackTintColor:betchyuOrange];
    [slider1 addTarget:self
                action:@selector(updateSlider1Value:)
      forControlEvents:UIControlEventValueChanged];
    [mainView addSubview:slider1];
    
    // the label indicating the slider's value
    detailLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 2*h/9, w2, h/9)];
    detailLabel1.textColor = betchyuOrange;
    detailLabel1.textAlignment = NSTextAlignmentCenter;
    detailLabel1.font = [UIFont fontWithName:@"ProximaNova-Black" size:35];
    [mainView addSubview:detailLabel1];
    
    ///////////////////////////
    // Bottom Selector stuff //
    ///////////////////////////
    // The label indicating what the user is selecting
    UILabel *label2     = [[UILabel alloc] initWithFrame:CGRectMake(20, 20 + 3*h/9, w2, h/9)];
    label2.text         = @"IN:";
    label2.textColor    = [UIColor whiteColor];
    label2.textAlignment= NSTextAlignmentCenter;
    label2.font = [UIFont fontWithName:@"ProximaNova-Black" size:35];
    [mainView addSubview:label2];
    
    // The slider the user uses to select values
    UISlider *slider2   = [[UISlider alloc] initWithFrame:CGRectMake(20, 20 + 4*h/9, w2, h/9)];
    [slider2 setMinimumTrackTintColor:betchyuOrange];
    [slider2 addTarget:self
                action:@selector(updateSlider2Value:)
      forControlEvents:UIControlEventValueChanged];
    [mainView addSubview:slider2];
    
    // the label indicating the slider's value
    detailLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 20 + 5*h/9, w2, h/9)];
    detailLabel2.textColor = betchyuOrange;
    detailLabel2.textAlignment = NSTextAlignmentCenter;
    detailLabel2.font = [UIFont fontWithName:@"ProximaNova-Black" size:35];
    [mainView addSubview:detailLabel2];
    
    return mainView;
}
-(UIScrollView *)loadWeightDetailsHandler:(UIScrollView *)mainView {
    int h = mainView.frame.size.height-40;
    int w = mainView.frame.size.width;
    int w2 = w-40;
    
    self.weightInput                   = [[UITextField alloc] initWithFrame:CGRectMake(w/2, 20, w/3.7, h/12)];
    self.weightInput.keyboardType      = UIKeyboardTypeNumbersAndPunctuation;
    self.weightInput.backgroundColor   = [UIColor colorWithRed:(95/255.0) green:(95/255.0) blue:(95/255.0) alpha:1.0];
    self.weightInput.borderStyle       = UITextBorderStyleLine;
    self.weightInput.font              = [UIFont fontWithName:@"ProximaNova-Regular" size:(h/12 - 3)];
    self.weightInput.tintColor         = self.betchyuOrange;
    self.weightInput.textColor         = self.betchyuOrange;
    self.weightInput.layer.borderColor = [self.betchyuOrange CGColor];
    self.weightInput.layer.borderWidth = 2.0f;
    self.weightInput.delegate = self;
    [mainView addSubview:self.weightInput];
    
    UILabel *weightLabel  = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, (w/2)-30, h/12)];
    weightLabel.text      = [NSString stringWithFormat:@"My Weight:"];
    weightLabel.font      = [UIFont fontWithName:@"ProximaNova-Black" size:22];
    weightLabel.textColor = self.betchyuOrange;
    weightLabel.textAlignment = NSTextAlignmentRight;
    [mainView addSubview:weightLabel];
    
    ////////////////////////
    // Top selector stuff //
    ////////////////////////
    // The label indicating what the user is selecting
    UILabel *label1     = [[UILabel alloc] initWithFrame:CGRectMake(20, ((h/12)+20), w2, h/9)];
    label1.text         = [[@"I WILL " stringByAppendingString:[bet.betVerb uppercaseString]] stringByAppendingString:@":"];
    label1.textColor    = [UIColor whiteColor];
    label1.textAlignment= NSTextAlignmentCenter;
    label1.font = [UIFont fontWithName:@"ProximaNova-Black" size:30];
    [mainView addSubview:label1];
    
    // The slider the user uses to select values
    UISlider *slider1   = [[UISlider alloc] initWithFrame:CGRectMake(20, ((h/12)+20)+(h/9), w2, h/9)];
    [slider1 setMinimumTrackTintColor:betchyuOrange];
    [slider1 addTarget:self
                action:@selector(updateSlider1Value:)
      forControlEvents:UIControlEventValueChanged];
    [mainView addSubview:slider1];
    
    // the label indicating the slider's value
    detailLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, ((h/12)+20)+(2*h/9), w2, h/9)];
    detailLabel1.textColor = betchyuOrange;
    detailLabel1.textAlignment = NSTextAlignmentCenter;
    detailLabel1.font = [UIFont fontWithName:@"ProximaNova-Black" size:35];
    [mainView addSubview:detailLabel1];
    
    ///////////////////////////
    // Bottom Selector stuff //
    ///////////////////////////
    // The label indicating what the user is selecting
    UILabel *label2     = [[UILabel alloc] initWithFrame:CGRectMake(20, ((h/12)+20)+(20 + 3*h/9), w2, h/9)];
    label2.text         = @"IN:";
    label2.textColor    = [UIColor whiteColor];
    label2.textAlignment= NSTextAlignmentCenter;
    label2.font = [UIFont fontWithName:@"ProximaNova-Black" size:35];
    [mainView addSubview:label2];
    
    // The slider the user uses to select values
    UISlider *slider2   = [[UISlider alloc] initWithFrame:CGRectMake(20, ((h/12)+20)+(20 + 4*h/9), w2, h/9)];
    [slider2 setMinimumTrackTintColor:betchyuOrange];
    [slider2 addTarget:self
                action:@selector(updateSlider2Value:)
      forControlEvents:UIControlEventValueChanged];
    [mainView addSubview:slider2];
    
    // the label indicating the slider's value
    detailLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(20, ((h/12)+20)+(20 + 5*h/9), w2, h/9)];
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
    if ([detailLabel1.text length] == 0
        || [detailLabel2.text length] == 0
        || ([bet.betNoun isEqualToString:@"pounds"] && [weightInput.text isEqualToString:@""])) {
        // Show warning message
        [[[UIAlertView alloc] initWithTitle: @"Wait!"
                                    message: @"I think you forgot to define your bet..."
                                   delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        
        // and bail from the method
        return;
    }
    
    if ([bet.betNoun isEqualToString:@"pounds"]) {
        bet.current = @([weightInput.text integerValue]);
    }
    // Make the next view
    BetStakeVC *vc =[[BetStakeVC alloc] initWithBet:bet];
    vc.title = @"Set Stake";
    // Show it.
    [self.navigationController pushViewController:vc animated:true];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
@end
