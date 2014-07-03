//
//  ProfileView.m
//  betchyu
//
//  Created by Adam Baratz on 12/22/13.
//  Copyright (c) 2013 BetchyuLLC. All rights reserved.
//

#import "ProfileView.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import "API.h"

@implementation ProfileView

@synthesize owner;
@synthesize email;

- (id)initWithFrame:(CGRect)frame AndOwner:(UIViewController *)passedOwner {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.owner = passedOwner;
        
        NSString * ownId = ((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId;
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = NO;
        self.clipsToBounds      = NO;
        self.layer.shadowColor  = [Bdark CGColor];
        self.layer.shadowRadius = 3.0f;
        self.layer.shadowOffset = CGSizeMake(0, 5);
        self.layer.shadowOpacity= 0.7f;
        self.layer.shadowPath   = [[UIBezierPath bezierPathWithRect:self.layer.bounds] CGPath];
        
        int fontSize = 17;
        int w = frame.size.width;
        
        ////////////////////////
        // The Profile Picture
        ////////////////////////
        int dim = frame.size.width / 4;
        /// the picture
        FBProfilePictureView *mypic = [[FBProfilePictureView alloc]
                                       initWithProfileID:ownId
                                         pictureCropping:FBProfilePictureCroppingSquare];
        mypic.frame = CGRectMake(20, 20, dim, dim);
        mypic.layer.cornerRadius = dim/2;
        mypic.layer.borderColor = Bmid.CGColor;
        mypic.layer.borderWidth = 2;
        [self addSubview:mypic];
        
        /// The 'Name' indicator
        UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 40 + dim, frame.size.width, 20)];
        nameLbl.text = @"Name";
        nameLbl.textColor = Bmid;
        nameLbl.font = FregfS;
        [self addSubview:nameLbl];
        
        /// The 'Email' indicator
        UILabel *emailLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 40 + dim + 35, frame.size.width, 20)];
        emailLbl.text = @"Email";
        emailLbl.textColor = Bmid;
        emailLbl.font = FregfS;
        [self addSubview:emailLbl];
        
        NSString *path = [NSString stringWithFormat:@"user/%@",ownId];
        [[API sharedInstance] get:path withParams:nil onCompletion:^(NSDictionary *json) {
            // Success! Include your code to handle the results here
            UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/3, 40 + dim, frame.size.width, 20)];
            name.text = [json valueForKey:@"name"];
            name.textColor = Borange;
            name.font = FregfS;
            [self addSubview:name];
            
            self.email          = [[UITextField alloc] initWithFrame:CGRectMake(frame.size.width/3, 40 + dim + 35, frame.size.width, 20)];
            self.email.text     = [json valueForKey:@"email"];
            self.email.textColor= Borange;
            self.email.font     = FregfS;
            [self addSubview:email];
        }];
        
        // the 'Update' button
        UIButton *updateBtn          = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        updateBtn.frame              = CGRectMake(w/4, frame.size.height - fontSize*2.5, w/2, fontSize*2);
        updateBtn.backgroundColor    = Bgreen;
        updateBtn.layer.cornerRadius = 7;
        updateBtn.tintColor          = [UIColor whiteColor];
        updateBtn.titleLabel.font    = [UIFont fontWithName:@"ProximaNova-Bold" size:fontSize];
        [updateBtn setTitle:@"Update" forState:UIControlStateNormal];
        [updateBtn addTarget:self action:@selector(update:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:updateBtn];
        
    }
    return self;
}

-(void) update:(UIButton *)sender {
    NSString *path = [NSString stringWithFormat:@"user/%@",((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId];
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.email.text, @"email", nil];
    
    [[API sharedInstance] put:path withParams:params onCompletion:^(NSDictionary *json) {
        // Success! Include your code to handle the results here
        [self.email resignFirstResponder];
    }];
}

@end
