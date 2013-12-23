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

@interface ExistingBetDetailsVC ()

@end

@implementation ExistingBetDetailsVC

@synthesize betJSON;
@synthesize bet;

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
    }
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
    UILabel *stakeDescription      = [[UILabel alloc] initWithFrame:CGRectMake(10, h/2 +10, w-20, 100)];
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
                                   initWithProfileID:((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId
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
    [mainView addSubview:current];
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
    
    self.navigationItem.title = @"The Bet";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
