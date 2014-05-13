//
//  BetStakeConfirmVC.m
//  iBetchyu
//
//  this file askes the user to set the amount of the stake, then to pick their friends, then to input their payment bullshit
//  after which, it submits the info to the server for processing
//  it's a lot of stuff.
//
//  Created by Betchyu Computer on 11/24/13.
//  Copyright (c) 2013 Betchyu Computer. All rights reserved.
//

#import "BetStakeConfirmVC.h"
#import "BigButton.h"
#import "BetFinalizeVC.h"
#import "API.h"
#import <Braintree/BTEncryption.h>

@interface BetStakeConfirmVC ()

@end

@implementation BetStakeConfirmVC

@synthesize stakeLabel;
@synthesize verboseLabel;
@synthesize stakeImageHeight;
@synthesize bet;
@synthesize currentStake;
@synthesize fbFriendVC;

- (id)initWithBet:(TempBet *)betObj {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        self.stakeImageHeight = 280;
        self.bet = betObj;
        if ([bet.ownStakeType isEqualToString:@"Amazon Gift Card"]) {
            self.currentStake = 10;
        } else {
            self.currentStake = 1;
        }
    }
    return self;
}

- (void) loadView {
    // Create main UIScrollView (the container for what follows)
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    int h = mainView.frame.size.height - 40;
    int w = mainView.frame.size.width;
    mainView.contentSize   = CGSizeMake(w, h);
    [mainView setBackgroundColor:[UIColor colorWithRed:(39/255.0) green:(37/255.0) blue:(37/255.0) alpha:1.0]];
    
    /////////////////////
    // Stake Amount UI //
    /////////////////////
    UIImageView *stakePic = [[UIImageView alloc] initWithImage:
                             [UIImage imageNamed:
                              [bet.ownStakeType stringByAppendingString:@".jpg"]]];
    stakePic.frame = CGRectMake(0, 0, w, h/2);
    
    UIButton *up = [[UIButton alloc] initWithFrame:CGRectMake(w/2 - 25, 20, 50, 50)];
    [up setTitle:@"+" forState:UIControlStateNormal];
    up.font = [UIFont fontWithName:@"ProximaNova-Black" size:40];
    [up setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    [up addTarget:self action:@selector(increaseStake:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *dwn = [[UIButton alloc] initWithFrame:CGRectMake(w/2 - 25, 180, 50, 50)];
    [dwn setTitle:@"-" forState:UIControlStateNormal];
    dwn.font = [UIFont fontWithName:@"ProximaNova-Black" size:40];
    [dwn setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dwn addTarget:self action:@selector(lowerStake:) forControlEvents:UIControlEventTouchUpInside];
    
    stakeLabel               = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, w, 70)];
    stakeLabel.textAlignment = NSTextAlignmentCenter;
    stakeLabel.textColor     = [UIColor whiteColor];
    stakeLabel.font          = [UIFont fontWithName:@"ProximaNova-Black" size:40];
    stakeLabel.shadowColor   = [UIColor blackColor];
    stakeLabel.shadowOffset  = CGSizeMake(-1, 1);
    
    [mainView addSubview:stakePic];
    [mainView addSubview:up];
    [mainView addSubview:dwn];
    [mainView addSubview:stakeLabel];
    
    verboseLabel               = [[UILabel alloc] initWithFrame:CGRectMake(10, h/2, w-20, 80)];
    verboseLabel.numberOfLines = 0;
    verboseLabel.textColor     = [UIColor whiteColor];
    verboseLabel.font          = [UIFont fontWithName:@"ProximaNova-Regular" size:20];
    [self updateLabels];
    [mainView addSubview:verboseLabel];
    
    /////////////////
    // Next Button //
    /////////////////
    BigButton *nextBtn = [[BigButton alloc] initWithFrame:CGRectMake(20, h-120, w-40, 100)
                                                  primary:0
                                                    title:@"Set Stake"];
    [nextBtn addTarget:self
                action:@selector(setBetStake:)
      forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:nextBtn];
    
    
    // add the UIScrollView we've been compiling to the actual screen.
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

// Move on to selecting their friend
-(void)setBetStake:(id)sender {
    [[[UIAlertView alloc] initWithTitle: @"Reminder"
                                message: @"It is up to you and your friend to pay this stake after the bet. Betchyu just helps you track things."
                               delegate: nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
    
    if (!fbFriendVC) {
        fbFriendVC = [[FBFriendPickerViewController alloc] initWithNibName:nil bundle:nil];
        // Set the friend picker delegate
        fbFriendVC.delegate = self;
        
        fbFriendVC.title = @"Select friends";
    }
    
    [fbFriendVC loadData];
    [self presentViewController:self.fbFriendVC animated:YES completion:^(void){
        [self addSearchBarToFriendPickerView];
    }];
}
-(void)increaseStake:(id)sender {
    if ([bet.ownStakeType isEqualToString:@"Amazon Gift Card"]) {
        if (currentStake == 1){
            currentStake += 4;
        } else {
            currentStake += 5;
        }
    } else {
        currentStake++;
    }
    [self updateLabels];
}
-(void)lowerStake:(id)sender {
    if (currentStake == 1) {
        return;
    }
    if ([bet.ownStakeType isEqualToString:@"Amazon Gift Card"]) {
        if (currentStake == 5){
            currentStake -= 4;
        } else {
            currentStake -= 5;
        }
    } else {
        currentStake--;
    }
    [self updateLabels];
}

// updates the visual notation of the stake and the TempBet (self.bet) version of the the stake
- (void) updateLabels {
    if ([bet.ownStakeType isEqualToString:@"Amazon Gift Card"]) {
        stakeLabel.text = [NSString stringWithFormat:@"$%i", currentStake];
    } else {
        if (currentStake == 1) {
            stakeLabel.text = [[[@(currentStake) stringValue] stringByAppendingString:@" "] stringByAppendingString:bet.ownStakeType];
        } else {
            stakeLabel.text = [NSString stringWithFormat:@"%i %@s", currentStake, bet.ownStakeType];
        }
    }
    verboseLabel.text = [@"If I successfully complete my challenge, you owe me " stringByAppendingString:stakeLabel.text];
    bet.ownStakeAmount = [NSNumber numberWithInt:currentStake];
    bet.opponentStakeAmount = bet.ownStakeAmount;
}

//////////////////////////////////////////
// search bar stuff for FBFriendPicker  //
//////////////////////////////////////////
- (void)addSearchBarToFriendPickerView {
    if (self.searchBar == nil) {
        CGFloat searchBarHeight = 44.0;
        self.searchBar =
        [[UISearchBar alloc]
         initWithFrame:
         CGRectMake(0,0,
                    self.view.bounds.size.width,
                    searchBarHeight)];
        self.searchBar.autoresizingMask = self.searchBar.autoresizingMask |
        UIViewAutoresizingFlexibleWidth;
        self.searchBar.delegate = self;
        self.searchBar.showsCancelButton = YES;
        /*self.searchBar.barTintColor = [UIColor colorWithRed:1.0 green:(117.0/255.0) blue:(63/255.0) alpha:1.0];
        self.searchBar.translucent = NO;*/
        
        [self.fbFriendVC.canvasView addSubview:self.searchBar];
        CGRect newFrame = self.fbFriendVC.view.bounds;
        newFrame.size.height -= searchBarHeight;
        newFrame.origin.y = searchBarHeight;
        self.fbFriendVC.tableView.frame = newFrame;
    }
}
- (void) handleSearch:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    self.searchText = searchBar.text;
    [self.fbFriendVC updateView];
}
- (void)searchBarSearchButtonClicked:(UISearchBar*)searchBar {
    [self handleSearch:searchBar];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    self.searchText = nil;
    [searchBar resignFirstResponder];
    [self.fbFriendVC updateView];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.searchText = searchText;
    [self.fbFriendVC updateView];
}

////////////////////////
// friend picker stuff
////////////////////////
- (void)friendPickerViewControllerSelectionDidChange:(FBFriendPickerViewController *)friendPicker {
    // need to clear the search, so that the facebookVC will re-determine the selection list.
    // this prevents bugs with search-selected people not being included in the actual invitations
    self.searchText = nil;
    [self.searchBar resignFirstResponder];
    [self.fbFriendVC updateView];
    // this re-updates the list of friends we're gonna use to make invitations.
    bet.friends = friendPicker.selection;
}

// handles the user touching the done button on the FB friend selector
- (void)facebookViewControllerDoneWasPressed:(id)sender {
    // handle the user NOT selecting a friend... bad users.
    if (bet.friends.count == 0) {
        [[[UIAlertView alloc] initWithTitle: @"Hey!"
                                    message: @"You have to pick a friend to continue."
                                   delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    } else {
        [self makePost:[NSNumber numberWithInt:0]];
    }
    [self dismissViewControllerAnimated:YES completion:^(void){}];
}
// handles the user touching the done button on the FB friend selector
- (void)facebookViewControllerCancelWasPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
// allows us to limit which friends get shown on the friend picker (based on the search)
- (BOOL)friendPickerViewController:(FBFriendPickerViewController *)friendPicker
                 shouldIncludeUser:(id<FBGraphUser>)user
{
    if (self.searchText && ![self.searchText isEqualToString:@""]) {
        NSRange result = [user.name
                          rangeOfString:self.searchText
                          options:NSCaseInsensitiveSearch];
        if (result.location != NSNotFound) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return YES;
    }
    return YES;
}

/**
 * A function for parsing URL parameters.
 */
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}


// index is the objectAtIndex of bet.friends used to get the friend's user id
- (void)makePost:(NSNumber *)index {
    
    // get facebook friend's ID from selection
    NSString* fid = ((id<FBGraphUser>)[bet.friends objectAtIndex:[index integerValue]]).id;
    
    //Make the post.
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                   @"Invitation to Betchyu", @"name",
                                   @"I just made a goal on Betchyu! Do you think I can do it?", @"caption",
                                   @"http://betchyu.com", @"link",
                                   fid, @"to",
                                   @"http://i.imgur.com/zq6D8lk.png", @"picture",
                                   @"Betchyu", @"name", nil];
    
    // attemp to post the story to friends walls
    [FBWebDialogs presentFeedDialogModallyWithSession:nil parameters:params handler:
     ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
         if (error) {
             // Error launching the dialog or publishing a story.
             NSLog(@"Error publishing story.");
         } else {
             // show helpful message when the last visible FBpost modal is done
             if ([index integerValue] == bet.friends.count-1) {
                 [[[UIAlertView alloc] initWithTitle: @"Last Step!"
                                             message: @"To make this real, we need your payment info. Once your friend confirms with his info, the bet is on! Only the loser will be charged at the end."
                                            delegate: self
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil] show];
                 // due to action of delegate (set above) when the click OK, the next viewcontroller will come up
             }
             
            // handling differently based on what the user actually did with the modal
             if (result == FBWebDialogResultDialogNotCompleted) {
                 // User clicked the "x" icon
                 NSLog(@"User canceled story publishing.");
             } else {
                 // Handle the publish feed callback
                 NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                 if (![urlParams valueForKey:@"post_id"]) {
                     // User clicked the Cancel button
                     NSLog(@"User canceled story publishing.");
                 } else {
                     // User clicked the Share button
                     NSString *msg = [NSString stringWithFormat:
                                      @"Posted story, id: %@",
                                      [urlParams valueForKey:@"post_id"]];
                     NSLog(@"%@", msg);
                 }
             }
         }
         if (bet.friends.count > [index integerValue]+1) {
             [self performSelector:@selector(makePost:) withObject:[NSNumber numberWithInt:([index integerValue]+1)] afterDelay:0];
         }
     }];
}

//method to send the bet data to the server

- (void) betchyu {
    // MAKE THE NEW BET
    NSString *ownerString = ((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId;
    NSMutableDictionary* params =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  bet.betAmount,            @"betAmount",
                                  bet.betNoun,              @"betNoun",
                                  bet.betVerb,              @"betVerb",
                                  bet.endDate,              @"endDate",
                                  bet.opponentStakeAmount,  @"opponentStakeAmount",
                                  bet.opponentStakeType,    @"opponentStakeType",
                                  bet.ownStakeAmount,       @"ownStakeAmount",
                                  bet.ownStakeType,         @"ownStakeType",
                                  ownerString,              @"owner",
                                  bet.current,              @"current",
                                  nil];
    
    //make the call to the web API
    // POST /bets => {data}
    [[API sharedInstance] post:@"bets" withParams:params onCompletion:^(NSDictionary *json) {
        //success
        for (NSMutableDictionary<FBGraphUser> *friend in bet.friends) {
            NSMutableDictionary *newParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                              friend.id,                   @"invitee",
                                              ownerString,                 @"inviter",
                                              @"open",                     @"status",
                                              [json objectForKey:@"id"],   @"bet_id",
                                              nil];
            // POST /invites => {data}
            [[API sharedInstance] post:@"invites" withParams:newParams onCompletion:^(NSDictionary *json) {
                // handle response
                NSLog(@"%@", json);
            }];
        }
    }];
    [[[UIAlertView alloc] initWithTitle: @"Congratulations!"
                                message: @"An invitation has been sent to your friends' Betchyu app. The first person to accept becomes your opponent."
                               delegate: nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

#pragma mark - UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView.title isEqualToString:@"Credit Card"]) {
        if ([alertView.message isEqualToString:@"good"]) {
            // submit the bet to the server, after having checked that the card is good
            [self betchyu];
            
            // Then dismiss the paymentViewController
            // the loading thing is removed before the alert comes up
            [self.navigationController popViewControllerAnimated:NO];
            
            // make the summary VC
            BetSummaryVC *vc = [[BetSummaryVC alloc]initWithBet:self.bet];
            vc.title = @"Bet Summary";
            // show the summary vc
            [self.navigationController pushViewController:vc animated:YES];

        } else {
            // the card was bad, so do nothing
        }
    } else {
        // showing BrainTree's CrediCard processing page, after the user clicks the OK button on the alert we gave them
        BTPaymentViewController *paymentViewController = [BTPaymentViewController paymentViewControllerWithVenmoTouchEnabled:NO];
        paymentViewController.delegate = self;
        // Now, display the navigation controller that contains the payment form, eg modally:
        [self.navigationController pushViewController:paymentViewController animated:YES];
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
    BTEncryption * braintree = [[BTEncryption alloc]initWithPublicKey:@"MIIBCgKCAQEAmRehlELjqxPOltj1/bpsQE92opagAj6tFB8wo4Z/Dy0x7nugGnC7fvvvIEo5MEoKg6HvU1GSmpP7VQ4XU/8YDXblbaKsLgb5K92BySKwM1FyHoL2IfRrEDdJcV9tMJ9hjZbIcg7uBUYhT/rgpWBRaDVLMEAMnqvSH7UZ2wlCjjT1NJScrMDd4EyXQQcXSdc5ri9C62QfzopVxA6iOvK8YPkzRkmNUQOkEf67v+kiUgh2w2YWEXogmRCUoUpdzODJ689UcpqyMHrwouC+WxqLJK/0zDHy44Fofc/Sqp4Wf19fslXmb4HW8u5GqQUV/5PXi3B+j4tOeXxXynTeOKtcqQIDAQAB"];
    [cardInfo enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
        [enc setObject: [braintree encryptString: object] forKey: key];
    }];
    
    NSString *ownerString = ((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId;
    [enc setValue:ownerString forKey:@"user"];
    [enc setValue:bet.opponentStakeAmount forKey:@"amount"];
    
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
        // 2. dismiss the paymentViewController
        // 3. switch to the BetSummaryVC
    }];
}
@end
