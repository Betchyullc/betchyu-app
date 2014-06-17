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

@synthesize fbFriendVC;
@synthesize searchBar;
@synthesize searchText;
@synthesize initialInput;

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
        
        // remove the "Bet Options" from the back button on following pages
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];

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
    // convinience variables
    int fontSize = 18;
    int h = self.view.frame.size.height;
    int w = self.view.frame.size.width;
    // The thing we return. it has a shadow at the bottom of it
    UIView *main = [[UIView alloc] initWithFrame:CGRectMake(0, 2*h/5 +64, w, 250)];
    
    // The Label stating your intention @"I will not smoke:"
    UILabel *goalAmountLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 9, w-15, fontSize+2)];
    goalAmountLabel.text = [NSString stringWithFormat:@"I will %@ %@ until:", bet.verb, bet.noun];
    goalAmountLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize];
    goalAmountLabel.textColor = Borange; // orange b/c more important
    [main addSubview:goalAmountLabel];
    CGRect gf = goalAmountLabel.frame;
    gf.size.height = gf.size.height + 20; // add some padding
    
    // formally set the amount ot 0.0, which indicates binaryness
    bet.amount = [NSNumber numberWithFloat:0.0f];
    detailLabel1 = [UILabel new];
    detailLabel1.text = @"this is just to not trigger the error for not setting this";
    
    // the uilabel saying @"EndDate:"
    UILabel * endDateLabel  = [[UILabel alloc] initWithFrame:CGRectMake(15, gf.origin.y + gf.size.height, w-15, fontSize+2)];
    endDateLabel.text       = @"End Date:";
    endDateLabel.textColor  = Bmid;
    endDateLabel.font       = [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize];
    [main addSubview:endDateLabel];
    
    detailLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, gf.origin.y + gf.size.height, w, fontSize+2)];
    detailLabel2.textAlignment = NSTextAlignmentCenter;
    detailLabel2.text       = @"";
    detailLabel2.textColor  = Borange;
    detailLabel2.font       = [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize];
    [main addSubview:detailLabel2];
    
    // little button that opens the datepicker
    UIButton *openCalendar = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    openCalendar.frame = CGRectMake(w - 50, endDateLabel.frame.origin.y - 10, 35, 35);
    [openCalendar setImage:[UIImage imageNamed:@"calendar-06.png"] forState:UIControlStateNormal];
    [openCalendar addTarget:self action:@selector(openCalendar:) forControlEvents:UIControlEventTouchUpInside];
    openCalendar.tintColor = Bmid;
    [main addSubview:openCalendar];
    
    // The green "Choose Opponent" button at the bottom
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    nextBtn.backgroundColor = Bgreen;
    nextBtn.frame = CGRectMake(0, openCalendar.frame.size.height + openCalendar.frame.origin.y + 10, w, 45);
    [nextBtn setTitle:@"Choose Opponents" forState:UIControlStateNormal];
    nextBtn.titleLabel.font =[UIFont fontWithName:@"ProximaNova-Black" size:fontSize];
    [nextBtn addTarget:self action:@selector(chooseOpponents:) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.tintColor = [UIColor whiteColor];
    [main addSubview:nextBtn];
    
    // messing with framing and apperance
    CGRect fr = main.frame;
    fr.size = CGSizeMake(w, nextBtn.frame.size.height + nextBtn.frame.origin.y);
    main.frame              = fr;
    main.backgroundColor    = [UIColor whiteColor];
    main.layer.shadowColor  = [Bdark CGColor];
    main.layer.shadowRadius = 2.0f;
    main.layer.shadowOffset = CGSizeMake(0, 2);
    main.layer.shadowOpacity= 0.5f;
    main.layer.shadowPath   = [[UIBezierPath bezierPathWithRect:main.layer.bounds] CGPath];
    
    return main;

}
-(UIView *)getDecreasingSubview {
    // convinience variables
    int fontSize = 18;
    int h = self.view.frame.size.height;
    int w = self.view.frame.size.width;
    // The thing we return. it has a shadow at the bottom of it
    UIView *main = [[UIView alloc] initWithFrame:CGRectMake(0, 2*h/5 +64, w, 250)];
    
    UILabel *startingFromLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 9, w-15, fontSize+2)];
    startingFromLab.text = @"Starting From:\t\t\t\t\t  lbs";
    startingFromLab.font = [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize];
    startingFromLab.textColor = Bmid;
    [main addSubview:startingFromLab];
    
    self.initialInput                   = [[UITextField alloc] initWithFrame:CGRectMake(w/2, 9, w/4, fontSize+4)];
    self.initialInput.keyboardType      = UIKeyboardTypeNumbersAndPunctuation;
    self.initialInput.backgroundColor   = [UIColor clearColor];
    self.initialInput.borderStyle       = UITextBorderStyleLine;
    self.initialInput.font              = [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize-1];
    self.initialInput.tintColor         = Borange;
    self.initialInput.textColor         = Borange;
    self.initialInput.layer.borderColor = [Bmid CGColor];
    self.initialInput.layer.borderWidth = 2.0f;
    self.initialInput.delegate = self;
    [main addSubview:self.initialInput];
    
    // The Label stating your tintention @"I will lose:"
    UILabel *goalAmountLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, initialInput.frame.size.height + initialInput.frame.origin.y + 15, w-15, fontSize+2)];
    goalAmountLabel.text = [NSString stringWithFormat:@"I will %@:", bet.verb];
    goalAmountLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize];
    goalAmountLabel.textColor = Bmid;
    [main addSubview:goalAmountLabel];
    
    // the uilabel that changes with the position of the slider
    self.detailLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, goalAmountLabel.frame.origin.y, w, fontSize+2)];
    detailLabel1.text = @"";
    detailLabel1.font = [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize];
    detailLabel1.textColor = Borange;
    detailLabel1.textAlignment = NSTextAlignmentCenter;
    [main addSubview:self.detailLabel1];
    
    // the uislider that determines bet.amount
    UISlider *slider   = [[UISlider alloc] initWithFrame:CGRectMake(20, detailLabel1.frame.origin.y, w-40, h/5)];
    [slider setMinimumTrackTintColor:Borange];
    [slider setThumbImage:[UIImage imageNamed:@"1.jpg"] forState:UIControlStateNormal];
    slider.thumbTintColor = Borange;
    slider.maximumValue = 30;
    [slider addTarget:self
               action:@selector(updateSliderValue:)
     forControlEvents:UIControlEventValueChanged];
    [main addSubview:slider];
    
    
    // the uilabel saying @"EndDate:"
    UILabel * endDateLabel  = [[UILabel alloc] initWithFrame:CGRectMake(15, slider.frame.origin.y + slider.frame.size.height, w-15, fontSize+2)];
    endDateLabel.text       = @"End Date:";
    endDateLabel.textColor  = Bmid;
    endDateLabel.font       = [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize];
    [main addSubview:endDateLabel];
    
    detailLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, slider.frame.origin.y + slider.frame.size.height, w, fontSize+2)];
    detailLabel2.textAlignment = NSTextAlignmentCenter;
    detailLabel2.text       = @"";
    detailLabel2.textColor  = Borange;
    detailLabel2.font       = [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize];
    [main addSubview:detailLabel2];
    
    // little button that opens the datepicker
    UIButton *openCalendar = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    openCalendar.frame = CGRectMake(w - 50, endDateLabel.frame.origin.y - 10, 35, 35);
    [openCalendar setImage:[UIImage imageNamed:@"calendar-06.png"] forState:UIControlStateNormal];
    [openCalendar addTarget:self action:@selector(openCalendar:) forControlEvents:UIControlEventTouchUpInside];
    openCalendar.tintColor = Bmid;
    [main addSubview:openCalendar];
    
    // The green "Choose Opponent" button at the bottom
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    nextBtn.backgroundColor = Bgreen;
    nextBtn.frame = CGRectMake(0, openCalendar.frame.size.height + openCalendar.frame.origin.y + 10, w, 45);
    [nextBtn setTitle:@"Choose Opponents" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(chooseOpponents:) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.tintColor = [UIColor whiteColor];
    nextBtn.titleLabel.font =[UIFont fontWithName:@"ProximaNova-Black" size:fontSize];
    [main addSubview:nextBtn];
    
    // messing with framing and apperance
    CGRect fr = main.frame;
    fr.size = CGSizeMake(w, nextBtn.frame.size.height + nextBtn.frame.origin.y);
    main.frame              = fr;
    main.backgroundColor    = [UIColor whiteColor];
    main.layer.shadowColor  = [Bdark CGColor];
    main.layer.shadowRadius = 2.0f;
    main.layer.shadowOffset = CGSizeMake(0, 2);
    main.layer.shadowOpacity= 0.5f;
    main.layer.shadowPath   = [[UIBezierPath bezierPathWithRect:main.layer.bounds] CGPath];
    
    return main;
}
-(UIView *)getIncreasingSubview {
    // convinience variables
    int fontSize = 18;
    int h = self.view.frame.size.height;
    int w = self.view.frame.size.width;
    // The thing we return. it has a shadow at the bottom of it
    UIView *main = [[UIView alloc] initWithFrame:CGRectMake(0, 2*h/5 +64, w, 250)];

    // The Label stating your tintention @"I will run:"
    UILabel *goalAmountLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 9, w-15, fontSize+2)];
    goalAmountLabel.text = [NSString stringWithFormat:@"I will %@:", bet.verb];
    goalAmountLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize];
    goalAmountLabel.textColor = Bmid;
    [main addSubview:goalAmountLabel];
    
    // the uilabel that changes with the position of the slider
    self.detailLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 9, w, fontSize+2)];
    detailLabel1.text = @"";
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
    UILabel * endDateLabel  = [[UILabel alloc] initWithFrame:CGRectMake(15, slider.frame.origin.y + slider.frame.size.height, w-15, fontSize+2)];
    endDateLabel.text       = @"End Date:";
    endDateLabel.textColor  = Bmid;
    endDateLabel.font       = [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize];
    [main addSubview:endDateLabel];
    
    detailLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, slider.frame.origin.y + slider.frame.size.height, w, fontSize+2)];
    detailLabel2.textAlignment = NSTextAlignmentCenter;
    detailLabel2.text       = @"";
    detailLabel2.textColor  = Borange;
    detailLabel2.font       = [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize];
    [main addSubview:detailLabel2];
    
    // little button that opens the datepicker
    UIButton *openCalendar = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    openCalendar.frame = CGRectMake(w - 50, endDateLabel.frame.origin.y - 10, 35, 35);
    [openCalendar setImage:[UIImage imageNamed:@"calendar-06.png"] forState:UIControlStateNormal];
    [openCalendar addTarget:self action:@selector(openCalendar:) forControlEvents:UIControlEventTouchUpInside];
    openCalendar.tintColor = Bmid;
    [main addSubview:openCalendar];

    // The green "Choose Opponent" button at the bottom
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    nextBtn.backgroundColor = Bgreen;
    nextBtn.frame = CGRectMake(0, openCalendar.frame.size.height + openCalendar.frame.origin.y + 10, w, 45);
    [nextBtn setTitle:@"Choose Opponents" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(chooseOpponents:) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.tintColor = [UIColor whiteColor];
    nextBtn.titleLabel.font =[UIFont fontWithName:@"ProximaNova-Black" size:fontSize];
    [main addSubview:nextBtn];
    
    // messing with framing and apperance
    CGRect fr = main.frame;
    fr.size = CGSizeMake(w, nextBtn.frame.size.height + nextBtn.frame.origin.y);
    main.frame              = fr;
    main.backgroundColor    = [UIColor whiteColor];
    main.layer.shadowColor  = [Bdark CGColor];
    main.layer.shadowRadius = 2.0f;
    main.layer.shadowOffset = CGSizeMake(0, 2);
    main.layer.shadowOpacity= 0.5f;
    main.layer.shadowPath   = [[UIBezierPath bezierPathWithRect:main.layer.bounds] CGPath];
    
    return main;
}

