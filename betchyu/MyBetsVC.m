//
//  MyBetsVC.m
//  betchyu
//
//  Created by Adam Baratz on 12/9/13.
//  Copyright (c) 2013 BetchyuLLC. All rights reserved.
//

#import "MyBetsVC.h"
#import "AppDelegate.h"
#import "BigButton.h"
#import "API.h"
#import "ExistingBetDetailsVC.h"
#import "BetTrackingVC.h"

@interface MyBetsVC ()

@end

@implementation MyBetsVC

@synthesize ongoingBets;
@synthesize openBets;
@synthesize openInvites;

- (id)initWithOngoingBets:(NSArray *)passedOngoingBets andOpenBets:(NSArray *)openBetsList {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        self.ongoingBets = passedOngoingBets;
        self.openBets    = openBetsList;
    }
    return self;
}

- (void)loadView {
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    //CGRect screenRect = self.view.frame;
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height - 50; // 50 px is the navbar at the top + 10 px bottom border
    int bH = screenHeight / 3.5;
    int bH2 = bH +10;
    
    // Create main UIScrollView (the container for home page buttons)
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    mainView.contentSize = CGSizeMake(screenWidth, bH2*(self.ongoingBets.count + self.openBets.count)+10 );
    [mainView setBackgroundColor:[UIColor colorWithRed:(39/255.0) green:(37/255.0) blue:(37/255.0) alpha:1.0]];
    
    NSString *betTitle;
    int c = openBets.count;
    // Make the Open Bets Button-list
    for (int i = 0; i < c; i++) {
        NSManagedObject *obj = [openBets objectAtIndex:i];
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
        
        CGRect buttonFrame = CGRectMake(20, (bH2*i)+10, (screenWidth - 40), bH);
                     
        BigButton *button = [[BigButton alloc] initWithFrame:buttonFrame
                                                     primary:1
                                                       title:betTitle];
        button.idKey = [obj valueForKey:@"id"];
        [button addTarget:self
                   action:@selector(acceptOrDeclineBet:)
         forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:button];
        
        UIImageView *star   = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star.png"]];
        star.frame = CGRectMake(279, bH2*i +1, 30, 30);
        [mainView addSubview:star];
    }
    
    // Make the Ongoing Bets Button-list
    for (int i = 0; i < ongoingBets.count; i++) {
        NSManagedObject *obj = [ongoingBets objectAtIndex:i];
        
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
        
        CGRect buttonFrame = CGRectMake(20, (bH2*i +10+(bH2*openBets.count)), (screenWidth - 40), bH);
        
        BigButton *button = [[BigButton alloc] initWithFrame:buttonFrame primary:1 title:betTitle];
        button.idKey = [obj valueForKey:@"id"];
        [button addTarget:self
         action:@selector(showBetDetails:)
         forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:button];
    }
    
    self.view = mainView;
}

-(void)acceptOrDeclineBet:(BigButton *)sender {
    // get the bet from the server
    NSString * path = [NSString stringWithFormat:@"bets/%@", sender.idKey];
    
    //make the call to the web API
    [[API sharedInstance] get:path withParams:nil onCompletion:^(NSDictionary *json) {
        //success
        ExistingBetDetailsVC *vc =[[ExistingBetDetailsVC alloc] initWithJSON:json AndOfferBool:YES];
        // Show it.
        [self.navigationController pushViewController:vc animated:true];
    }];
}
-(void)showBetDetails:(BigButton *)sender {
    // get the bet from the server
    NSString * path = [NSString stringWithFormat:@"bets/%@", sender.idKey];
    
    //make the call to the web API
    [[API sharedInstance] get:path withParams:nil onCompletion:^(NSDictionary *json) {
        //success
        ExistingBetDetailsVC *vc =[[ExistingBetDetailsVC alloc] initWithJSON:json];
        // Show it.
        [self.navigationController pushViewController:vc animated:true];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
