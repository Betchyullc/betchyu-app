//
//  ExistingBetDetailsVC.m
//  betchyu
//
//  Created by Adam Baratz on 12/16/13.
//  Copyright (c) 2013 BetchyuLLC. All rights reserved.
//

#import "ExistingBetDetailsVC.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import "BigButton.h"
#import "API.h"

@interface ExistingBetDetailsVC ()

@end

@implementation ExistingBetDetailsVC

@synthesize betJSON;
@synthesize bet;
@synthesize isOffer;
@synthesize isOwn;
@synthesize stakeDescription;
@synthesize current;
@synthesize updates;

// ===== Initializers ===== //
- (id)initWithJSON:(NSDictionary *)json {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        self.betJSON = json;
        self.bet = [[TempBet alloc] init];
        self.bet.endDate = [dateFormatter dateFromString:[betJSON valueForKey:@"endDate"]];
        self.bet.createdAt = [dateFormatter dateFromString: [[betJSON valueForKey:@"created_at"] substringWithRange:NSMakeRange(0, 10)]];
        self.bet.betVerb = [betJSON valueForKey:@"betVerb"];
        self.bet.betNoun = [betJSON valueForKey:@"betNoun"];
        self.bet.betAmount = [betJSON valueForKey:@"betAmount"];
        self.bet.ownStakeAmount = [betJSON valueForKey:@"ownStakeAmount"];
        self.bet.ownStakeType = [betJSON valueForKey:@"ownStakeType"];
        self.bet.opponentStakeAmount = [betJSON valueForKey:@"opponentStakeAmount"];
        self.bet.opponentStakeType = [betJSON valueForKey:@"opponentStakeType"];
        self.bet.owner = [betJSON valueForKey:@"owner"];
        
        self.isOffer = NO;
        self.isOwn = NO;
        
        NSString* path =[NSString stringWithFormat:@"bets/%@/updates", [betJSON valueForKey:@"id"]];
        
        //make the call to the web API to get the updates for this bet
        // GET /bets/:bet_id/updates => {data}
        [[API sharedInstance] get:path withParams:nil onCompletion:^(NSDictionary *json) {
            //success
            self.updates = (NSArray*)json;
            [self checkForCompletedBet];
        }];
    }
    return self;
}
- (id)initWithJSON:(NSDictionary *)json AndOfferBool:(BOOL)passedOffer{
    self = [self initWithJSON:json];
    self.isOffer = passedOffer;
    return self;
}

