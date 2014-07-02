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
@synthesize durationLabel;

@synthesize fbFriendVC;
@synthesize searchBar;
@synthesize searchText;
@synthesize initialInput;

- (id)initWithBetVerb:(NSString *)verbName {
    self = [super init];
    if (self) {
        // Custom initialization
        self.screenName = @"Bet Options (step 2)";
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
        
        
        // pre-load the facebook shit
        if (!fbFriendVC) {
            fbFriendVC = [[FBFriendPickerViewController alloc] initWithNibName:nil bundle:nil];
            // Set the friend picker delegate
            fbFriendVC.delegate = self;
            
            fbFriendVC.title = @"Choose Opponents";
        }
        
        [fbFriendVC loadData];

    }
    return self;
}

- (void) loadView {
    
    CGRect f = [UIScreen mainScreen].applicationFrame;

    int y = self.navigationController.navigationBar.frame.size.height + f.origin.y; // navBar + statusBar
    int h = f.size.height - y;
    
    CGRect f2 = CGRectMake(f.origin.x, y, f.size.width, h);
    
    self.view = [TouchesBeganHelper new];
    ((TouchesBeganHelper *)self.view).vc = self;
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
    CGRect lFr = ((UIView *)[[self.view subviews] lastObject]).frame;
    ((UIScrollView *)self.view).contentSize = CGSizeMake(f2.size.width, lFr.size.height + lFr.origin.y);
}


