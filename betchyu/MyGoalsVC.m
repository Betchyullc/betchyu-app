//
//  MyGoalsVC.m
//  betchyu
//
//  Created by Daniel Zapata on 12/10/13.
//  Copyright (c) 2013 BetchyuLLC. All rights reserved.
//

#import "MyGoalsVC.h"
#import "BigButton.h"
#import "AppDelegate.h"
#import "ExistingBetDetailsVC.h"
#import "API.h"
#import "BetTrackingVC.h"

@interface MyGoalsVC ()

@end

@implementation MyGoalsVC

@synthesize bets;
@synthesize ownerId;
@synthesize buttonsAreLocked;

- (id)initWithGoals:(NSArray *)goalsList {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        self.bets = goalsList;
        buttonsAreLocked = NO;
    }
    return self;
}

- (void)loadView {
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    //CGRect screenRect = self.view.frame;
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height - 50; // 50 px is the navbar at the top + 10 px bottom border
    
    // Create main UIScrollView (the container for home page buttons)
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    mainView.contentSize   = CGSizeMake(screenWidth, 140*bets.count +100);
    [mainView setBackgroundColor:[UIColor colorWithRed:(39/255.0) green:(37/255.0) blue:(37/255.0) alpha:1.0]];

    // Accepted Goals title.
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, screenWidth - 40, 30)];
    title.text = @"Accepted";
    title.font = [UIFont fontWithName:@"ProximaNova-Black" size:26];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    [mainView addSubview:title];

    NSString *betTitle;
    int numAccepted = 0;
    // Make the Accepted Goals Buttons list
    for (int i = 0; i < bets.count; i++) {
        NSManagedObject *obj = [bets objectAtIndex:i];
        
        if ([obj valueForKey:@"opponent"] == [NSNull null]) { continue; }
        
        if ([[obj valueForKey:@"betNoun"] isEqualToString:@"cigarettes"]
            || [[obj valueForKey:@"betNoun"] isEqualToString:@"Smoking"]) {
            betTitle = @"Stop Smoking";
        } else {
            betTitle = [NSString stringWithFormat:@"%@ %@ %@",
                        [obj valueForKey:@"betVerb"],
                        [obj valueForKey:@"betAmount"],
                        [obj valueForKey:@"betNoun"]];
        }
        CGRect buttonFrame = CGRectMake(20, (140*numAccepted +50), (screenWidth - 40), 140 -10);
        
        BigButton *button = [[BigButton alloc] initWithFrame:buttonFrame
                                                     primary:1
                                                       title:betTitle
                                                       ident:[obj valueForKey:@"id"]];
        
        [button addTarget:self
         action:@selector(viewBetDetails:)
         forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:button];
        
        numAccepted++;
    }
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, (140*numAccepted +50), screenWidth - 40, 2)];
    line.backgroundColor = [UIColor whiteColor];
    [mainView addSubview:line];
    
    // Pending Goals
    UILabel *pending = [[UILabel alloc] initWithFrame:CGRectMake(20, (140*numAccepted +50)+10, screenWidth - 40, 30)];
    pending.font = [UIFont fontWithName:@"ProximaNova-Black" size:26];
    pending.textAlignment = NSTextAlignmentCenter;
    pending.textColor = [UIColor whiteColor];
    pending.text = @"Pending";
    [mainView addSubview:pending];
    
    int numPending = 0;
    // Make the Pending Goals Buttons list
    for (int i = 0; i < bets.count; i++) {
        NSManagedObject *obj = [bets objectAtIndex:i];
        
        if ([obj valueForKey:@"opponent"] != [NSNull null]) { continue; }
        
        if ([[obj valueForKey:@"betNoun"] isEqualToString:@"cigarettes"]
            || [[obj valueForKey:@"betNoun"] isEqualToString:@"Smoking"]) {
            betTitle = @"Stop Smoking";
        } else {
            betTitle = [[[[[obj valueForKey:@"betVerb"] stringByAppendingString:
                           @" " ] stringByAppendingString:
                          [[obj valueForKey:@"betAmount"] stringValue]] stringByAppendingString:
                         @" "] stringByAppendingString:
                        [obj valueForKey:@"betNoun"]];
        }
        CGRect buttonFrame = CGRectMake(20, (140*(numPending+numAccepted) +60+35), (screenWidth - 40), 140 -10);
        
        BigButton *button = [[BigButton alloc] initWithFrame:buttonFrame
                                                     primary:1
                                                       title:betTitle
                                                       ident:[obj valueForKey:@"id"]];
        
        [button addTarget:self
                   action:@selector(viewBetDetails:)
         forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:button];
        numPending++;
    }
    
    self.view = mainView;
}

-(void)viewBetDetails:(BigButton *)sender {
    if (self.buttonsAreLocked) { return; }
    self.buttonsAreLocked = YES;            // these lines prevent from lag allowing users to open 2 goals at once like idiots.
    // get the bet from the server
    NSString * path = [NSString stringWithFormat:@"bets/%@", sender.idKey];
    
    //make the call to the web API
    [[API sharedInstance] get:path withParams:nil onCompletion:^(NSDictionary *json) {
        //success
        BetTrackingVC *vc =[[BetTrackingVC alloc] initWithJSON:json];
        // Show it.
        [self.navigationController pushViewController:vc animated:true];
        self.buttonsAreLocked = NO;            // allows user who comes back to this page to go to a new page
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.bets.count == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Umm..."
                                    message:@"You don't have any goals yet. You should make one!"
                                   delegate:nil
                          cancelButtonTitle:@"OK!"
                          otherButtonTitles:nil]
         show];
    }
}

@end
