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
@synthesize moc;
@synthesize ownerId;

- (id)initWithGoals:(NSArray *)goalsList {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        self.bets = goalsList;
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
    mainView.contentSize   = CGSizeMake(screenWidth, 140*bets.count);
    [mainView setBackgroundColor:[UIColor colorWithRed:(39/255.0) green:(37/255.0) blue:(37/255.0) alpha:1.0]];
    
    NSString *betTitle;
    // Make the Buttons list
    for (int i = 0; i < bets.count; i++) {
        NSManagedObject *obj = [bets objectAtIndex:i];
        
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
        CGRect buttonFrame = CGRectMake(20, (140*i +10), (screenWidth - 40), 140 -10);
        
        BigButton *button = [[BigButton alloc] initWithFrame:buttonFrame
                                                     primary:1
                                                       title:betTitle
                                                       ident:[obj valueForKey:@"id"]];
        
        [button addTarget:self
         action:@selector(viewBetDetails:)
         forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:button];
    }
    
    
    self.view = mainView;
}

-(void)viewBetDetails:(BigButton *)sender {
    // get the bet from the server
    NSString * path = [NSString stringWithFormat:@"bets/%@", sender.idKey];
    
    //make the call to the web API
    [[API sharedInstance] get:path withParams:nil
                 onCompletion:^(NSDictionary *json) {
                     //success
                     BetTrackingVC *vc =[[BetTrackingVC alloc] initWithJSON:json];
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
