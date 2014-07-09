//
//  PendingBetsView.m
//  betchyu
//
//  Created by Daniel Zapata on 6/3/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import "PendingBetsView.h"
#import <Braintree/BTEncryption.h>
#import "BTPaymentViewController.h"
#import "HeadingBarView.h"

@implementation PendingBetsView

@synthesize bets;
@synthesize bits;
@synthesize selectedBet;

@synthesize fontSize;
@synthesize rowHt;

@synthesize isWide;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isWide = NO;
        self.fontSize = 14;
        self.rowHt = 90;
        if (frame.size.width > 500) {
            self.isWide = YES;
            self.fontSize = 21;
            self.rowHt = 115;
        }        
        // Background
        [self setBackgroundColor:[UIColor whiteColor]];
        
        // Title bar
        HeadingBarView *heading = [[HeadingBarView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, fontSize*1.8) AndTitle:@"Pending Bets"];
        
        // add everything
        [self addSubview:heading];
    }
    return self;
}

// helpers
-(UIView *)getFBPic:(NSString *)userId WithDiameter:(int)dim AndFrame:(CGRect)frame{
    // The Border
    UIView *profBorder = [[UIView alloc] initWithFrame:frame];
    profBorder.backgroundColor = [UIColor colorWithRed:213.0/255 green:213.0/255 blue:214.0/255 alpha:1.0];
    profBorder.layer.cornerRadius = dim/2;
    
    // The Picture inside it
    FBProfilePictureView *profPic = [[FBProfilePictureView alloc]
                                     initWithProfileID:userId
                                     pictureCropping:FBProfilePictureCroppingSquare];
    profPic.frame = CGRectMake(2, 2, dim-4, dim-4);
    profPic.layer.cornerRadius = (dim-4)/2;
    [profBorder addSubview:profPic];
    return profBorder;
}
- (void) setBetDescription:(NSDictionary *)obj ForLabel:(UILabel *)lab UserId:(NSString*)usr {
    [FBRequestConnection  startWithGraphPath:[NSString stringWithFormat:@"%@",usr] completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSString *noun = [[obj valueForKey:@"noun"] lowercaseString];
            // Success! Include your code to handle the results here
            if ([noun isEqualToString:@"smoking"]) {
                lab.text = [NSString stringWithFormat:@"%@ will %@ %@ for %@ days", [result valueForKey:@"name"], [[obj valueForKey:@"verb"] lowercaseString], noun, [obj valueForKey:@"duration"]];
            }
            else {
                lab.text = [NSString stringWithFormat:@"%@ will %@ %@ %@ in %@ days", [result valueForKey:@"name"], [[obj valueForKey:@"verb"] lowercaseString], [obj valueForKey:@"amount"], noun, [obj valueForKey:@"duration"]];
            }
            [self addSubview:lab];
        } else {
            // An error occurred, we need to handle the error
            // See: https://developers.facebook.com/docs/ios/errors
        }
    }];
}

