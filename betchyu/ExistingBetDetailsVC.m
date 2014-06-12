//
//  ExistingBetDetailsVC.m
//  betchyu
//
//  Created by Daniel Zapata on 12/16/13.
//  Copyright (c) 2013 BetchyuLLC. All rights reserved.
//

#import "ExistingBetDetailsVC.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import "BigButton.h"
#import "API.h"
#import "ExistingBetDetailsView.h"

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
        
        self.betJSON    = json;
        self.bet        = [[TempBet alloc] init];
        self.bet.duration   = [betJSON valueForKey:@"duration"];
        self.bet.createdAt  = [dateFormatter dateFromString: [[betJSON valueForKey:@"created_at"] substringWithRange:NSMakeRange(0, 10)]];
        self.bet.verb       = [betJSON valueForKey:@"verb"];
        self.bet.noun       = [betJSON valueForKey:@"noun"];
        self.bet.amount     = [betJSON valueForKey:@"amount"];
        self.bet.stakeAmount= [betJSON valueForKey:@"stakeAmount"];
        self.bet.stakeType  = [betJSON valueForKey:@"stakeType"];
        self.bet.initial    = [betJSON valueForKey:@"initial"];
        self.bet.status     = [betJSON valueForKey:@"status"];
        self.bet.owner      = [betJSON valueForKey:@"owner"];
        
        self.isOffer = NO;
        self.isOwn   = NO;
        
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
    /*/ Create main UIScrollView (the container for home page buttons)
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    int w = mainView.frame.size.width;
    int h = mainView.frame.size.height;
    mainView.contentSize   = CGSizeMake(w, 2*h/3 +120);
    mainView.backgroundColor = [UIColor whiteColor];
    
    // The bet-type image
    UIImageView *img;
    /*if ([bet.verb isEqualToString:@"Stop"]) {
        img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Stop Smoking.jpg"]];
    } else if ([bet.verb isEqualToString:@"Run"]){
        img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Run More.jpg"]];
    } else if ([bet.verb isEqualToString:@"Workout"]){
        img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Workout More.jpg"]];
    } else if ([bet.verb isEqualToString:@"Lose"]){
        img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Lose Weight.jpg"]];
    } else {*//*
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
    if ([bet.stakeType isEqualToString:@"Amazon Gift Card"]) {
        stakeDescription.text = [NSString stringWithFormat:@"If I successfully complete my challenge, you owe me a $%@ %@.", bet.stakeAmount, bet.stakeType];
    } else if ([bet.stakeAmount integerValue] == 1) {
        stakeDescription.text = [NSString stringWithFormat:@"If I successfully complete my challenge, you owe me %@ %@.", bet.stakeAmount, bet.stakeType];
    } else {
        stakeDescription.text = [NSString stringWithFormat:@"If I successfully complete my challenge, you owe me %@ %@s.", bet.stakeAmount, bet.stakeType];
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
    }*/
    
    // self.view = mainView;
    self.view = [[ExistingBetDetailsView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame AndBet:betJSON];
}

-(NSString *)readableBetTitle {
    int days = [bet.duration intValue];
    if ([bet.verb isEqualToString:@"Stop"]) {
        if (days > 1) {
            return [NSString stringWithFormat:@"stop smoking for %i days", days];
        } else {
            return @"stop smoking for 1 day";
        }
    } else {
        if (days > 1) {
            return [NSString stringWithFormat:@"%@ %@ %@ in %i days", bet.verb, bet.amount, bet.noun, days];
        } else {
            return [NSString stringWithFormat:@"%@ %@ %@ in 1 day", bet.verb, bet.amount, bet.noun];
        }
    }
}

