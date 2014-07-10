//
//  BetterBraintreeView.m
//  betchyu
//
//  Created by Adam Baratz on 7/8/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import "BetterBraintreeView.h"

@implementation BetterBraintreeView

@synthesize email;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSString * ownId = ((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId;
        
        int fontSize = 17;
        
        /// The 'Name' indicator
        UIView *nameBack = [[UIView alloc] initWithFrame:CGRectMake(4, -5, frame.size.width - 8, 30)];
        nameBack.backgroundColor = [UIColor whiteColor];
        nameBack.layer.cornerRadius = 3;
        [self addSubview:nameBack];
        
        UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, frame.size.width, 20)];
        nameLbl.text = @"Name";
        nameLbl.textColor = Bmid;
        nameLbl.font = FregfS;
        [self addSubview:nameLbl];
        
        /// The 'Email' indicator
        UIView *emailBack = [[UIView alloc] initWithFrame:CGRectMake(4, 30, frame.size.width - 8, 30)];
        emailBack.backgroundColor = [UIColor whiteColor];
        emailBack.layer.cornerRadius = 3;
        [self addSubview:emailBack];
        
        UILabel *emailLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 35, frame.size.width, 20)];
        emailLbl.text = @"Email";
        emailLbl.textColor = Bmid;
        emailLbl.font = FregfS;
        [self addSubview:emailLbl];
        
        // email input box
        self.email          = [[UITextField alloc] initWithFrame:CGRectMake(frame.size.width/3, 35, frame.size.width, 20)];
        self.email.keyboardType = UIKeyboardTypeEmailAddress;
        self.email.textColor= Bdark;
        self.email.font     = FregfS;
        self.email.delegate = self;
        
        NSString *path = [NSString stringWithFormat:@"user/%@",ownId];
        [[API sharedInstance] get:path withParams:nil onCompletion:^(NSDictionary *json) {
            // Success! Include your code to handle the results here
            UITextField *name = [[UITextField alloc] initWithFrame:CGRectMake(frame.size.width/3, 0, frame.size.width, 20)];
            name.text = [json valueForKey:@"name"];
            name.textColor = Bdark;
            name.font = FregfS;
            [self addSubview:name];
            
            self.email.text     = [json valueForKey:@"email"];
            [self addSubview:email];
        }];
        
    }
    return self;
}

@end
