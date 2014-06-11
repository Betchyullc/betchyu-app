//
//  FlyoutTopView.m
//  betchyu
//
//  Created by Adam Baratz on 6/10/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import "FlyoutTopView.h"

@implementation FlyoutTopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIColor *betchyu = [UIColor colorWithRed:(243/255.0) green:(116.0/255.0) blue:(67/255.0) alpha:1.0];
        UIColor *dark  = [UIColor colorWithRed:71.0/255 green:71.0/255 blue:82.0/255 alpha:1.0];
        UIColor *green = [UIColor colorWithRed:173.0/255 green:196.0/255 blue:81.0/255 alpha:1.0];
        int off = 35;
        NSString * ownId = ((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId;
        self.backgroundColor = [UIColor whiteColor];
        // add shadow
        self.layer.shadowOffset = CGSizeMake(0, 5);
        self.layer.shadowColor = [dark CGColor];
        self.layer.shadowRadius = 2.5f;
        self.layer.shadowOpacity = 0.50f;
        self.layer.shadowPath = [[UIBezierPath bezierPathWithRect:self.layer.bounds] CGPath];
        
        // Status bar coloring
        UIView *bar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, off - 9)];
        bar.backgroundColor = betchyu;
        
        // Picture
        // The Border
        int dim = frame.size.width/2;
        CGRect picF = CGRectMake(frame.size.width/4, frame.origin.y + off, dim, dim);
        UIView *profBorder = [[UIView alloc] initWithFrame:picF];
        profBorder.backgroundColor = [UIColor colorWithRed:213.0/255 green:213.0/255 blue:214.0/255 alpha:1.0];
        profBorder.layer.cornerRadius = dim/2;
        
        // The Picture inside it
        FBProfilePictureView *profPic = [[FBProfilePictureView alloc]
                                         initWithProfileID:((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId
                                         pictureCropping:FBProfilePictureCroppingSquare];
        profPic.frame = CGRectMake(2, 2, dim-4, dim-4);
        profPic.layer.cornerRadius = (dim-4)/2;
        [profBorder addSubview:profPic];
        
        // The Name Under It
        [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                // Success! Include your code to handle the results here
                UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.origin.y + off + dim + 5, frame.size.width, 20)];
                name.text = [result valueForKey:@"name"];
                name.textAlignment = NSTextAlignmentCenter;
                name.textColor = betchyu;
                name.font = [UIFont fontWithName:@"ProximaNova-Black" size:20];
                [self addSubview:name];
            } else {
                // An error occurred, we need to handle the error
                // See: https://developers.facebook.com/docs/ios/errors
            }
        }];
        
        // The Bets Completed
        UILabel *bets = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.origin.y + off + dim + dim/2.7, frame.size.width, 20)];
        bets.text = @"Bets Completed\t\tBets Won";
        bets.textAlignment = NSTextAlignmentCenter;
        bets.textColor = dark;
        bets.font = [UIFont fontWithName:@"ProximaNova-Black" size:13];
        // first circle for completed bets
        UIView *c1 = [[UIView alloc]initWithFrame:CGRectMake(10, bets.frame.origin.y +2, 16, 16)];
        c1.backgroundColor = green;
        c1.layer.cornerRadius = 8;
        // second circle, for won bets
        UIView *c2 = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width/2 +20, bets.frame.origin.y +2, 16, 16)];
        c2.backgroundColor = green;
        c2.layer.cornerRadius = 8;
        // actual value of goals achieved
        NSString *path = [NSString stringWithFormat:@"achievements-count/%@", ownId];
        [[API sharedInstance] get:path withParams:nil onCompletion:^(NSDictionary *json) {
            UILabel *name = [[UILabel alloc] initWithFrame:c1.frame];
            name.text = [[json valueForKey:@"completed"] stringValue];
            name.textAlignment = NSTextAlignmentCenter;
            name.textColor = [UIColor whiteColor];
            name.font = [UIFont fontWithName:@"ProximaNova-Bold" size:13];
            [self addSubview:name];
            
            UILabel *won        = [[UILabel alloc] initWithFrame:c2.frame];
            won.text            = [[json valueForKey:@"won"] stringValue];
            won.textAlignment   = NSTextAlignmentCenter;
            won.textColor       = [UIColor whiteColor];
            won.font            = [UIFont fontWithName:@"ProximaNova-Bold" size:13];
            [self addSubview:won];
        }];

        
        // Add Everything
        [self addSubview:bar];
        [self addSubview:profBorder];
        [self addSubview:bets];
        [self addSubview:c1];
        [self addSubview:c2];
    }
    return self;
}

@end