-(NSString *)currentStateText {
    long days =(long)[bet.duration intValue];
    int items = [betJSON valueForKey:@"current"] == [NSNull null] ? 0 : [[betJSON valueForKey:@"current"] intValue];
    items = [bet.amount integerValue] - items;
    
    
    if ([bet.verb isEqualToString:@"Stop"]) {
        if (days != 1) {
            return [NSString stringWithFormat:@"Currently, there are %ld days to go.", days];
        } else {
            return @"Currently, there is 1 day to go.";
        }
    } else if ([bet.verb isEqualToString:@"Lose"]) {     // handle the weight-loss bet
        items = [betJSON valueForKey:@"current"] == [NSNull null] ? 0 : [[betJSON valueForKey:@"current"] intValue];
        if (items == 0) {
            items = [self.bet.amount intValue] - items;
            if (days != 1) {
                return [NSString stringWithFormat:@"Currently, there are %ld days to go, and %d %@ to %@", days, items, self.bet.noun, self.bet.verb];
            } else {
                return [NSString stringWithFormat:@"Currently, there is 1 day to go, and %d %@ to %@", items, self.bet.noun, self.bet.verb];
            }
        } else {
            NSString* path =[NSString stringWithFormat:@"bets/%@/updates", [betJSON valueForKey:@"id"]];
            
            //make the call to the web API
            // GET /bets/:bet_id/updates => {data}
            [[API sharedInstance] get:path withParams:nil onCompletion:^(NSDictionary *json) {
                //success
                if (((NSArray*)json).count > 0) {
                    int val = [[[((NSArray*)json) objectAtIndex:(((NSArray*)json).count-1)] valueForKey:@"value"] intValue];
                    self.current.text = [NSString stringWithFormat:@"Currently, there are %ld days to go, and %i pounds to lose.", days, [self.bet.amount integerValue] - (items - val)];
                } else {
                    if (days != 1) {
                        self.current.text = [NSString stringWithFormat:@"Currently, there are %ld days to go, and %@ pounds to lose.", days, self.bet.amount];
                    } else {
                        self.current.text = [NSString stringWithFormat:@"Currently, there is 1 day to go, and %@ pounds to lose.", self.bet.amount];
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
            return [NSString stringWithFormat:@"Currently, there are %ld days to go, and %d %@ to %@", days, items, self.bet.noun, self.bet.verb];
        } else {
            return [NSString stringWithFormat:@"Currently, there is 1 day to go, and %d %@ to %@", items, self.bet.noun, self.bet.verb];
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
        if ([bet.stakeType isEqualToString:@"Amazon Gift Card"]) {     // handle the weight-loss bet
            self.stakeDescription.text = [NSString stringWithFormat:@"If your friend succeeds, you pay a $%@ %@, otherwise, you win one.", bet.stakeAmount, bet.stakeType];
        } else {
            if ([bet.stakeAmount integerValue] == 1) {
                self.stakeDescription.text = [NSString stringWithFormat:@"If your friend succeeds, you pay %@ %@, otherwise, you win one.", bet.stakeAmount, bet.stakeType];
            } else {
                self.stakeDescription.text = [NSString stringWithFormat:@"If your friend succeeds, you pay %@ %@s, otherwise, you win them.", bet.stakeAmount, bet.stakeType];
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
    return;
    if (self.isOwn || self.isOffer) { return; } // don't need to run this method when it's our own bet or only an offer
    
    int items = [betJSON valueForKey:@"current"] == [NSNull null] ? 0 : [[betJSON valueForKey:@"current"] integerValue];
    items = [bet.amount integerValue] - items;
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:[NSDate date]
                                                          toDate:bet.createdAt
                                                         options:0];
    
    if ([bet.verb isEqualToString:@"Stop"]) {
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
    } else if ([bet.noun isEqualToString:@"pounds"]) {
        // if the latest update is smaller than the goal weight
        if ((self.updates.count > 0) &&
            (([bet.initial intValue] - [bet.amount intValue]) == [[[updates lastObject] valueForKey:@"value"] integerValue])) {
            
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
    // this method does the following, in order:
    //  1. asks for Credit Card info via BTLibrary
    //  2. tells the server the info, which makes, but does not submit the transaction
    //  3. tells the server that the bet is accepted
    //  4. UIAlerts the user that the process is done
    
    /* Do #1 */
    // tell the user wtf is going on
    [[[UIAlertView alloc] initWithTitle:@"We Need Something"
                                message:@"We're gonna need a valid credit card for you to do that. Don't worry, we won't charge it until the bet is over--and even then only if you lost."
                               delegate:nil
                      cancelButtonTitle:@"Fair Enough"
                      otherButtonTitles:nil]
     show];
    // showing BrainTree's CreditCard processing page
    BTPaymentViewController *paymentViewController = [BTPaymentViewController paymentViewControllerWithVenmoTouchEnabled:NO];
    paymentViewController.delegate = self;
    // Now, display the navigation controller that contains the payment form
    [self.navigationController pushViewController:paymentViewController animated:YES];
    
    /* Do #2-4 */
    // is done within the delegate methods below. line 370 sets this up ^^
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
-(void)tellServerOfAcceptedBet {
    /* Do #3 */
    NSString *path =[NSString stringWithFormat:@"bets/%@", [betJSON valueForKey:@"id"]];
    NSString *ownId = ((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId;
    NSMutableDictionary* params =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  ownId, @"opponent",
                                  nil];
    
    //make the call to the web API
    // PUT /bets/:bet_id => {data}
    [[API sharedInstance] put:path withParams:params onCompletion:
     ^(NSDictionary *json) {
         /* Do #4 */
         // Show the result in an alert
         [[[UIAlertView alloc] initWithTitle:@"Result"
                                     message:@"You have accepted your friend's bet. Your card will be charged if you lose the bet."
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
    /*if (buttonIndex == 0) {
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
    [self.navigationController popToRootViewControllerAnimated:YES];*/
    if ([alertView.title isEqualToString:@"Credit Card"]) {
        if ([alertView.message isEqualToString:@"Card is approved"]) {
            // submit the bet to the server, after having checked that the card is good
            [self tellServerOfAcceptedBet];
        } else {
            // the card was bad, so do nothing
        }
    }
}

#pragma mark - BTPaymentViewControllerDelegate methods
- (void)paymentViewController:(BTPaymentViewController *)paymentViewController
        didSubmitCardWithInfo:(NSDictionary *)cardInfo
         andCardInfoEncrypted:(NSDictionary *)cardInfoEncrypted {
    // Do something with cardInfo dictionary
    NSLog(@"cardInfo: %@",cardInfo);
    NSLog(@"cardInfoEncrypted: %@",cardInfoEncrypted);// is nil unless VenmoTouch is used
    NSMutableDictionary *enc = [[NSMutableDictionary alloc]initWithDictionary:cardInfoEncrypted];
    
    // manually encrypt the cardInfo
    BTEncryption *braintree = [[BTEncryption alloc]initWithPublicKey:@"MIIBCgKCAQEA1FfiDXfYBxtcOCu7wcOK+0/n4q4C6WUaakP8/PzflZRJ30Ac+onTkzPLct4InPoL/P6CCkLOUQrcFcXZRFIdvCieAks1dY53c5TnBV8f8dqFA/CZQm+J1O/W+m+aAIIUyre6qbZ7Wv2IC2tRDM4nW9RcWIIQ7c9ZNpHfdP4muIpEWvF0D0VplRjkdTZUMSxR9/nJ7fqfYTazEmo9GXDa7LPf22r178Iq9WTlKfk6APNE7aYrx8zN21FshweJgBBRZxh4LFmBd+j1DzLciBJNjFh1JA98D+40XGLj+9SPXoVCSznshW4X5sV970W0rnCwU01VTBk/8N3HWgwbZK6mnwIDAQAB"];
    [cardInfo enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
        [enc setObject: [braintree encryptString: object] forKey: key];
    }];
    
    NSString *ownerString = ((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId;
    [enc setValue:ownerString forKey:@"user"];
    [enc setValue:bet.stakeAmount forKey:@"amount"];
    [enc setValue:[betJSON valueForKey:@"id"] forKey:@"bet_id"];
    
    //make the call to the web API to post the card info and determine valid-ness
    // POST /card => {data}
    [[API sharedInstance] post:@"card" withParams:enc onCompletion:^(NSDictionary *json) {
        // call this, because we aren't loading anymore
        // Don't forget to call the cleanup method,
        // `prepareForDismissal`, on your `BTPaymentViewController` in order to remove the loading thing that pops up automatically
        [(BTPaymentViewController *)self.navigationController.topViewController prepareForDismissal];
        
        NSLog(@"%@", json);
        // show the credit card status, and do things based on it
        [[[UIAlertView alloc] initWithTitle: @"Credit Card"
                                    message: [json objectForKey:@"msg"]
                                   delegate: self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        // delegate handles following events:
        // 1. submit the bet-data to the server
        // 2. dismiss the paymentViewController and popToRootViewController
    }];
}
@end
