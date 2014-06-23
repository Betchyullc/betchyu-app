//  DashHeaderView.m
//  betchyu
//
//  Created by Daniel Zapata on 6/2/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.

#import "DashHeaderView.h"

@implementation DashHeaderView

@synthesize profPic;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // You gotta paint the background before you do this shit!
        [self setBackgroundColor:[UIColor whiteColor]];
        
        [self setUpProfilePic:YES];
        [self setUpName:NO];
        
        UIButton *goToProfileBtn = [[UIButton alloc] initWithFrame:frame];
        [goToProfileBtn addTarget:self action:@selector(goToProfile) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:goToProfileBtn];
    }
    return self;
}

-(void) setUpProfilePic:(BOOL)notCalled {
    // Hey, bitch, gimme some o' dem covinience variabizzles.
    NSString * ownId = ((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId;
    int dim = self.frame.size.width / 6; // da width o' da pic
    int xMargin = dim/4;
    if (self.frame.size.width > 500) {
        dim = self.frame.size.width / 8;
        xMargin = dim/2;
    }
    
    // And don' forget t' check da ownId
    if ([ownId isEqualToString:@""]) {
        // we need to wait a bit before setting up the profile pic
        [self performSelector:@selector(setUpProfilePic:) withObject:NO afterDelay:1];
        return;
    }
    
    // Mothafucka, set up ya own damn picture!
    self.profPic = [[FBProfilePictureView alloc]
                    initWithProfileID:ownId
                    pictureCropping:FBProfilePictureCroppingSquare];
    self.profPic.frame = CGRectMake(xMargin, dim/4, dim, dim);
    self.profPic.layer.cornerRadius  = dim/2;
    self.profPic.layer.borderWidth   = 2;
    self.profPic.layer.borderColor   = [Blight CGColor];
    self.profPic.layer.masksToBounds = YES;
    [self addSubview:self.profPic];
}

-(void) setUpName:(BOOL)called {
    // Hey, bitch, gimme some o' dem covinience variabizzles.
    NSString * ownId = ((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId;
    CGRect f = self.frame;
    
    // And don' forget t' check da ownId
    if ([ownId isEqualToString:@""]) {
        // we need to wait a bit before setting up the profile pic
        [self performSelector:@selector(setUpName:) withObject:NO afterDelay:1];
        return;
    }
    
    int fontSize = 20;
    if (f.size.width > 500) {
        fontSize = 35;
    }
    
    // ownId was good
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // Success! Include your code to handle the results here
            UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, (f.size.height/4), f.size.width, f.size.height/2)];
            name.text = [result valueForKey:@"name"];
            name.textAlignment = NSTextAlignmentCenter;
            name.textColor = Borange;
            name.font = FblackfS;
            [self addSubview:name];
        } else {
            // An error occurred, we need to handle the error
            // See: https://developers.facebook.com/docs/ios/errors
        }
    }];
}

-(void) goToProfile {
    EditProfileVC *vc = [[EditProfileVC alloc] init];
    [((AppDelegate *)([[UIApplication sharedApplication] delegate])).navController pushViewController:vc animated:YES];
}
@end
