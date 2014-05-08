//
//  BetSummaryVC.m
//  betchyu
//
//  Created by Adam Baratz on 5/7/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import "BetSummaryVC.h"
#import "AppDelegate.h"
#import "API.h"

@interface BetSummaryVC ()

@end

@implementation BetSummaryVC

@synthesize bet;
@synthesize managedObjectContext;

- (id)initWithBet:(TempBet *)betObj {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        self.bet = betObj;
        AppDelegate *appDelegate = (AppDelegate *)([[UIApplication sharedApplication] delegate]);
        self.managedObjectContext = appDelegate.managedObjectContext;
    }
    return self;
}
// shows the summary of the bet.
- (void)loadView {
    // Create main UIScrollView (the container for what follows)
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    int h = mainView.frame.size.height - 40;
    int w = mainView.frame.size.width;
    mainView.contentSize   = CGSizeMake(w, h);
    [mainView setBackgroundColor:[UIColor colorWithRed:(39/255.0) green:(37/255.0) blue:(37/255.0) alpha:1.0]];
    
    // The handshake image
    UIImageView *shake = [[UIImageView alloc] initWithImage:
                          [UIImage imageNamed:@"handshake.jpg"]];
    shake.frame = CGRectMake(0, 0, w, h/2);
    
    // The bet summary text
    UILabel *betDescription      = [[UILabel alloc] initWithFrame:CGRectMake(20, h/2 - 110, w-40, 100)];
    betDescription.textAlignment = NSTextAlignmentCenter;
    betDescription.textColor     = [UIColor whiteColor];
    betDescription.font          = [UIFont fontWithName:@"ProximaNova-Black" size:30];
    betDescription.numberOfLines = 0;
    betDescription.lineBreakMode = NSLineBreakByWordWrapping;
    betDescription.shadowColor   = [UIColor blackColor];
    betDescription.shadowOffset  = CGSizeMake(-1, 1);
    int days = ceilf([bet.endDate timeIntervalSinceNow]/(24*60*60)); // # of days the challenge will last
    if ([bet.betNoun isEqualToString:@"Smoking"]) {
        betDescription.text = [NSString stringWithFormat:@"Stop Smoking for %i days", days];
    } else {
        betDescription.text = [NSString stringWithFormat:@"%@ %@ %@ in %i days", bet.betVerb, bet.betAmount, bet.betNoun, days];
    }
    
    // The stake summary text
    UILabel *stakeDescription      = [[UILabel alloc] initWithFrame:CGRectMake(10, h/2, w-20, 90)];
    stakeDescription.numberOfLines = 0;
    stakeDescription.textColor     = [UIColor whiteColor];
    stakeDescription.font          = [UIFont fontWithName:@"ProximaNova-Regular" size:20];
    if ([bet.ownStakeType isEqualToString:@"Amazon Gift Card"]) {
        stakeDescription.text = [NSString stringWithFormat:@"If I successfully complete my challenge, you owe me a $%@ %@", bet.ownStakeAmount, bet.ownStakeType];
    } else if ([bet.ownStakeAmount integerValue] == 1) {
        stakeDescription.text = [NSString stringWithFormat:@"If I successfully complete my challenge, you owe me %@ %@", bet.ownStakeAmount, bet.ownStakeType];
    } else {
        stakeDescription.text = [NSString stringWithFormat:@"If I successfully complete my challenge, you owe me %@ %@s", bet.ownStakeAmount, bet.ownStakeType];
    }
    
    // Add the subviews
    [mainView addSubview:shake];    // add the handshake image first, so it is under the other stuff
    [mainView addSubview:betDescription];
    [mainView addSubview:stakeDescription];
    
    // FBProfilePictureView setups
    if (FBSession.activeSession.isOpen) {
        // Current User's image
        int dim = h / 7;
        // the picture
        FBProfilePictureView *mypic = [[FBProfilePictureView alloc]
                                       initWithProfileID:((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId
                                       pictureCropping:FBProfilePictureCroppingSquare];
        mypic.frame = CGRectMake(2, 2, dim-4, dim-4);
        mypic.layer.cornerRadius = (dim-4)/2;
        // The border
        UIView *border = [[UIView alloc] initWithFrame:CGRectMake(w/2 - dim/2, h/15, dim, dim)];
        border.backgroundColor = [UIColor whiteColor];
        border.layer.cornerRadius = dim/2;
        [border addSubview:mypic];
        [mainView addSubview:border];
        
        [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                // Success! Include your code to handle the results here
                UILabel *name  = [[UILabel alloc] initWithFrame:CGRectMake(w/2 - dim/2, h/15 + dim, dim, 30)];
                name.textAlignment = NSTextAlignmentCenter;
                name.textColor = [UIColor whiteColor];
                name.text      = [result valueForKey:@"first_name"];
                name.font      = [UIFont fontWithName:@"ProximaNova-Regular" size:20];
                name.shadowColor   = [UIColor blackColor];
                name.shadowOffset  = CGSizeMake(-1, 1);
                [mainView addSubview:name];
            } else {
                // An error occurred, we need to handle the error
                // See: https://developers.facebook.com/docs/ios/errors
            }
        }];
    }
    
    // Betchyu button (to finish creating the bet)
    BigButton *betchyu = [[BigButton alloc] initWithFrame:CGRectMake(20, h - 120, w-40, 100)
                                                  primary:0
                                                    title:@"I'm Done"];
    [betchyu addTarget:self
                action:@selector(home)
      forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:betchyu];
    
    
    // set the controller's view to the view we've been building in mainView
    self.view = mainView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = YES; // don't want them to be able to backwards in the CREATEBET flow anymore--they should be done, with their card info given and everything by now.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) home {
    // go to the home page
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