-(UIView *)getBinarySubview {
    // convinience variables
    int fontSize = 18;
    int h = self.view.frame.size.height;
    int w = self.view.frame.size.width;
    // The thing we return. it has a shadow at the bottom of it
    UIView *main = [[UIView alloc] initWithFrame:CGRectMake(0, 2*h/5, w, 250)];
    
    // The Label stating your intention @"I will not smoke:"
    UILabel *goalAmountLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 9, w-15, fontSize+2)];
    goalAmountLabel.text = [NSString stringWithFormat:@"I will %@ %@ for:", bet.verb, bet.noun];
    goalAmountLabel.font = FregfS;
    goalAmountLabel.textColor = Bmid;
    [main addSubview:goalAmountLabel];
    CGRect gf = goalAmountLabel.frame;
    gf.size.height = gf.size.height + 20; // add some padding
    
    // formally set the amount ot 0.0, which indicates binaryness
    bet.amount = [NSNumber numberWithFloat:0.0f];
    detailLabel1 = [UILabel new];
    detailLabel1.text = @"this is just to not trigger the error for not setting this";
    
    // UILabel "x days"
    [self setupDurationLabelFromFrame:CGRectMake(15, gf.size.height + 9, w-30, fontSize+2) AndFontSize:fontSize];
    [main addSubview:self.durationLabel];
    
    // UISlider that choses Date
    UISlider * s2 = [self makeDateScrollerFromFrame:CGRectMake(20, 40, w-40, h/5)];
    [main addSubview:s2];
    
    // the uilabel saying @"EndDate:"
    UILabel * endDateLabel  = [[UILabel alloc] initWithFrame:CGRectMake(15, s2.frame.origin.y + s2.frame.size.height, w-30, fontSize+2)];
    endDateLabel.text       = @"End Date:";
    endDateLabel.textColor  = Bmid;
    endDateLabel.font       = FregfS;
    [main addSubview:endDateLabel];
    
    detailLabel2 = [[UILabel alloc] initWithFrame:endDateLabel.frame];
    detailLabel2.textAlignment = NSTextAlignmentCenter;
    detailLabel2.text       = @"";
    detailLabel2.textColor  = Borange;
    detailLabel2.font       = FregfS;
    [main addSubview:detailLabel2];
    
    // The green "Choose Opponent" button at the bottom
    UIButton *nextBtn = [self getChooseOpponentsButton:detailLabel2.frame WithWidth:w AndFontSize:fontSize];
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
    int h = self.view.frame.size.height;
    int w = self.view.frame.size.width;
    int fontSize = w>500 ? 22 : 18;
    // The thing we return. it has a shadow at the bottom of it
    TouchesBeganHelper *main = [[TouchesBeganHelper alloc] initWithFrame:CGRectMake(0, 2*h/5 , w, 250)];
    main.vc = self;
    
    UILabel *startingFromLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 9, w-15, fontSize+2)];
    startingFromLab.text = w > 500 ? @"Starting From:\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tlbs" : @"Starting From:\t\t\t\t\t  lbs";
    startingFromLab.font = FregfS;
    startingFromLab.textColor = Bmid;
    [main addSubview:startingFromLab];
    
    self.initialInput                   = [[UITextField alloc] initWithFrame:CGRectMake(w/2, 9, w/4, fontSize+4)];
    self.initialInput.keyboardType      = UIKeyboardTypeNumberPad;
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
    goalAmountLabel.font = FregfS;
    goalAmountLabel.textColor = Bmid;
    [main addSubview:goalAmountLabel];
    
    // the uilabel that changes with the position of the slider
    self.detailLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, goalAmountLabel.frame.origin.y, w, fontSize+2)];
    detailLabel1.text = @"";
    detailLabel1.font = FregfS;
    detailLabel1.textColor = Borange;
    detailLabel1.textAlignment = NSTextAlignmentCenter;
    [main addSubview:self.detailLabel1];
    
    // the uislider that determines bet.amount
    UISlider *slider   = [[UISlider alloc] initWithFrame:CGRectMake(20, detailLabel1.frame.origin.y, w-40, h/5)];
    [slider setMinimumTrackTintColor:Borange];
    [slider setThumbImage:[UIImage imageNamed:@"1.jpg"] forState:UIControlStateNormal];
    slider.thumbTintColor = Borange;
    slider.maximumValue = 10;
    [slider addTarget:self
               action:@selector(updateSliderValue:)
     forControlEvents:UIControlEventValueChanged];
    [main addSubview:slider];
    
    // UILabel "In:"
    UILabel *inL = [self getInLabelFromFrame:CGRectMake(15, slider.frame.origin.y + slider.frame.size.height - fontSize/2, w-30, fontSize+2) AndFontSize:fontSize];
    [main addSubview:inL];
    
    // UILabel "x days"
    [self setupDurationLabelFromFrame:inL.frame AndFontSize:fontSize];
    [main addSubview:self.durationLabel];
    
    // UISlider that choses Date
    UISlider * s2 = [self makeDateScrollerFromFrame:CGRectMake(20, inL.frame.origin.y, w-40, h/5)];
    [main addSubview:s2];
    
    // the uilabel saying @"EndDate:"
    UILabel * endDateLabel  = [[UILabel alloc] initWithFrame:CGRectMake(15, s2.frame.origin.y + s2.frame.size.height, w-30, fontSize+2)];
    endDateLabel.text       = @"End Date:";
    endDateLabel.textColor  = Bmid;
    endDateLabel.font       = FregfS;
    [main addSubview:endDateLabel];
    
    detailLabel2 = [[UILabel alloc] initWithFrame:endDateLabel.frame];
    detailLabel2.textAlignment = NSTextAlignmentCenter;
    detailLabel2.text       = @"";
    detailLabel2.textColor  = Borange;
    detailLabel2.font       = FregfS;
    [main addSubview:detailLabel2];
    
    // The green "Choose Opponent" button at the bottom
    UIButton *nextBtn = [self getChooseOpponentsButton:detailLabel2.frame WithWidth:w AndFontSize:fontSize];
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
    BOOL isWorkout = [[[bet valueForKey:@"verb"] lowercaseString] isEqualToString:@"workout"];
    // The thing we return. it has a shadow at the bottom of it
    UIView *main = [[UIView alloc] initWithFrame:CGRectMake(0, 2*h/5, w, 250)];

    // The Label stating your tintention @"I will run:"
    UILabel *goalAmountLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 9, w-15, fontSize+2)];
    goalAmountLabel.text = [NSString stringWithFormat:@"I will %@:", bet.verb];
    goalAmountLabel.font = FregfS;
    goalAmountLabel.textColor = Bmid;
    [main addSubview:goalAmountLabel];
    
    // the uilabel that changes with the position of the slider
    self.detailLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 9, w, fontSize+2)];
    detailLabel1.text = @"";
    detailLabel1.font = FregfS;
    detailLabel1.textColor = Borange;
    detailLabel1.textAlignment = NSTextAlignmentCenter;
    [main addSubview:self.detailLabel1];
    
    // the uislider that determines bet.amount
    UISlider *slider   = [[UISlider alloc] initWithFrame:CGRectMake(20, 20, w-40, h/5)];
    [slider setMinimumTrackTintColor:Borange];
    [slider setThumbImage:[UIImage imageNamed:@"1.jpg"] forState:UIControlStateNormal];
    slider.thumbTintColor = Borange;
    slider.maximumValue = isWorkout ? 30 : 300;
    [slider addTarget:self
                action:@selector(updateSliderValue:)
      forControlEvents:UIControlEventValueChanged];
    [main addSubview:slider];
    
    // UILabel "In:"
    UILabel *inL = [self getInLabelFromFrame:CGRectMake(15, h/5, w-30, fontSize+2) AndFontSize:fontSize];
    [main addSubview:inL];
    
    // UILabel "x days"
    [self setupDurationLabelFromFrame:inL.frame AndFontSize:fontSize];
    [main addSubview:self.durationLabel];
    
    // UISlider that choses Date
    UISlider * s2 = [self makeDateScrollerFromFrame:CGRectMake(20, 20 + h/6, w-40, h/5)];
    [main addSubview:s2];
    
    // the uilabel saying @"EndDate:"
    UILabel * endDateLabel  = [[UILabel alloc] initWithFrame:CGRectMake(15, s2.frame.origin.y + s2.frame.size.height, w-30, fontSize+2)];
    endDateLabel.text       = @"End Date:";
    endDateLabel.textColor  = Bmid;
    endDateLabel.font       = FregfS;
    [main addSubview:endDateLabel];
    
    detailLabel2 = [[UILabel alloc] initWithFrame:endDateLabel.frame];
    detailLabel2.textAlignment = NSTextAlignmentCenter;
    detailLabel2.text       = @"";
    detailLabel2.textColor  = Borange;
    detailLabel2.font       = FregfS;
    [main addSubview:detailLabel2];

    // The green "Choose Opponent" button at the bottom
    UIButton *nextBtn = [self getChooseOpponentsButton:detailLabel2.frame WithWidth:w AndFontSize:fontSize];
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
-(void) setupDurationLabelFromFrame:(CGRect)frame AndFontSize:(int)fontSize {
    durationLabel = [[UILabel alloc] initWithFrame:frame];
    durationLabel.text = @"";
    durationLabel.font = FregfS;
    durationLabel.textColor = Borange;
    durationLabel.textAlignment = NSTextAlignmentCenter;
}
-(UILabel *) getInLabelFromFrame:(CGRect)frame AndFontSize:(int)fontSize {
    UILabel *lbl = [[UILabel alloc]initWithFrame:frame];
    lbl.text = @"In:";
    lbl.font = FregfS;
    lbl.textColor = Bmid;
    
    return lbl;
}
-(UISlider *) makeDateScrollerFromFrame:(CGRect)frame {
    UISlider *slider   = [[UISlider alloc] initWithFrame:frame];
    [slider setMinimumTrackTintColor:Borange];
    [slider setThumbImage:[UIImage imageNamed:@"1.jpg"] forState:UIControlStateNormal];
    slider.thumbTintColor = Borange;
    slider.maximumValue = 30;
    slider.minimumValue = 3;
    [slider addTarget:self
               action:@selector(updateDateValue:)
     forControlEvents:UIControlEventValueChanged];
    return slider;
}
-(UIButton *)getChooseOpponentsButton:(CGRect)openCalendarFrame WithWidth:(int)w AndFontSize:(int)fontSize {

    UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, openCalendarFrame.size.height + openCalendarFrame.origin.y + 10, w, 60)];
    nextBtn.backgroundColor = Bgreen;
    [nextBtn setTitle:@"Choose Opponents" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(chooseOpponents:) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.tintColor = [UIColor whiteColor];
    nextBtn.titleLabel.font =[UIFont fontWithName:@"ProximaNova-Black" size:fontSize];
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow-16.png"]];
    arrow.image     = [arrow.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    arrow.tintColor = [UIColor whiteColor];
    arrow.frame     = CGRectMake(w-30, 22, 8, 15);
    [nextBtn addSubview:arrow];
    
    return nextBtn;
}

/// handles the amount of the bet
-(void)updateSliderValue:(UISlider *)sender {
    int val = (int)(sender.value+1);
    // update what they can see
    detailLabel1.text = [NSString stringWithFormat:@"%i %@", val, bet.noun];
    // update the data we pass on
    bet.amount = [NSNumber numberWithInt:val];
}

/// handles the duration of the bet
-(void)updateDateValue:(UISlider *)sender {
    // update what they can see
    int amount = (int)roundf(sender.value);
    
    NSDateComponents *components = [NSDateComponents new];
    components.day = amount;
    NSDate* maxDate = [[NSCalendar currentCalendar]dateByAddingComponents:components
                                                                   toDate:[NSDate date]
                                                                  options:0];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    NSString *theDate = [dateFormatter stringFromDate:maxDate];
    
    self.detailLabel2.text = theDate; // written-out date
    self.durationLabel.text = [NSString stringWithFormat:@"%i days", amount]; // number of days
    // update the data we pass on
    self.bet.duration = [NSNumber numberWithInt:amount];
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
        
        [self.fbFriendVC.canvasView addSubview:self.searchBar];
        CGRect newFrame = self.fbFriendVC.view.bounds;
        newFrame.size.height -= searchBarHeight;
        newFrame.origin.y = searchBarHeight;
        self.fbFriendVC.tableView.frame = newFrame;
    }
}
- (void) handleSearch:(UISearchBar *)search {
    [search resignFirstResponder];
    self.searchText = searchBar.text;
    [self.fbFriendVC updateView];
}
- (void)searchBarSearchButtonClicked:(UISearchBar*)search {
    [self handleSearch:search];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) search {
    self.searchText = nil;
    [search resignFirstResponder];
    [self.fbFriendVC updateView];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)search {
    self.searchText = search;
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
        [[[UIAlertView alloc] initWithTitle:@"Friends" message:@"Post to your friend's wall to let them know about your goal!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        
        [self makePost:[NSNumber numberWithInt:0]];
    }
    //[self dismissViewControllerAnimated:YES completion:^(void){}];
}
// handles the user touching the done button on the FB friend selector
- (void)facebookViewControllerCancelWasPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
// allows us to limit which friends get shown on the friend picker (based on the search)
- (BOOL)friendPickerViewController:(FBFriendPickerViewController *)friendPicker shouldIncludeUser:(id<FBGraphUser>)user {
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
    // May return nil if a tracker has not already been initialized with a property
    // ID.
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    id canceledEvent = [[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
                                            action:@"button_press"  // Event action (required)
                                             label:@"Cancel Facebook Post"        // Event label
                                             value:nil] build];    // Event value
    
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
                 [self dismissViewControllerAnimated:YES completion:^(void){ // gets rid of the fbVC
                     BetStakeVC *vc = [[BetStakeVC alloc] initWithBet:self.bet];
                     vc.title = @"Set Stake";
                     [self.navigationController pushViewController:vc animated:YES];
                 }];
             }
             
             // handling differently based on what the user actually did with the modal
             if (result == FBWebDialogResultDialogNotCompleted) {
                 // User clicked the "x" icon
                 [tracker send:canceledEvent];
             } else {
                 // Handle the publish feed callback
                 NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                 if (![urlParams valueForKey:@"post_id"]) {
                     // User clicked the Cancel button
                     [tracker send:canceledEvent];
                 } else {
                     // User clicked the Share button
                     id postEvent = [[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
                                                                                action:@"button_press"  // Event action (required)
                                                                                 label:@"Post to Facebook"        // Event label
                                                                                 value:[urlParams valueForKey:@"post_id"]] build];    // Event value
                     [tracker send:postEvent];
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
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location == NSNotFound) {
        return YES;
    } else {
        return NO;
    }
}

@end
