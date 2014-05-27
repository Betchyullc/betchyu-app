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
        UIView *lineView;  //used for drawing lines
        
        self.backgroundColor = [UIColor colorWithRed:(69/255.0) green:(69/255.0) blue:(69/255.0) alpha:1.0];
        
        /////////////////////
        // The back button
        /////////////////////
        // actual buttom
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(25, 40, 80, 30)];
        [backBtn setTitle:@"< Menu" forState:UIControlStateNormal];
        backBtn.font = [UIFont fontWithName:@"ProximaNova-Regular" size:20];
        [backBtn addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        // it's line
        lineView = [[UIView alloc] initWithFrame:CGRectMake(29, 80, frame.size.width, 2)];
        lineView.backgroundColor = [UIColor whiteColor];
        // add to the view
        [self addSubview:backBtn];
        [self addSubview:lineView];
        
        ////////////////////////
        // The Profile Picture
        ////////////////////////
        int dim = frame.size.width / 3;
        // the picture
        FBProfilePictureView *mypic = [[FBProfilePictureView alloc]
                                       initWithProfileID:ownId
                                         pictureCropping:FBProfilePictureCroppingSquare];
        mypic.frame = CGRectMake(2, 2, dim-4, dim-4);
        mypic.layer.cornerRadius = (dim-4)/2;
        // The border
        UIView *border = [[UIView alloc] initWithFrame:CGRectMake((frame.size.width/2)-(dim/2), 90, dim, dim)];
        border.backgroundColor = [UIColor whiteColor];
        border.layer.cornerRadius = dim/2;
        [border addSubview:mypic];
        [self addSubview:border];
        
        [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                // Success! Include your code to handle the results here
                UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, (frame.size.width/2)-(dim/2) + dim +20, frame.size.width, 20)];
                name.text = [[result valueForKey:@"name"] uppercaseString];
                name.textAlignment = NSTextAlignmentCenter;
                name.textColor = [UIColor whiteColor];
                name.font = [UIFont fontWithName:@"ProximaNova-Black" size:20];
                [self addSubview:name];
            } else {
                // An error occurred, we need to handle the error
                // See: https://developers.facebook.com/docs/ios/errors
            }
        }];
        // it's line
        lineView = [[UIView alloc] initWithFrame:CGRectMake(29, (frame.size.width/2)-(dim/2) + dim +60, frame.size.width, 2)];
        lineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:lineView];
        
        /////////////////////////
        // Challenges Completed
        /////////////////////////
        // heading label
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, (frame.size.width/2)-(dim/2) + dim +90, frame.size.width, 20)];
        name.text = @"GOALS ACHEIVED:";
        name.textAlignment = NSTextAlignmentCenter;
        name.textColor = [UIColor whiteColor];
        name.font = [UIFont fontWithName:@"ProximaNova-Regular" size:18];
        [self addSubview:name];
        // actual value of goals achieved
        NSString *path = [NSString stringWithFormat:@"achievements-count/%@", ownId];
        [[API sharedInstance] get:path withParams:nil onCompletion:^(NSDictionary *json) {
            UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, (frame.size.width/2)-(dim/2) + dim +110, frame.size.width, 60)];
            name.text = [[json valueForKey:@"count"] stringValue];
            name.textAlignment = NSTextAlignmentCenter;
            name.textColor = [UIColor whiteColor];
            name.font = [UIFont fontWithName:@"ProximaNova-Regular" size:48];
            [self addSubview:name];
        }];
        
    }
    return self;
}

-(void)backBtnPressed:(id)sender {
    [owner.navigationController popViewControllerAnimated:YES];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
