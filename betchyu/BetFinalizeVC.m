//
//  BetFinalizeVC.m
//  iBetchyu
//
//  Created by Betchyu Computer on 11/25/13.
//  Copyright (c) 2013 Betchyu Computer. All rights reserved.
//

#import "BetFinalizeVC.h"
#import "AppDelegate.h"
#import "Bet.h"

@interface BetFinalizeVC () <NSFetchedResultsControllerDelegate>
    @property NSFetchedResultsController * fetchedResultsController;
@end

@implementation BetFinalizeVC

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

- (void)loadView {
    // Create main UIScrollView (the container for what follows)
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    mainView.contentSize   = CGSizeMake(320, 1000);
    [mainView setBackgroundColor:[UIColor colorWithRed:(39/255.0) green:(37/255.0) blue:(37/255.0) alpha:1.0]];
    
    // The handshake image
    UIImageView *shake = [[UIImageView alloc] initWithImage:
                             [UIImage imageNamed:@"handshake.jpg"]];
    shake.frame = CGRectMake(0, 0, 320, 280);
    
    // The bet summary text
    UILabel *betDescription      = [[UILabel alloc] initWithFrame:CGRectMake(0, 190, 320, 70)];
    betDescription.textAlignment = NSTextAlignmentCenter;
    betDescription.textColor     = [UIColor whiteColor];
    int days = (int)[bet.endDate timeIntervalSinceNow]/(24*60*60); // # of days the challenge will last
    betDescription.text          = [[[[[[[bet.betVerb stringByAppendingString:
                                          @" " ] stringByAppendingString:
                                         [bet.betAmount stringValue]] stringByAppendingString:
                                        @" "] stringByAppendingString:
                                       bet.betNoun] stringByAppendingString:
                                      @" in "] stringByAppendingString:
                                     [@(days) stringValue]] stringByAppendingString:
                                    @" days"];
    
    // The stake summary text
    UILabel *stakeDescription      = [[UILabel alloc] initWithFrame:CGRectMake(10, 270, 300, 80)];
    stakeDescription.numberOfLines = 0;
    stakeDescription.textColor     = [UIColor whiteColor];
    stakeDescription.text          = [[[@"If I successfully complete my challenge, you owe me " stringByAppendingString:
                                        [bet.ownStakeAmount stringValue]] stringByAppendingString:
                                       @" "] stringByAppendingString:
                                      bet.ownStakeType];
    
    // Add the subviews
    [mainView addSubview:shake];    // add the handshake image first, so it is under the other stuff
    [mainView addSubview:betDescription];
    [mainView addSubview:stakeDescription];

    // FBProfilePictureView setups
    if (FBSession.activeSession.isOpen) {
        // Current User's image
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 FBProfilePictureView *mypic = [[FBProfilePictureView alloc] initWithProfileID:user.id pictureCropping:FBProfilePictureCroppingOriginal];
                 mypic.frame = CGRectMake(5, 5, 75, 75);
                 
                 UIView *border = [[UIView alloc] initWithFrame:CGRectMake(35, 35, 85, 85)];
                 border.backgroundColor = [UIColor whiteColor];
                 [border addSubview:mypic];
                 
                 [mainView addSubview:border];
                 
                 UILabel *name  = [[UILabel alloc] initWithFrame:CGRectMake(35, 120, 85, 30)];
                 name.textAlignment = NSTextAlignmentCenter;
                 name.textColor = [UIColor whiteColor];
                 name.text      = user.first_name;
                 [mainView addSubview:name];
             }
         }];
        
        FBProfilePictureView *otherPic = [[FBProfilePictureView alloc] initWithProfileID:((NSDictionary<FBGraphUser> *)[bet.friends objectAtIndex:0]).id pictureCropping:FBProfilePictureCroppingSquare];
        otherPic.frame = CGRectMake(5, 5, 75, 75);
        
        UIView *border = [[UIView alloc] initWithFrame:CGRectMake(205, 35, 85, 85)];
        border.backgroundColor = [UIColor whiteColor];
        [border addSubview:otherPic];
        
        [mainView addSubview:border];
        
        UILabel *name  = [[UILabel alloc] initWithFrame:CGRectMake(205, 120, 85, 30)];
        name.textAlignment = NSTextAlignmentCenter;
        name.textColor = [UIColor whiteColor];
        name.text      = ((NSDictionary<FBGraphUser> *)[bet.friends objectAtIndex:0]).first_name;
        [mainView addSubview:name];
    }
    
    // Betchyu button (to finish creating the bet)
    BigButton *betchyu = [[BigButton alloc] initWithFrame:CGRectMake(20, 380, 280, 100)
                                                  primary:0
                                                    title:@"Betchyu!"];
    [betchyu addTarget:self
                action:@selector(betchyu:)
      forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:betchyu];


    // set the controller's view to the view we've been building in mainView
    self.view = mainView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    /*NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Bet"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"completedAt" ascending:NO]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController.delegate = self;
    [self.fetchedResultsController performFetch:nil];*/
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) betchyu:(id)sender {
    // TODO: save the bet on the server
    Bet *newBet = [NSEntityDescription insertNewObjectForEntityForName:@"Bet" inManagedObjectContext:self.managedObjectContext];

    newBet.betAmount = bet.betAmount;
    newBet.betNoun = bet.betNoun;
    newBet.betVerb = bet.betVerb;
    newBet.createdAt = [NSDate date];
    newBet.endDate = bet.endDate;
    newBet.opponentStakeAmount = bet.opponentStakeAmount;
    newBet.opponentStakeType = bet.opponentStakeType;
    newBet.ownStakeAmount = bet.ownStakeAmount;
    newBet.ownStakeType = bet.ownStakeType;
    newBet.owner = ((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId;   // appDelegate gets/maintains the user's id
    
    NSLog(@"finalize: %@", newBet.owner);
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh oh..."
                                                        message:@"The bet is invalid. Go back and fix it."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