- (void)loadView {
    // Create main UIScrollView (the container for home page buttons)
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    int w = mainView.frame.size.width;
    int h = mainView.frame.size.height;
    mainView.contentSize   = CGSizeMake(w, 2*h/3 +120);
    [mainView setBackgroundColor:[UIColor colorWithRed:(39/255.0) green:(37/255.0) blue:(37/255.0) alpha:1.0]];
    
    // The bet-type image
    UIImageView *img;
    /*if ([bet.betVerb isEqualToString:@"Stop"]) {
        img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Stop Smoking.jpg"]];
    } else if ([bet.betVerb isEqualToString:@"Run"]){
        img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Run More.jpg"]];
    } else if ([bet.betVerb isEqualToString:@"Workout"]){
        img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Workout More.jpg"]];
    } else if ([bet.betVerb isEqualToString:@"Lose"]){
        img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Lose Weight.jpg"]];
    } else {*/
        img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"handshake.jpg"]];
    //}
    img.frame = CGRectMake(0, 0, w, h/2);
    
    // The bet summary text
    UILabel *heading      = [[UILabel alloc] initWithFrame:CGRectMake(0, h/2 - 100, w, 40)];
    heading.textAlignment = NSTextAlignmentCenter;
    heading.font          = [UIFont fontWithName:@"ProximaNova-Black" size:27];
    heading.textColor     = [UIColor whiteColor];
    heading.text          = @"THE GOAL:";
    
    // The bet summary text
    UILabel *betDescription      = [[UILabel alloc] initWithFrame:CGRectMake(0, h/2 - 60, w, 40)];
    betDescription.textAlignment = NSTextAlignmentCenter;
    betDescription.font          = [UIFont fontWithName:@"ProximaNova-Regular" size:25];
    betDescription.textColor     = [UIColor whiteColor];
    betDescription.text          = [self readableBetTitle];
    
    // The stake summary text
    self.stakeDescription          = [[UILabel alloc] initWithFrame:CGRectMake(10, h/2 +10, w-20, 100)];
    stakeDescription.numberOfLines = 0;
    stakeDescription.textColor     = [UIColor whiteColor];
    if ([bet.ownStakeType isEqualToString:@"Amazon Gift Card"]) {
        stakeDescription.text = [NSString stringWithFormat:@"If I successfully complete my challenge, you owe me a $%@ %@.", bet.ownStakeAmount, bet.ownStakeType];
    } else if ([bet.ownStakeAmount integerValue] == 1) {
        stakeDescription.text = [NSString stringWithFormat:@"If I successfully complete my challenge, you owe me %@ %@.", bet.ownStakeAmount, bet.ownStakeType];
    } else {
        stakeDescription.text = [NSString stringWithFormat:@"If I successfully complete my challenge, you owe me %@ %@s.", bet.ownStakeAmount, bet.ownStakeType];
    }
    
    // The current state text
    self.current               = [[UILabel alloc] initWithFrame:CGRectMake(10, 2*h/3 +10, w-20, 100)];
    self.current.numberOfLines = 0;
    self.current.textColor     = [UIColor whiteColor];
    self.current.text          = [self currentStateText]; // string formatter
    
    
    //fonts
    
    if (h > 500) {
        current.font          = [UIFont fontWithName:@"ProximaNova-Regular" size:25];
        stakeDescription.font = [UIFont fontWithName:@"ProximaNova-Regular" size:25];
    } else {
        current.font          = [UIFont fontWithName:@"ProximaNova-Regular" size:22];
        stakeDescription.font = [UIFont fontWithName:@"ProximaNova-Regular" size:22];
        self.stakeDescription.frame = CGRectMake(10, h/2, w-20, 90);
    }
    
    ////////////////////////
    // The Profile Picture
    ////////////////////////
    int dim = w / 4;
    FBProfilePictureView *mypic2;
    UIView *border2;
    
    // the Owner's picture
    FBProfilePictureView *mypic = [[FBProfilePictureView alloc] initWithProfileID:bet.owner pictureCropping:FBProfilePictureCroppingSquare];
    mypic.frame = CGRectMake(2, 2, dim-4, dim-4);
    mypic.layer.cornerRadius = (dim-4)/2;
    UIView *border;
    
    if ([betJSON valueForKey:@"opponent"] != [NSNull null]) {
        // the Opponent's picture
        mypic2 = [[FBProfilePictureView alloc] initWithProfileID:[betJSON valueForKey:@"opponent"] pictureCropping:FBProfilePictureCroppingSquare];
        mypic2.frame = CGRectMake(2, 2, dim-4, dim-4);
        mypic2.layer.cornerRadius = (dim-4)/2;
        // The border
        border2 = [[UIView alloc] initWithFrame:CGRectMake((3*w/4)-(dim/2), 30, dim, dim)];
        border2.backgroundColor = [UIColor whiteColor];
        border2.layer.cornerRadius = dim/2;
        
        [border2 addSubview:mypic2];
        
        border = [[UIView alloc] initWithFrame:CGRectMake((w/4)-(dim/2), 30, dim, dim)];
    } else {
        border = [[UIView alloc] initWithFrame:CGRectMake((w/2)-(dim/2), 30, dim, dim)];
    }
    
    // The border for the owner's picture
    border.backgroundColor = [UIColor whiteColor];
    border.layer.cornerRadius = dim/2;
    [border addSubview:mypic];

    
    // Add the subviews
    [mainView addSubview:img];    // add the handshake image first, so it is under the other stuff
    [mainView addSubview:betDescription];
    [mainView addSubview:stakeDescription];
    [mainView addSubview:heading];
    if (!self.isOffer) {
        [mainView addSubview:current];
    }
    [mainView addSubview:border];
    if (border2) {
        [mainView addSubview:border2];
    }
    
    self.view = mainView;
}

-(NSString *)readableBetTitle {
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:bet.createdAt
                                                          toDate:bet.endDate
                                                         options:0];
    long days =(long)[components day];
    if ([bet.betVerb isEqualToString:@"Stop"]) {
        if (days > 1) {
            return [NSString stringWithFormat:@"stop smoking for %ld days", days];
        } else {
            return @"stop smoking for 1 day";
        }
    } else {
        if (days > 1) {
            return [NSString stringWithFormat:@"%@ %@ %@ in %ld days", bet.betVerb, bet.betAmount, bet.betNoun, days];
        } else {
            return [NSString stringWithFormat:@"%@ %@ %@ in 1 day", bet.betVerb, bet.betAmount, bet.betNoun];
        }
    }
}