// populate the main area with bets stuff
-(void)addBets:(NSArray *)pending {
    self.bets = pending;
    
    // convinience variables
    CGRect frame = self.frame;
    int diameter = frame.size.width / 6.7;
    if (isWide) {
        diameter = frame.size.width / 8;
    }
    
    // Bets loop
    int c = pending.count;
    int off = fontSize*1.8;
    if (c == 0) {
        // show --None-- message
        UILabel *none = [[UILabel alloc]initWithFrame:CGRectMake(0, off, frame.size.width, frame.size.height-off)];
        none.text = @"None";
        none.font = [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize*1.4];
        none.textColor = Bdark;
        none.textAlignment = NSTextAlignmentCenter;
        [self addSubview:none];
    } else {
        for (int i = 0; i < c; i++) {
            NSDictionary *obj = [pending objectAtIndex:i];
            UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(0, rowHt * i + off, frame.size.width, rowHt)];
            [but addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
            but.tag = i;
            [self addSubview:but];
            
            // Profile imag
            CGRect picF  = CGRectMake(frame.size.width/16, rowHt * i + off + rowHt/6, diameter, diameter);
            UIView *pic = [self getFBPic:[obj valueForKey:@"owner"] WithDiameter:diameter AndFrame:picF];
            
            // Buttons
            int yB      = (rowHt * i) + rowHt/1.6 + off;
            int xMargin = frame.size.width/4.4;
            int widthB  = frame.size.width/5.5;
            int heightB = rowHt / 3;
            // Accept Button
            UIButton * accept = [[UIButton alloc] initWithFrame:CGRectMake(xMargin, yB, widthB, heightB)];
            accept.tag = i;
            [accept addTarget:self action:@selector(acceptBet:) forControlEvents:UIControlEventTouchUpInside];
            accept.backgroundColor = Bgreen;
            [accept setTitle:@"Accept" forState:UIControlStateNormal];
            [accept setTintColor:[UIColor whiteColor]];
            accept.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize];
            accept.layer.cornerRadius = 9;
            accept.clipsToBounds = YES;
            // Reject Button
            UIButton * reject = [[UIButton alloc] initWithFrame:CGRectMake(xMargin + widthB + widthB/6, yB, widthB, heightB)];
            [reject addTarget:self action:@selector(rejectBet:) forControlEvents:UIControlEventTouchUpInside];
            [reject setTitle:@"Reject" forState:UIControlStateNormal];
            reject.backgroundColor  = Bred;
            reject.tintColor        = [UIColor whiteColor];
            reject.titleLabel.font  = [UIFont fontWithName:@"ProximaNova-Regular" size:(fontSize-1)];
            reject.layer.cornerRadius = 9;
            reject.clipsToBounds    = YES;
            reject.tag = i;
            
            // Description string
            UILabel *desc      = [[UILabel alloc]initWithFrame:CGRectMake(xMargin, off + off/5 + rowHt*i, frame.size.width/1.65, rowHt/1.7)];
            [self setBetDescription:obj ForLabel:desc UserId:[obj valueForKey:@"owner"]];
            desc.font          = [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize+1];
            desc.textColor     = Bdark;
            desc.textAlignment = NSTextAlignmentLeft;
            desc.lineBreakMode = NSLineBreakByWordWrapping;
            desc.numberOfLines = 0;
            
            // arrow to indicate tapability
            UILabel *arrow      = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width - xMargin/2, rowHt*i + off, frame.size.width/2, rowHt)];
            arrow.font          = [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize+3];
            arrow.textColor     = Blight;
            arrow.textAlignment = NSTextAlignmentLeft;
            arrow.text          = [NSString stringWithUTF8String:"❯"];
            
            // Bottom line divider thingie
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width/16, rowHt + off + rowHt*i, 14*frame.size.width/16, 2)];
            line.backgroundColor = Blight;
            
            // Add everything
            [self addSubview:accept];
            [self addSubview:reject];
            [self addSubview:pic];
            [self addSubview:line];
            [self addSubview:arrow];
            //[self addSubview:desc]; Don't need to do this b/c [self setBetDescription: ForLabel]
        }
    }
    
}

- (void) showDetails:(UIButton *)sender {
    // make the Bet Details View Controller
    ExistingBetDetailsVC *vc = [[ExistingBetDetailsVC alloc] initWithJSON:[bets objectAtIndex:sender.tag]];
    vc.title = @"The Bet";
    [((AppDelegate *)([[UIApplication sharedApplication] delegate])).navController pushViewController:vc animated:YES];
}

