//
//  BraintreeDelegateController.m
//  betchyu
//
//  Created by Adam Baratz on 6/6/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import "BraintreeDelegateController.h"

@implementation BraintreeDelegateController

@synthesize bet;
@synthesize del; // the UIAlertViewDelegate pointer
@synthesize ident;

@synthesize email;

#pragma mark - Singleton methods
/**
 * Singleton methods
 */
+(BraintreeDelegateController *)sharedInstance
{
    static BraintreeDelegateController *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

/**
   Instance methods
 */
- (void)paymentViewController:(BTPaymentViewController *)paymentViewController
        didSubmitCardWithInfo:(NSDictionary *)cardInfo
         andCardInfoEncrypted:(NSDictionary *)cardInfoEncrypted {
    // handle the email info
    if (email && ([email.text isEqualToString:@""] || [email.text isEqualToString:@"No email given"]) ) {
        [(BTPaymentViewController *)((AppDelegate *)([[UIApplication sharedApplication] delegate])).navController.topViewController prepareForDismissal];
        [[[UIAlertView alloc] initWithTitle: @"Email"
                                    message: @"Please put in a real email. You'll need this to recieve your prize."
                                   delegate: self.del
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    } else {
        NSString *path = [NSString stringWithFormat:@"user/%@",((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId];
        NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.email.text, @"email", nil];
        // update the user's email
        [[API sharedInstance] put:path withParams:params onCompletion:^(NSDictionary *json) {
            // do diddly squat
        }];
    }
    
    // Determine if we are in test-mode or real mode
    BTEncryption * braintree;
    if ([[[API sharedInstance].baseURL absoluteString] isEqualToString:@"http://localhost:5000"]
        || [[[API sharedInstance].baseURL absoluteString] isEqualToString:@"http://betchyu-staging.herokuapp.com"]) {
        braintree = [[BTEncryption alloc]initWithPublicKey:@"MIIBCgKCAQEAmRehlELjqxPOltj1/bpsQE92opagAj6tFB8wo4Z/Dy0x7nugGnC7fvvvIEo5MEoKg6HvU1GSmpP7VQ4XU/8YDXblbaKsLgb5K92BySKwM1FyHoL2IfRrEDdJcV9tMJ9hjZbIcg7uBUYhT/rgpWBRaDVLMEAMnqvSH7UZ2wlCjjT1NJScrMDd4EyXQQcXSdc5ri9C62QfzopVxA6iOvK8YPkzRkmNUQOkEf67v+kiUgh2w2YWEXogmRCUoUpdzODJ689UcpqyMHrwouC+WxqLJK/0zDHy44Fofc/Sqp4Wf19fslXmb4HW8u5GqQUV/5PXi3B+j4tOeXxXynTeOKtcqQIDAQAB"];
    } else { // real production server
        braintree = [[BTEncryption alloc]initWithPublicKey:@"MIIBCgKCAQEA1FfiDXfYBxtcOCu7wcOK+0/n4q4C6WUaakP8/PzflZRJ30Ac+onTkzPLct4InPoL/P6CCkLOUQrcFcXZRFIdvCieAks1dY53c5TnBV8f8dqFA/CZQm+J1O/W+m+aAIIUyre6qbZ7Wv2IC2tRDM4nW9RcWIIQ7c9ZNpHfdP4muIpEWvF0D0VplRjkdTZUMSxR9/nJ7fqfYTazEmo9GXDa7LPf22r178Iq9WTlKfk6APNE7aYrx8zN21FshweJgBBRZxh4LFmBd+j1DzLciBJNjFh1JA98D+40XGLj+9SPXoVCSznshW4X5sV970W0rnCwU01VTBk/8N3HWgwbZK6mnwIDAQAB"];
    }
    
    // Do something with cardInfo dictionary
    NSMutableDictionary *enc = [[NSMutableDictionary alloc]initWithDictionary:cardInfoEncrypted]; // nil to begin with unless VenmoT is used
    
    // manually encrypt the cardInfo
    [cardInfo enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
        [enc setObject: [braintree encryptString: object] forKey: key];
    }];
    
    NSString *ownerString = ((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId;
    [enc setValue:ownerString forKey:@"user"];
    [enc setValue:self.bet.stakeAmount forKey:@"amount"];
    if (self.ident) {
        [enc setValue:self.ident forKey:@"bet_id"];
    } else {
        [enc setValue:@(self.bet.friends.count) forKey:@"opponent_count"];
    }
    
    //make the call to the web API to post the card info and determine valid-ness
    // POST /card => {data}
    [[API sharedInstance] post:@"card" withParams:enc onCompletion:^(NSDictionary *json) {
        // call this, because we aren't loading anymore
        // Don't forget to call the cleanup method,
        // 'prepareForDismissal', on your 'BTPaymentViewController' in order to remove the loading thing that pops up automatically
        //  this line assumes that the BTPaymentViewController is at the top of the navController stack
        [(BTPaymentViewController *)((AppDelegate *)([[UIApplication sharedApplication] delegate])).navController.topViewController prepareForDismissal];
        
        // show the credit card status, and do things based on it
        [[[UIAlertView alloc] initWithTitle: @"Credit Card"
                                    message: [json objectForKey:@"msg"]
                                   delegate: self.del
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        // delegate handles whatever the app needs to have happen next.
    }];
}

@end
