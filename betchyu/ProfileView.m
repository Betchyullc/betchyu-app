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
        
        [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                // Success! Include your code to handle the results here
                UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/3, 40 + dim, frame.size.width, 20)];
                name.text = [result valueForKey:@"name"];
                name.textColor = Borange;
                name.font = FregfS;
                [self addSubview:name];
                
                UILabel *email = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/3, 40 + dim + 35, frame.size.width, 20)];
                email.text = [result valueForKey:@"email"];
                email.textColor = Borange;
                email.font = FregfS;
                [self addSubview:email];
            } else {
                // An error occurred, we need to handle the error
                // See: https://developers.facebook.com/docs/ios/errors
            }
        }];
        
    }
    return self;
}

@end