-(void)updateSliderValue:(UISlider *)sender {
    // update what they can see
    detailLabel1.text = [NSString stringWithFormat:@"%.0f %@", sender.value+1, bet.noun];
    // update the data we pass on
    bet.amount = [NSNumber numberWithFloat:sender.value+1];
}

-(void)openCalendar:(id)sender {
    UIViewController *vc = [UIViewController new];
    CGRect f = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
    DDCalendarView *cal = [[DDCalendarView alloc] initWithFrame:f fontName:@"ProximaNova-Regular" delegate:self];
    vc.view = [[UIView alloc] initWithFrame:self.view.frame];
    [vc.view addSubview:cal];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.title = @"Choose End Date";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dayButtonPressed:(DayButton *)button {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    NSString *theDate = [dateFormatter stringFromDate:button.buttonDate];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [NSDateComponents new];
    components.day = 30;
    NSDate* maxDate = [[NSCalendar currentCalendar]dateByAddingComponents:components
                                                                   toDate:[NSDate date]
                                                                  options:0];
    
    if ( [button.buttonDate compare:[NSDate date]] == NSOrderedDescending &&
         [maxDate compare:button.buttonDate] == NSOrderedDescending) {
        components = [gregorianCalendar components:NSDayCalendarUnit
                                                            fromDate:[NSDate date]
                                                              toDate:button.buttonDate
                                                             options:0];
        // update the data we pass on
        self.bet.duration = [NSNumber numberWithInteger:components.day];
        
        // update what they can see
        detailLabel2.text = theDate;
        // go back to BetOptionsVC
        [self.navigationController popViewControllerAnimated:YES];
    } else if ([maxDate compare:button.buttonDate] != NSOrderedDescending){
        // handle picking to futuristic of a date
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:[NSString stringWithFormat:@"Date must be closer than %@", [dateFormatter stringFromDate:maxDate]]
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil]
         show];
    } else {
        // handle picking too historical of a date
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:[NSString stringWithFormat:@"Date must be past %@", [dateFormatter stringFromDate:[NSDate date]]]
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil]
         show];
    }
}

