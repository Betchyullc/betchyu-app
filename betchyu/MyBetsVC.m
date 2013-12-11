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

@interface MyBetsVC ()

@end

@implementation MyBetsVC

@synthesize ongoingBets;
@synthesize openBets;
@synthesize openInvites;

- (id)initWithOngoingBets:(NSArray *)passedOngoingBets andOpenBets:(NSArray *)openBetsList
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        self.ongoingBets = passedOngoingBets;
        self.openBets    = openBetsList;
    }
    return self;
}

- (void)loadView {
    // Create main UIScrollView (the container for home page buttons)
    UIView *mainView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    [mainView setBackgroundColor:[UIColor colorWithRed:(39/255.0) green:(37/255.0) blue:(37/255.0) alpha:1.0]];
    
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    //CGRect screenRect = self.view.frame;
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height - 50; // 50 px is the navbar at the top + 10 px bottom border
    
    NSString *betTitle;
    int c = ongoingBets.count;
    // Make the Ongoing Bets Button-list
    UIScrollView *ongoingBetsView = [[UIScrollView alloc] initWithFrame:CGRectMake(mainView.frame.origin.x, mainView.frame.origin.y+40, mainView.frame.size.width, mainView.frame.size.height /2)];
    ongoingBetsView.contentSize = CGSizeMake(screenWidth, 800);
    for (int i = 0; i < c; i++) {
        NSManagedObject *obj = [ongoingBets objectAtIndex:i];
        
        betTitle = [[[[[obj valueForKey:@"betVerb"] stringByAppendingString:
                         @" " ] stringByAppendingString:
                        [[obj valueForKey:@"betAmount"] stringValue]] stringByAppendingString:
                       @" "] stringByAppendingString:
                      [obj valueForKey:@"betNoun"]];
        
        CGRect buttonFrame;
        if (c < 3) {
            buttonFrame = CGRectMake(20, ((screenHeight/3)*i +10), (screenWidth - 40), (screenHeight / 3) -10);
        } else if (c < 5) {
            buttonFrame = CGRectMake(20, ((screenHeight/c)*i +10), (screenWidth - 40), (screenHeight / c) -10);
        } else {
            buttonFrame = CGRectMake(20, ((screenHeight/5)*i +10), (screenWidth - 40), (screenHeight / 5) -10);
        }
                     
        BigButton *button = [[BigButton alloc] initWithFrame:buttonFrame
                                                     primary:1
                                                       title:betTitle];
        /*[button addTarget:self
                   action:@selector(setBetDetails:)
         forControlEvents:UIControlEventTouchUpInside];*/
        [ongoingBetsView addSubview:button];
    }
    
    // Make the Ongoing Bets Button-list
    UIScrollView *openBetsView = [[UIScrollView alloc] initWithFrame:CGRectMake(mainView.frame.origin.x, mainView.frame.origin.y+(mainView.frame.size.height/2)+40, mainView.frame.size.width, mainView.frame.size.height /2)];
    openBetsView.contentSize = CGSizeMake(screenWidth, 800);
    for (int i = 0; i < c; i++) {
        NSManagedObject *obj = [openBets objectAtIndex:i];
        
        betTitle = [[[[[obj valueForKey:@"betVerb"] stringByAppendingString:
                       @" " ] stringByAppendingString:
                      [[obj valueForKey:@"betAmount"] stringValue]] stringByAppendingString:
                     @" "] stringByAppendingString:
                    [obj valueForKey:@"betNoun"]];
        
        CGRect buttonFrame;
        if (c < 3) {
            buttonFrame = CGRectMake(20, ((screenHeight/3)*i +10), (screenWidth - 40), (screenHeight / 3) -10);
        } else if (c < 5) {
            buttonFrame = CGRectMake(20, ((screenHeight/c)*i +10), (screenWidth - 40), (screenHeight / c) -10);
        } else {
            buttonFrame = CGRectMake(20, ((screenHeight/5)*i +10), (screenWidth - 40), (screenHeight / 5) -10);
        }
        
        BigButton *button = [[BigButton alloc] initWithFrame:buttonFrame
                                                     primary:1
                                                       title:betTitle];
        /*[button addTarget:self
         action:@selector(setBetDetails:)
         forControlEvents:UIControlEventTouchUpInside];*/
        [openBetsView addSubview:button];
    }
    
    [mainView addSubview:openBetsView];
    [mainView addSubview:ongoingBetsView];
    
    self.view = mainView;
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
