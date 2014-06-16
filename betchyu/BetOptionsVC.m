//
//  BetOptionsVC.m
//  betchyu
//
//  Created by Adam Baratz on 6/16/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import "BetOptionsVC.h"

@interface BetOptionsVC ()

@end

@implementation BetOptionsVC

@synthesize bet;
@synthesize passedBetName;
@synthesize detailLabel1;
@synthesize detailLabel2;

- (id)initWithBetVerb:(NSString *)verbName {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        self.passedBetName = verbName;
        
        bet = [TempBet new];
        bet.verb = [[verbName componentsSeparatedByString:@" "] objectAtIndex:0]; //first word passed
        bet.noun = [[verbName componentsSeparatedByString:@" "] objectAtIndex:1]; // second word
        if ([bet.noun isEqualToString:@"Weight"]) {
            bet.noun = @"pounds";
        } else if ([bet.noun isEqualToString:@"More"]){
            if ([bet.verb isEqualToString:@"Workout"]) {
                bet.noun = @"times";
            } else {
                bet.noun = @"miles";
            }
        }

    }
    return self;
}

- (void) loadView {
    
    CGRect f = [UIScreen mainScreen].applicationFrame;

    int y = self.navigationController.navigationBar.frame.size.height + f.origin.y; // navBar + statusBar
    int h = f.size.height - y;
    
    CGRect f2 = CGRectMake(f.origin.x, y, f.size.width, h);
    
    self.view = [UIView new];
    self.view.backgroundColor = Blight;
    self.view.frame = f2;
    [self.view addSubview:[[BetOptionsTopView alloc] initWithFrame:CGRectMake(0, 0, f2.size.width, 2*f2.size.height/5) AndBetName:self.passedBetName]];
    
    if ([bet.noun isEqualToString:@"pounds"]) {
        [self.view addSubview:[self getDecreasingSubview]];
    } else if ([bet.noun isEqualToString:@"Smoking"]) {
        [self.view addSubview:[self getBinarySubview]];
    } else {
        [self.view addSubview:[self getIncreasingSubview]];
    }
}


-(UIView *)getBinarySubview {
    return [UIView new];
}
-(UIView *)getDecreasingSubview {
    return [UIView new];
}
-(UIView *)getIncreasingSubview {
    // convinience variables
    int fontSize = 18;
    int h = self.view.frame.size.height;
    int w = self.view.frame.size.width;
    // The thing we return. it has a shadow at the bottom of it
    UIView *main = [[UIView alloc] initWithFrame:CGRectMake(0, 2*h/5 +64, w, 250)];
    main.backgroundColor = [UIColor whiteColor];
    main.layer.shadowColor = [Bdark CGColor];
    main.layer.shadowRadius = 2.0f;
    main.layer.shadowOffset = CGSizeMake(0, 2);
    main.layer.shadowOpacity = 0.5f;
    main.layer.shadowPath = [[UIBezierPath bezierPathWithRect:main.layer.bounds] CGPath];

    // The Label stating your tintention @"I will run:"
    UILabel *goalAmountLabel = [[UILabel alloc]initWithFrame:CGRectMake(9, 9, w-9, fontSize+2)];
    goalAmountLabel.text = [NSString stringWithFormat:@"I will %@:", bet.verb];
    goalAmountLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize];
    goalAmountLabel.textColor = Bmid;
    [main addSubview:goalAmountLabel];
    
    // the uilabel that changes with the position of the slider
    self.detailLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 9, w, fontSize+2)];
    detailLabel1.text = [NSString stringWithFormat:@"0 %@", bet.noun];
    detailLabel1.font = [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize];
    detailLabel1.textColor = Borange;
    detailLabel1.textAlignment = NSTextAlignmentCenter;
    [main addSubview:self.detailLabel1];
    
    // the uislider that determines bet.amount
    UISlider *slider   = [[UISlider alloc] initWithFrame:CGRectMake(20, 20, w-40, h/5)];
    [slider setMinimumTrackTintColor:Borange];
    [slider setThumbImage:[UIImage imageNamed:@"1.jpg"] forState:UIControlStateNormal];
    slider.thumbTintColor = Borange;
    slider.maximumValue = 30;
    [slider addTarget:self
                action:@selector(updateSliderValue:)
      forControlEvents:UIControlEventValueChanged];
    [main addSubview:slider];
    
    
    // the uilabel saying @"EndDate:"
    UILabel * endDateLabel  = [[UILabel alloc] initWithFrame:CGRectMake(9, slider.frame.origin.y + slider.frame.size.height, w, fontSize+2)];
    endDateLabel.text       = @"End Date:";
    endDateLabel.textColor  = Bmid;
    endDateLabel.font       = [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize];
    [main addSubview:endDateLabel];
    
    UIButton *openCalendar = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    openCalendar.frame = CGRectMake(160, endDateLabel.frame.origin.y, 50, 50);
    [openCalendar setTitle:@"me" forState:UIControlStateNormal];
    [openCalendar addTarget:self action:@selector(openCalendar:) forControlEvents:UIControlEventTouchUpInside];
    [main addSubview:openCalendar];
    
    
    return main;
}

-(void)updateSliderValue:(UISlider *)sender {
    
    detailLabel1.text = [NSString stringWithFormat:@"%.0f %@", sender.value, bet.noun];
}

-(void)openCalendar:(id)sender {
    UIViewController *vc = [UIViewController new];
    CGRect f = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
    DDCalendarView *cal = [[DDCalendarView alloc] initWithFrame:f fontName:@"AmericanTypewriter" delegate:self];
    vc.view = [[UIView alloc] initWithFrame:self.view.frame];
    [vc.view addSubview:cal];
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dayButtonPressed:(DayButton *)button {
	//For the sake of example, we obtain the date from the button object
	//and display the string in an alert view
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[dateFormatter setDateStyle:NSDateFormatterLongStyle];
	NSString *theDate = [dateFormatter stringFromDate:button.buttonDate];
    
	UIAlertView *dateAlert = [[UIAlertView alloc]
                              initWithTitle:@"Date Pressed"
                              message:theDate
                              delegate:self
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil];
	[dateAlert show];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