-(void) chooseOpponents:(id)sender {
    // If user has not selected bet Details...
    if ([detailLabel1.text length] == 0
        || [detailLabel2.text length] == 0
        || ([bet.noun isEqualToString:@"pounds"] && [initialInput.text isEqualToString:@""])) {
        // Show warning message
        [[[UIAlertView alloc] initWithTitle: @"Wait!"
                                    message: @"I think you forgot to define your bet..."
                                   delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        
        // and bail from the method
        return;
    }
    
    if ([bet.noun isEqualToString:@"pounds"]) {
        bet.initial = @([initialInput.text integerValue]);
    }
    
    if (!fbFriendVC) {
        fbFriendVC = [[FBFriendPickerViewController alloc] initWithNibName:nil bundle:nil];
        // Set the friend picker delegate
        fbFriendVC.delegate = self;
        
        fbFriendVC.title = @"Choose Opponents";
    }
    
    [fbFriendVC loadData];
    [self presentViewController:self.fbFriendVC animated:YES completion:^(void){
        [self addSearchBarToFriendPickerView];
    }];
}

//////////////////////////////////////////
// search bar stuff for FBFriendPicker  //
//////////////////////////////////////////
- (void)addSearchBarToFriendPickerView {
    if (self.searchBar == nil) {
        CGFloat searchBarHeight = 44.0;
        self.searchBar =
        [[UISearchBar alloc]
         initWithFrame:
         CGRectMake(0,0,
                    self.view.bounds.size.width,
                    searchBarHeight)];
        self.searchBar.autoresizingMask = self.searchBar.autoresizingMask |
        UIViewAutoresizingFlexibleWidth;
        self.searchBar.delegate = self;
        self.searchBar.showsCancelButton = YES;
        /*self.searchBar.barTintColor = [UIColor colorWithRed:1.0 green:(117.0/255.0) blue:(63/255.0) alpha:1.0];
         self.searchBar.translucent = NO;*/
        
        [self.fbFriendVC.canvasView addSubview:self.searchBar];
        CGRect newFrame = self.fbFriendVC.view.bounds;
        newFrame.size.height -= searchBarHeight;
        newFrame.origin.y = searchBarHeight;
        self.fbFriendVC.tableView.frame = newFrame;
    }
}
- (void) handleSearch:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    self.searchText = searchBar.text;
    [self.fbFriendVC updateView];
}
- (void)searchBarSearchButtonClicked:(UISearchBar*)searchBar {
    [self handleSearch:searchBar];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    self.searchText = nil;
    [searchBar resignFirstResponder];
    [self.fbFriendVC updateView];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.searchText = searchText;
    [self.fbFriendVC updateView];
}

////////////////////////
// friend picker stuff
////////////////////////
- (void)friendPickerViewControllerSelectionDidChange:(FBFriendPickerViewController *)friendPicker {
    // need to clear the search, so that the facebookVC will re-determine the selection list.
    // this prevents bugs with search-selected people not being included in the actual invitations
    self.searchText = nil;
    [self.searchBar resignFirstResponder];
    [self.fbFriendVC updateView];
    // this re-updates the list of friends we're gonna use to make invitations.
    bet.friends = friendPicker.selection;
}

// handles the user touching the done button on the FB friend selector
- (void)facebookViewControllerDoneWasPressed:(id)sender {
    // handle the user NOT selecting a friend... bad users.
    if (bet.friends.count == 0) {
        [[[UIAlertView alloc] initWithTitle: @"Hey!"
                                    message: @"You have to pick a friend to continue."
                                   delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    } else {
        [self makePost:[NSNumber numberWithInt:0]];
    }
    [self dismissViewControllerAnimated:YES completion:^(void){}];
}
// handles the user touching the done button on the FB friend selector
- (void)facebookViewControllerCancelWasPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
// allows us to limit which friends get shown on the friend picker (based on the search)
- (BOOL)friendPickerViewController:(FBFriendPickerViewController *)friendPicker
                 shouldIncludeUser:(id<FBGraphUser>)user
{
    if (self.searchText && ![self.searchText isEqualToString:@""]) {
        NSRange result = [user.name
                          rangeOfString:self.searchText
                          options:NSCaseInsensitiveSearch];
        if (result.location != NSNotFound) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return YES;
    }
    return YES;
}

/**
 * A function for parsing URL parameters.
 */
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

// index is the objectAtIndex of bet.friends used to get the friend's user id
// recursivley calls itself to go through all the friend shtye selected
// on last friend, moves to next VC
- (void)makePost:(NSNumber *)index {
    
    // get facebook friend's ID from selection
    NSString* fid = ((id<FBGraphUser>)[bet.friends objectAtIndex:[index integerValue]]).id;
    
    //Make the post.
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                   @"Invitation to Betchyu", @"name",
                                   @"I just made a goal on Betchyu! Do you think I can do it?", @"caption",
                                   @"http://betchyu.com", @"link",
                                   fid, @"to",
                                   @"http://i.imgur.com/zq6D8lk.png", @"picture",
                                   @"Betchyu", @"name", nil];
    
    // attemp to post the story to friends walls
    [FBWebDialogs presentFeedDialogModallyWithSession:nil parameters:params handler:
     ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
         if (error) {
             // Error launching the dialog or publishing a story.
             NSLog(@"Error publishing story.");
         } else {
             // move on to the next VC when we're done with last friend modal post
             if ([index integerValue] == bet.friends.count-1) {
                 BetStakeVC *vc = [[BetStakeVC alloc] initWithBet:self.bet];
                 vc.title = @"Set Stake";
                 [self.navigationController pushViewController:vc animated:YES];
             }
             
             // handling differently based on what the user actually did with the modal
             if (result == FBWebDialogResultDialogNotCompleted) {
                 // User clicked the "x" icon
                 NSLog(@"User canceled story publishing.");
             } else {
                 // Handle the publish feed callback
                 NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                 if (![urlParams valueForKey:@"post_id"]) {
                     // User clicked the Cancel button
                     NSLog(@"User canceled story publishing.");
                 } else {
                     // User clicked the Share button
                     NSString *msg = [NSString stringWithFormat:
                                      @"Posted story, id: %@",
                                      [urlParams valueForKey:@"post_id"]];
                     NSLog(@"%@", msg);
                 }
             }
         }
         if (bet.friends.count > [index integerValue]+1) {
             [self performSelector:@selector(makePost:) withObject:[NSNumber numberWithInt:([index integerValue]+1)] afterDelay:0];
         }
     }];
}


#pragma mark UITextFieldDelegate shit

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

@end
