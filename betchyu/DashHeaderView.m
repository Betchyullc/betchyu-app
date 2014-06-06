//
//  DashHeaderView.m
//  betchyu
//
//  Created by Adam Baratz on 6/2/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import "DashHeaderView.h"

@implementation DashHeaderView

@synthesize profPic;
@synthesize profBorder;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // You gotta paint the background before you do this shit!
        [self setBackgroundColor:[UIColor whiteColor]];
        
        // Hey, bitch, gimme some o' dem covinience variabizzles.
        NSString * ownId = ((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId;
        
        [self setUpProfilePic:YES];
        [self setUpName:NO];
    }
    return self;
}

-(void) setUpProfilePic:(BOOL)notCalled {
    // Hey, bitch, gimme some o' dem covinience variabizzles.
    NSString * ownId = ((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId;
    int dim = self.frame.size.width / 6; // da width o' da pic

    if (notCalled) {
        // An' da border too!
        self.profBorder = [[UIView alloc] initWithFrame:CGRectMake(dim/4, dim/4, dim, dim)];
        self.profBorder.backgroundColor = [UIColor colorWithRed:213.0/256 green:213.0/256 blue:214.0/256 alpha:1.0];
        self.profBorder.layer.cornerRadius = dim/2;
        [self addSubview:self.profBorder];
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
    self.profPic.frame = CGRectMake(2, 2, dim-4, dim-4);
    self.profPic.layer.cornerRadius = (dim-4)/2;
    [self.profBorder addSubview:self.profPic];
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
    
    // ownId was good
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // Success! Include your code to handle the results here
            UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, (f.size.height/4), f.size.width, f.size.height/2)];
            name.text = [result valueForKey:@"name"];
            name.textAlignment = NSTextAlignmentCenter;
            name.textColor = [UIColor colorWithRed:243.0/256 green:116.0/256 blue:67.0/256 alpha:1.0];
            name.font = [UIFont fontWithName:@"ProximaNova-Black" size:20];
            [self addSubview:name];
        } else {
            // An error occurred, we need to handle the error
            // See: https://developers.facebook.com/docs/ios/errors
        }
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
