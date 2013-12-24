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
@synthesize stakeDescription;

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
    mainView.contentSize   = CGSizeMake(320, 1000);
    [mainView setBackgroundColor:[UIColor colorWithRed:(39/255.0) green:(37/255.0) blue:(37/255.0) alpha:1.0]];
    
    int w = mainView.frame.size.width;
    int h = mainView.frame.size.height;
    
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
    stakeDescription.font          = [UIFont fontWithName:@"ProximaNova-Regular" size:25];
    stakeDescription.textColor     = [UIColor whiteColor];
    stakeDescription.text          = [[[@"If I succeed, I win " stringByAppendingString:
                                        [bet.ownStakeAmount stringValue]] stringByAppendingString:
                                       @" "] stringByAppendingString:
                                      bet.ownStakeType];
    
    // The current state text
    UILabel *current      = [[UILabel alloc] initWithFrame:CGRectMake(10, 2*h/3 +10, w-20, 100)];
    current.numberOfLines = 0;
    current.font          = [UIFont fontWithName:@"ProximaNova-Regular" size:25];
    current.textColor     = [UIColor whiteColor];
    current.text          = [self currentStateText];
    
    ////////////////////////
    // The Profile Picture
    ////////////////////////
    int dim = w / 4;
    // the picture
    FBProfilePictureView *mypic = [[FBProfilePictureView alloc]
                                   initWithProfileID:bet.owner
                                   pictureCropping:FBProfilePictureCroppingOriginal];
    mypic.frame = CGRectMake(2, 2, dim-4, dim-4);
    mypic.layer.cornerRadius = (dim-4)/2;
    // The border
    UIView *border = [[UIView alloc] initWithFrame:CGRectMake((w/2)-(dim/2), 30, dim, dim)];
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
    int items = [betJSON valueForKey:@"current"] == [NSNull null] ? 0 : [[betJSON valueForKey:@"current"] integerValue];
    items = [bet.betAmount integerValue] - items;
    
    
    if ([bet.betVerb isEqualToString:@"Stop"]) {
        if (days != 1) {
            return [NSString stringWithFormat:@"Currently, there are %ld days to go.", days];
        } else {
            return @"Currently, there is 1 day to go.";
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
        self.stakeDescription.text = [NSString stringWithFormat:@"If your friend succeeds, you pay %@ %@, otherwise, you win %@ %@.", bet.ownStakeAmount, bet.ownStakeType, bet.opponentStakeAmount, bet.opponentStakeType];
        
        BigButton *acceptBtn = [[BigButton alloc] initWithFrame:CGRectMake(20, 2*h/3 +20, w-40, 110) primary:0 title:@"ACCEPT"];
        [acceptBtn addTarget:self action:@selector(acceptTheBet:) forControlEvents:UIControlEventTouchUpInside];
        
        BigButton *rejectBtn = [[BigButton alloc] initWithFrame:CGRectMake(20, 2*h/3 +140, w-40, 110) primary:1 title:@"REJECT"];
        [rejectBtn addTarget:self action:@selector(rejectTheBet:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:acceptBtn];
        [self.view addSubview:rejectBtn];
    } else {
        self.navigationItem.title = @"The Bet";
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
