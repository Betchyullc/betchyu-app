//
//  CustomBetDefineView.m
//  betchyu
//
//  Created by Adam Baratz on 7/11/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import "CustomBetDefineView.h"

@implementation CustomBetDefineView

@synthesize detailLabel;
@synthesize durationLabel;
@synthesize dateSlider;

@synthesize hasBeenCleared;

@synthesize verb;
@synthesize amount;
@synthesize noun;

@synthesize helper;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.hasBeenCleared = NO;
        self.helper = [[BetOptionsVC alloc] initWithBetVerb:@"asdf adsf"];
        [helper loadView];
        NSString * ownId = ((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId;
        int fontSize = 17;
        int w = frame.size.width;
        
        self.backgroundColor = Blight;
        
        UIView *main = [UIView new];
        main.frame = CGRectMake(0, 64, w, 300);
        main.backgroundColor = [UIColor whiteColor];
        main.layer.masksToBounds = NO;
        main.clipsToBounds      = NO;
        main.layer.shadowColor  = [Bdark CGColor];
        main.layer.shadowRadius = 3.0f;
        main.layer.shadowOffset = CGSizeMake(0, 5);
        main.layer.shadowOpacity= 0.7f;
        main.layer.shadowPath   = [[UIBezierPath bezierPathWithRect:main.layer.bounds] CGPath];
        
        /*UIView *orangeBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 20)];
        orangeBar.backgroundColor = Borange;
        [main addSubview:orangeBar];*/
        
        // prompt
        UILabel *verbL  = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, w, fontSize + 3)];
        verbL.font      = FregfS;
        verbL.textColor = Bdark;
        verbL.text      = @"I will:";
        verbL.textAlignment = NSTextAlignmentCenter;
        [main addSubview:verbL];
        // verb-box
        verb            = [[UITextField alloc] initWithFrame:CGRectMake(w/4, 32, w/2, fontSize + 3)];
        verb.tag        = 1;
        verb.text       = @"verb (run)";
        verb.textAlignment = NSTextAlignmentCenter;
        verb.font       = FregfS;
        verb.textColor  = Borange;
        verb.delegate   = self;
        [main addSubview:verb];
        // amount-box
        amount            = [[UITextField alloc] initWithFrame:CGRectMake(w/4, 64, w/2, fontSize + 3)];
        amount.tag        = 2;
        amount.text       = @"# (5)";
        amount.textAlignment = NSTextAlignmentCenter;
        amount.font       = FregfS;
        amount.textColor  = Borange;
        amount.delegate   = self;
        amount.keyboardType = UIKeyboardTypeDecimalPad;
        [main addSubview:amount];
        // noun-box
        noun            = [[UITextField alloc] initWithFrame:CGRectMake(w/4, 96, w/2, fontSize + 3)];
        noun.tag        = 3;
        noun.text       = @"noun (miles)";
        noun.textAlignment = NSTextAlignmentCenter;
        noun.font       = FregfS;
        noun.textColor  = Borange;
        noun.delegate   = self;
        noun.keyboardType = UIKeyboardTypeAlphabet;
        [main addSubview:noun];
        // "In"
        UILabel *inL  = [[UILabel alloc] initWithFrame:CGRectMake(0, 96+32, w, fontSize + 3)];
        inL.font      = FregfS;
        inL.textColor = Bdark;
        inL.text      = @"In:";
        inL.textAlignment = NSTextAlignmentCenter;
        [main addSubview:inL];
        // UILabel "x days"
        self.durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 96+32 + 32, w, fontSize+2)];
        durationLabel.text = @"";
        durationLabel.font = FregfS;
        durationLabel.textColor = Borange;
        durationLabel.textAlignment = NSTextAlignmentCenter;
        [main addSubview:self.durationLabel];
        
        // UISlider that choses Date
        dateSlider = [helper makeDateScrollerFromFrame:CGRectMake(20, 96+64+20, w-40, 50)];
        [dateSlider addTarget:self action:@selector(datePicked:) forControlEvents:UIControlEventValueChanged];
        [main addSubview:dateSlider];
        
        // the uilabel saying @"EndDate:"
        UILabel * endDateLabel  = [[UILabel alloc] initWithFrame:CGRectMake(15, dateSlider.frame.origin.y + dateSlider.frame.size.height, w-30, fontSize+2)];
        endDateLabel.text       = @"End Date:";
        endDateLabel.textColor  = Bmid;
        endDateLabel.font       = FregfS;
        [main addSubview:endDateLabel];
        
        detailLabel = [[UILabel alloc] initWithFrame:endDateLabel.frame];
        detailLabel.textAlignment = NSTextAlignmentCenter;
        detailLabel.text       = @"";
        detailLabel.textColor  = Borange;
        detailLabel.font       = FregfS;
        [main addSubview:detailLabel];
        
        // accept button
        UIButton *ok = [[UIButton alloc] initWithFrame:CGRectMake(0, main.frame.size.height - (fontSize+30), w, fontSize + 30)];
        [ok setTitle:@"Choose Opponents" forState:UIControlStateNormal];
        [ok setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        ok.backgroundColor = Bgreen;
        ok.titleLabel.font = FblackfS;
        [ok addTarget:self action:@selector(chooseOpponents:) forControlEvents:UIControlEventTouchUpInside];
        [main addSubview:ok];
        
        
        [self addSubview:main];
        
        [[[UIAlertView alloc] initWithTitle:@"Custom Bet" message:@"These bets are a bit like a Mad lib. Fill in the words to make your own bet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    return self;
}

-(void)datePicked:(UISlider *)sender {
    // update what they can see
    int amt = (int)roundf(sender.value);
    
    NSDateComponents *components = [NSDateComponents new];
    components.day = amt;
    NSDate* maxDate = [[NSCalendar currentCalendar]dateByAddingComponents:components
                                                                   toDate:[NSDate date]
                                                                  options:0];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    NSString *theDate = [dateFormatter stringFromDate:maxDate];
    
    self.detailLabel.text = theDate; // written-out date
    self.durationLabel.text = [NSString stringWithFormat:@"%i days", amt]; // number of days
    // update the data we pass on
    self.helper.bet.duration = [NSNumber numberWithInt:amt];
}

-(void) chooseOpponents:(UIButton *)sender {
    AppDelegate * app = ((AppDelegate *)([[UIApplication sharedApplication] delegate]));
    
    if ([verb.text isEqualToString:@"verb (run)"] || [verb.text isEqualToString:@""]) {
        [self errorBox:YES box:verb];
        [self performSelector:@selector(errorBox:) withObject:NO afterDelay:1];
        return;
    }
    if ([amount.text isEqualToString:@"# (5)"] || [amount.text isEqualToString:@""]) {
        [self errorBox:YES box:amount];
        [self performSelector:@selector(errorBox:) withObject:NO afterDelay:1];
        return;
    }if ([noun.text isEqualToString:@"noun (miles)"] || [noun.text isEqualToString:@""]) {
        [self errorBox:YES box:noun];
        [self performSelector:@selector(errorBox:) withObject:NO afterDelay:1];
        return;
    }
    if ([detailLabel.text isEqualToString:@""]) {
        [self errorDate:YES];
        [self performSelector:@selector(errorDate:) withObject:NO afterDelay:1];
        return;
    }

    // update the key information
    helper.bet.verb = verb.text;
    helper.bet.noun = noun.text;
    helper.bet.amount = [NSNumber numberWithInt:[amount.text intValue]];
    
    // fake some stuff to allow the helper to work right
    helper.detailLabel1.text = @"blah blah";
    helper.detailLabel2.text = @"blah blah";
    
    // Show guiding message
    [[[UIAlertView alloc] initWithTitle: @"Nice Goal!"
                                message: @"Now just pick 3 friends you want to invite. Only 1 needs to sign up."
                               delegate: nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
    
    [app.navController presentViewController:self.helper.fbFriendVC animated:YES completion:^(void){
        [helper addSearchBarToFriendPickerView];
    }];

}

-(void)errorBox:(BOOL)error box:(UITextField *)box {
    if (error) {
        box.layer.borderColor = [Bred CGColor];
        box.layer.borderWidth = 2;
    } else {
        box.layer.borderWidth = 0;
    }
}
-(void)errorBox:(BOOL)error {
    if (error) {
        //wont happen
    } else {
        verb.layer.borderWidth = 0;
        amount.layer.borderWidth = 0;
        noun.layer.borderWidth = 0;
    }
}

-(void)errorDate:(BOOL)error {
    if (error) {
        self.dateSlider.layer.borderColor = [Bred CGColor];
        self.dateSlider.layer.borderWidth = 2;
    } else {
        self.dateSlider.layer.borderWidth = 0;
    }
}

#pragma mark UITextFieldDelegate shit
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    amount.text = [amount.text isEqualToString:@""] ? @"# (5)" : amount.text;
    noun.text = [noun.text isEqualToString:@""] ? @"noun (miles)" : noun.text;
    verb.text = [verb.text isEqualToString:@""] ? @"verb (run)" : verb.text;
    textField.text = @"";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if (textField.tag == 1 || textField.tag == 3) {
        if ([string rangeOfCharacterFromSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789!@#$%^&*()+=~"] invertedSet]].location == NSNotFound) {
            return NO;
        } else {
            return YES;
        }
    } else if (textField.tag == 2) {
        if ([string rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location == NSNotFound) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return YES;
    }
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.verb resignFirstResponder];
    [self.noun resignFirstResponder];
    [self.amount resignFirstResponder];
}

@end