-(NSString *)currentStateText {
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:[NSDate date]
                                                          toDate:bet.endDate
                                                         options:0];
    long days =(long)[components day];
    int items = [betJSON valueForKey:@"current"] == [NSNull null] ? 0 : [[betJSON valueForKey:@"current"] intValue];
    items = [bet.betAmount integerValue] - items;
    
    
    if ([bet.betVerb isEqualToString:@"Stop"]) {
        if (days != 1) {
            return [NSString stringWithFormat:@"Currently, there are %ld days to go.", days];
        } else {
            return @"Currently, there is 1 day to go.";
        }
    } else if ([bet.betVerb isEqualToString:@"Lose"]) {     // handle the weight-loss bet
        items = [betJSON valueForKey:@"current"] == [NSNull null] ? 0 : [[betJSON valueForKey:@"current"] intValue];
        if (items == 0) {
            items = [self.bet.betAmount intValue] - items;
            if (days != 1) {
                return [NSString stringWithFormat:@"Currently, there are %ld days to go, and %d %@ to %@", days, items, self.bet.betNoun, self.bet.betVerb];
            } else {
                return [NSString stringWithFormat:@"Currently, there is 1 day to go, and %d %@ to %@", items, self.bet.betNoun, self.bet.betVerb];
            }
        } else {
            NSString* path =[NSString stringWithFormat:@"bets/%@/updates", [betJSON valueForKey:@"id"]];
            
            //make the call to the web API
            // GET /bets/:bet_id/updates => {data}
            [[API sharedInstance] get:path withParams:nil onCompletion:^(NSDictionary *json) {
                //success
                if (((NSArray*)json).count > 0) {
                    int val = [[[((NSArray*)json) objectAtIndex:(((NSArray*)json).count-1)] valueForKey:@"value"] intValue];
                    self.current.text = [NSString stringWithFormat:@"Currently, there are %ld days to go, and %i pounds to lose.", days, [self.bet.betAmount integerValue] - (items - val)];
                } else {
                    if (days != 1) {
                        self.current.text = [NSString stringWithFormat:@"Currently, there are %ld days to go, and %@ pounds to lose.", days, self.bet.betAmount];
                    } else {
                        self.current.text = [NSString stringWithFormat:@"Currently, there is 1 day to go, and %@ pounds to lose.", self.bet.betAmount];
                    }
                }
            }];
            if (days != 1) {
                return [NSString stringWithFormat:@"Currently, there are %ld days to go.", days];
            } else {
                return @"Currently, there is 1 day to go.";
            }
        }
        
    } else {
        if (days != 1) {
            return [NSString stringWithFormat:@"Currently, there are %ld days to go, and %d %@ to %@", days, items, self.bet.betNoun, self.bet.betVerb];
        } else {
            return [NSString stringWithFormat:@"Currently, there is 1 day to go, and %d %@ to %@", items, self.bet.betNoun, self.bet.betVerb];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (self.isOffer) {
        int w = self.view.frame.size.width;
        int h = self.view.frame.size.height;
        
        self.navigationItem.title = @"The Offer";
        if ([bet.ownStakeType isEqualToString:@"Amazon Gift Card"]) {     // handle the weight-loss bet
            self.stakeDescription.text = [NSString stringWithFormat:@"If your friend succeeds, you pay a $%@ %@, otherwise, you win one.", bet.ownStakeAmount, bet.ownStakeType];
        } else {
            if ([bet.ownStakeAmount integerValue] == 1) {
                self.stakeDescription.text = [NSString stringWithFormat:@"If your friend succeeds, you pay %@ %@, otherwise, you win one.", bet.ownStakeAmount, bet.ownStakeType];
            } else {
                self.stakeDescription.text = [NSString stringWithFormat:@"If your friend succeeds, you pay %@ %@s, otherwise, you win them.", bet.ownStakeAmount, bet.ownStakeType];
            }
        }
        
        BigButton *acceptBtn = [[BigButton alloc] initWithFrame:CGRectMake(20, 2*h/3 +20, w-40, 110) primary:0 title:@"ACCEPT"];
        [acceptBtn addTarget:self action:@selector(acceptTheBet:) forControlEvents:UIControlEventTouchUpInside];
        
        BigButton *rejectBtn = [[BigButton alloc] initWithFrame:CGRectMake(20, 2*h/3 +140, w-40, 110) primary:1 title:@"REJECT"];
        [rejectBtn addTarget:self action:@selector(rejectTheBet:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:acceptBtn];
        [self.view addSubview:rejectBtn];
        ((UIScrollView *) self.view).contentSize = CGSizeMake(w, 2*h/3 +140 +110 +20);
    } else {
        self.navigationItem.title = @"The Bet";
    }
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
-(void)checkForCompletedBet {
    
    if (self.isOwn || self.isOffer) { return; }
    
    int items = [betJSON valueForKey:@"current"] == [NSNull null] ? 0 : [[betJSON valueForKey:@"current"] integerValue];
    items = [bet.betAmount integerValue] - items;
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:[NSDate date]
                                                          toDate:bet.endDate
                                                         options:0];
    
    if ([bet.betVerb isEqualToString:@"Stop"]) {
        for (NSDictionary *obj in self.updates) {
            if ([[obj valueForKey:@"value"] integerValue] == 0){ // 0 => betowner missed a day
                // handle win and break execution
                [self winAndAsk];
                return;
            }
        }
        if (components.day <= 0) {
            if (self.updates.count == 0) {
                [self winAndAsk];   // they never put in data, so we win.
            } else {                // else they lost, handle win and break execution
                [self loseAndAsk];
            }
        }
        // else/after, gg from this method.
        return;
    } else if ([bet.betNoun isEqualToString:@"pounds"]) {
        // if the latest update is smaller than the goal weight
        if ((self.updates.count > 0) &&
            (([bet.current intValue] - [bet.betAmount intValue]) == [[[updates lastObject] valueForKey:@"value"] integerValue])) {
            
            [self loseAndAsk];
        } else if (components.day <= 0) {
            [self winAndAsk];
        }
        return;  // bail to prevent other checks from being run--we ran everything we need to already.
    }

    
    if (!self.isOffer && items <= 0) {
        // the bet is over, alert them.
        [self loseAndAsk];
    } else if (!self.isOffer && components.day <=0) {
        [self winAndAsk];
    }
}

-(void)acceptTheBet:(id)sender {
    NSString *path =[NSString stringWithFormat:@"bets/%@", [betJSON valueForKey:@"id"]];
    NSString *ownId = ((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId;
    NSMutableDictionary* params =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  ownId, @"opponent",
                                  nil];
    
    //make the call to the web API
    // PUT /bets/:bet_id => {data}
    [[API sharedInstance] put:path withParams:params onCompletion:
     ^(NSDictionary *json) {
         //success
         // Show the result in an alert
         [[[UIAlertView alloc] initWithTitle:@"Result"
          message:@"You have accepted your friend's bet. Be sure to pay out if you lose, and collect if you win."
          delegate:nil
          cancelButtonTitle:@"OK!"
          otherButtonTitles:nil]
          show];
         [self.navigationController popToRootViewControllerAnimated:YES];
     }];
}
-(void)rejectTheBet:(id)sender {
    NSString *path =[NSString stringWithFormat:@"bets/%@", [betJSON valueForKey:@"id"]];
    NSString *ownId = ((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId;
    NSMutableDictionary* params =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  ownId, @"reject",
                                  nil];
    
    //make the call to the web API
    // GET /bets/:bet_id?reject=OWNID => rejects the bet invite
    [[API sharedInstance] get:path withParams:params onCompletion:
     ^(NSDictionary *json) {
         //success
         // Show the result in an alert
         [[[UIAlertView alloc] initWithTitle:@"Result"
                                     message:@"You have rejected your friend's bet. Which is lame..."
                                    delegate:nil
                           cancelButtonTitle:@"OK!"
                           otherButtonTitles:nil]
          show];
         [self.navigationController popToRootViewControllerAnimated:YES];
     }];
}

// help methods to pop up the appropriate UIAlert and handle the user's response
-(void)loseAndAsk {
    UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setTitle:@"Bet Finished!"];
    [alert setMessage:@"You lose the bet! Have you paid your friend the prize yet?"];
    [alert setDelegate:self];
    [alert addButtonWithTitle:@"Yes"];
    [alert addButtonWithTitle:@"No"];
    [alert show];
}
-(void)winAndAsk {
    UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setTitle:@"Bet Finished!"];
    [alert setMessage:@"You win this bet! Has your friend paid you yet?"];
    [alert setDelegate:self];
    [alert addButtonWithTitle:@"Yes"];
    [alert addButtonWithTitle:@"No"];
    [alert show];
}

#pragma mark - UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // Yes, bet payment was received
        NSString* path =[NSString stringWithFormat:@"bets/%@", [betJSON valueForKey:@"id"]];
        NSMutableDictionary* params;
        if ([alertView.message isEqualToString:@"You lose the bet! Have you paid your friend the prize yet?"]) {
            params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"true", @"paid", nil];
        } else {
            params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"true", @"received", nil];
        }
        // PUT /bets/:id = {received=> true}
        [[API sharedInstance] put:path withParams:params onCompletion:
         ^(NSDictionary *json) {
             //success do nothing...
         }];
    }
    else if (buttonIndex == 1) {
        // No, bet payment was not received
        // set bet.received on server to false
        NSString* path =[NSString stringWithFormat:@"bets/%@", [betJSON valueForKey:@"id"]];
        NSMutableDictionary* params;
        if ([alertView.message isEqualToString:@"You lose the bet! Have you paid your friend the prize yet?"]) {
            params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"false", @"paid", nil];
        } else {
            params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"false", @"received", nil];
        }
        // PUT /bets/:id = {received=> true}
        [[API sharedInstance] put:path withParams:params onCompletion:
         ^(NSDictionary *json) {
             //success do nothing...
         }];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
