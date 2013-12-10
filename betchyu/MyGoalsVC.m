//
//  MyGoalsVC.m
//  betchyu
//
//  Created by Adam Baratz on 12/10/13.
//  Copyright (c) 2013 BetchyuLLC. All rights reserved.
//

#import "MyGoalsVC.h"
#import "BigButton.h"
#import "AppDelegate.h"

@interface MyGoalsVC ()

@end

@implementation MyGoalsVC

@synthesize bets;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSString *ownerString = ((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId;
        NSManagedObjectContext *moc = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
        NSEntityDescription *e = [NSEntityDescription entityForName:@"Bet" inManagedObjectContext:moc];
        NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
        fetch.entity = e;
        fetch.predicate = [NSPredicate
                           predicateWithFormat:@"(owner == %@)",
                           ownerString];
        NSError *err;
        bets = [moc executeFetchRequest:fetch error:&err];
        // prints out to test if we got the bets
        /*for (NSManagedObject *info in bets) {
         NSLog(@"Noun: %@", [info valueForKey:@"betNoun"]);
         }*/
    }
    return self;
}

- (void)loadView {
    // Create main UIScrollView (the container for home page buttons)
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    mainView.contentSize   = CGSizeMake(320, 1000);
    [mainView setBackgroundColor:[UIColor colorWithRed:(39/255.0) green:(37/255.0) blue:(37/255.0) alpha:1.0]];
    
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    //CGRect screenRect = self.view.frame;
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height - 50; // 50 px is the navbar at the top + 10 px bottom border
    
    NSString *betTitle;
    // Make the Buttons list
    for (int i = 0; i < bets.count; i++) {
        NSManagedObject *obj = [bets objectAtIndex:i];
        
        betTitle = [[[[[obj valueForKey:@"betVerb"] stringByAppendingString:
                       @" " ] stringByAppendingString:
                      [[obj valueForKey:@"betAmount"] stringValue]] stringByAppendingString:
                     @" "] stringByAppendingString:
                    [obj valueForKey:@"betNoun"]];
        CGRect buttonFrame;
        if (bets.count < 3) {
            buttonFrame = CGRectMake(20, ((screenHeight/3)*i +10), (screenWidth - 40), (screenHeight / 3) -10);
        } else if (bets.count < 5) {
            buttonFrame = CGRectMake(20, ((screenHeight/bets.count)*i +10), (screenWidth - 40), (screenHeight / bets.count) -10);
        } else {
            buttonFrame = CGRectMake(20, ((screenHeight/5)*i +10), (screenWidth - 40), (screenHeight / 5) -10);
        }
        
        BigButton *button = [[BigButton alloc] initWithFrame:buttonFrame
                                                     primary:1
                                                       title:betTitle];
        
        /*[button addTarget:self
         action:@selector(setBetDetails:)
         forControlEvents:UIControlEventTouchUpInside];*/
        [mainView addSubview:button];
    }
    
    
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