// API call stuff
-(void)acceptBet:(UIButton *)sender {
    // May return nil if a tracker has not already been initialized with a property
    // ID.
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"       // Event category (required)
                                                          action:@"button_press"    // Event action (required)
                                                           label:@"Accept Bet"      // Event label
                                                           value:nil] build]];      // Event value
    
    selectedBet = [bets objectAtIndex:sender.tag];
    // this method does the following, in order:
    //  1. asks for Credit Card info via BTLibrary
    //  2. tells the server the info, which makes, but does not submit the transaction
    //  3. tells the server that the bet is accepted
    //  4. UIAlerts the user that the process is done
    
    /* Do #1 */
    
    NSString *path = [NSString stringWithFormat:@"card/%@", ((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId];
    [[API sharedInstance] get:path withParams:nil onCompletion:^(NSDictionary *json) {
        if ([[json valueForKey:@"msg"] isEqualToString:@"no card found, man"]) {
            // tell the user wtf is going on
            [[[UIAlertView alloc] initWithTitle:@"We Need Something"
                                        message:@"We're gonna need a valid credit card for you to do that. Don't worry, we won't charge it until the bet is over--and even then only if you lost."
                                       delegate:nil
                              cancelButtonTitle:@"Fair Enough"
                              otherButtonTitles:nil]
             show];
            
            
            // showing BrainTree's CreditCard processing page
            BTPaymentViewController *paymentViewController = [BTPaymentViewController paymentViewControllerWithVenmoTouchEnabled:NO];
            CGRect f = CGRectMake(0, -63, self.frame.size.width, 90);
            BetterBraintreeView *sub = [[BetterBraintreeView alloc] initWithFrame:f];
            [paymentViewController.view addSubview:sub];
            [paymentViewController.tableView setContentInset:UIEdgeInsetsMake(78,0,0,0)];
            // setup it's delegate
            TempBet * b = [TempBet new];
            [BraintreeDelegateController sharedInstance].del = self;
            b.stakeAmount = [selectedBet valueForKey:@"stakeAmount"];
            [BraintreeDelegateController sharedInstance].bet = b;
            [BraintreeDelegateController sharedInstance].ident = [selectedBet valueForKey:@"id"];
            [BraintreeDelegateController sharedInstance].email = sub.email;
            paymentViewController.delegate = [BraintreeDelegateController sharedInstance];
            // Now, display the navigation controller that contains the payment form
            [((AppDelegate *)([[UIApplication sharedApplication] delegate])).navController pushViewController:paymentViewController animated:YES];
        } else {
            //skip asking for the card.
            [self tellServerOfAcceptedBet];
        }
    }];
    
    /* Do #2-4 */
    // is done within the delegate methods below. line 370 sets this up ^^
}

-(void)tellServerOfAcceptedBet {
    /* Do #3 */
    AppDelegate * app = ((AppDelegate *)([[UIApplication sharedApplication] delegate]));
    NSString *path =[NSString stringWithFormat:@"invites/%@", [selectedBet valueForKey:@"invite"]];
    NSMutableDictionary* params =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  @"accepted", @"status",
                                  app.ownName, @"name",
                                  nil];
    //make the call to the web API
    // PUT /invites/:id => {status: "accepted"}
    [[API sharedInstance] put:path withParams:params onCompletion:^(NSDictionary *json) {
         /* Do #4 */
         [app.navController popToRootViewControllerAnimated:YES];
     }];
    
    // tell them what's going on
    [[[UIAlertView alloc] initWithTitle:@""
                                message:@"You have accepted your friend's bet. Your card will be charged if you lose the bet."
                               delegate:nil
                      cancelButtonTitle:@"OK!"
                      otherButtonTitles:nil]
     show];
}

-(void)rejectBet:(UIButton *)sender {
    // May return nil if a tracker has not already been initialized with a property
    // ID.
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"       // Event category (required)
                                                          action:@"button_press"    // Event action (required)
                                                           label:@"Reject Bet"      // Event label
                                                           value:nil] build]];      // Event value
    
    selectedBet = [bets objectAtIndex:sender.tag];
    
    AppDelegate * app = ((AppDelegate *)([[UIApplication sharedApplication] delegate]));
    // this method does the following, in order:
    //  1. tells the server that the invite has been rejected
    NSString *path =[NSString stringWithFormat:@"invites/%@", [selectedBet valueForKey:@"invite"]];
    NSMutableDictionary* params =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  @"rejected", @"status",
                                  app.ownName, @"name",
                                  nil];
    //make the call to the web API
    // PUT /invites/:id => {status: "rejected"}
    [[API sharedInstance] put:path withParams:params onCompletion:^(NSDictionary *json) {
        /* Do #4 */
        // Show the result in an alert
        [[[UIAlertView alloc] initWithTitle:@"Lame..."
                                    message:@"You have rejected your friend's bet. That's not very sportsman-like."
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil]
         show];
        [app.mainViewController getAndAddPendingBets:NO];
    }];
}

#pragma mark - UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView.title isEqualToString:@"Credit Card"]) {
        if ([alertView.message isEqualToString:@"Card is approved"]) {
            // Then dismiss the paymentViewController
            // the loading thing is removed before the alert comes up
            [self tellServerOfAcceptedBet];
        } else {
            // the card was bad, so do nothing
        }
    }
}

@end
