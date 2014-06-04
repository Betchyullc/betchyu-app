//
//  PendingBetsView.m
//  betchyu
//
//  Created by Adam Baratz on 6/3/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import "PendingBetsView.h"

@implementation PendingBetsView

- (id)initWithFrame:(CGRect)frame //AndPendingBets:(NSArray *)pending
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        int fontSize = 14;
        int rowHt = 100;
        if (frame.size.width > 700) {
            fontSize = 21;
            rowHt = 120;
        }
        UIColor *dark  = [UIColor colorWithRed:71.0/256 green:71.0/256 blue:82.0/256 alpha:1.0];
        UIColor *light = [UIColor colorWithRed:213.0/256 green:213.0/256 blue:214.0/256 alpha:1.0];
        UIColor *green = [UIColor colorWithRed:173.0/256 green:196.0/256 blue:81.0/256 alpha:1.0];
        UIColor *red   = [UIColor colorWithRed:219.0/256 green:70.0/256 blue:38.0/256 alpha:1.0];
        
        // Background
        [self setBackgroundColor:[UIColor whiteColor]];
        
        // Title bar
        UIView *heading = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, fontSize*1.8)];
        [heading setBackgroundColor:dark];
        //Adds a shadow to heading
        heading.layer.shadowOffset = CGSizeMake(0, 5);
        heading.layer.shadowColor = [dark CGColor];
        heading.layer.shadowRadius = 2.5f;
        heading.layer.shadowOpacity = 0.60f;
        heading.layer.shadowPath = [[UIBezierPath bezierPathWithRect:heading.layer.bounds] CGPath];
        // Adds text to the heading
        UILabel *title  = [[UILabel alloc]initWithFrame:CGRectMake(10, 3, frame.size.width - 20, fontSize*1.5)];
        title.text = @"Pending Bets";
        title.font = [UIFont fontWithName:@"ProximaNova-Bold" size:fontSize];
        title.textColor = [UIColor whiteColor];
        title.textAlignment = NSTextAlignmentLeft;
        [heading addSubview:title];
        
        
        // add everything
        [self addSubview:heading];
    }
    return self;
}

-(UIView *)getFBPic:(NSString *)userId WithDiameter:(int)dim AndFrame:(CGRect)frame{
    // The Border
    UIView *profBorder = [[UIView alloc] initWithFrame:frame];
    profBorder.backgroundColor = [UIColor colorWithRed:213.0/256 green:213.0/256 blue:214.0/256 alpha:1.0];
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

- (void) setBetDescription:(NSDictionary *)obj ForLabel:(UILabel *)lab {
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // Success! Include your code to handle the results here
            lab.text = [NSString stringWithFormat:@"%@ will %@ %@ %@ in ", [result valueForKey:@"name"], [obj valueForKey:@"betVerb"], [obj valueForKey:@"betAmount"], [obj valueForKey:@"betNoun"]];
            [self addSubview:lab];
        } else {
            // An error occurred, we need to handle the error
            // See: https://developers.facebook.com/docs/ios/errors
        }
    }];
}

-(void)addBets:(NSArray *)pending {
    // convinience variables
    CGRect frame = self.frame;
    int fontSize = 14;
    int rowHt = 100;
    if (frame.size.width > 700) {
        fontSize = 21;
        rowHt = 120;
    }
    // colors
    UIColor *dark  = [UIColor colorWithRed:71.0/256 green:71.0/256 blue:82.0/256 alpha:1.0];
    UIColor *light = [UIColor colorWithRed:213.0/256 green:213.0/256 blue:214.0/256 alpha:1.0];
    UIColor *green = [UIColor colorWithRed:173.0/256 green:196.0/256 blue:81.0/256 alpha:1.0];
    UIColor *red   = [UIColor colorWithRed:219.0/256 green:70.0/256 blue:38.0/256 alpha:1.0];
    // Bets loop
    int c = pending.count;
    int off = fontSize*1.8;
    if (c == 0) {
        // show --None-- message
    } else {
        for (int i = 0; i < c; i++) {
            NSDictionary *obj = [pending objectAtIndex:i];
            // Profile image
            int diameter = frame.size.width / 6.7 ;
            CGRect picF  = CGRectMake(frame.size.width/16, rowHt * i + off + rowHt/6, diameter, diameter);
            UIView *pic = [self getFBPic:[obj valueForKey:@"owner"] WithDiameter:diameter AndFrame:picF];
            
            // Buttons
            int yB      = (rowHt * i) + rowHt/1.5 + off;
            int xMargin = frame.size.width/4.4;
            int widthB  = frame.size.width/5.5;
            int heightB = rowHt / 3.4;
            // Accept Button
            UIButton * accept = [[UIButton alloc] initWithFrame:CGRectMake(xMargin, yB, widthB, heightB)];
            accept.backgroundColor = green;
            [accept setTitle:@"Accept" forState:UIControlStateNormal];
            [accept setTintColor:[UIColor whiteColor]];
            accept.font = [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize];
            accept.layer.cornerRadius = 9;
            accept.clipsToBounds = YES;
            // Reject Button
            UIButton * reject = [[UIButton alloc] initWithFrame:CGRectMake(xMargin + widthB + widthB/6, yB, widthB, heightB)];
            reject.backgroundColor = red;
            [reject setTitle:@"Reject" forState:UIControlStateNormal];
            [reject setTintColor:[UIColor whiteColor]];
            reject.font = [UIFont fontWithName:@"ProximaNova-Regular" size:(fontSize-1)];
            reject.layer.cornerRadius = 9;
            reject.clipsToBounds = YES;
            
            // Description string
            UILabel *desc      = [[UILabel alloc]initWithFrame:CGRectMake(xMargin + 10, off + off/2 + rowHt*i, frame.size.width/2.4, rowHt/1.7)];
            [self setBetDescription:obj ForLabel:desc];
            desc.font          = [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize+3];
            desc.textColor     = dark;
            desc.textAlignment = NSTextAlignmentLeft;
            desc.lineBreakMode = NSLineBreakByWordWrapping;
            
            // Bottom line divider thingie
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width/16, rowHt + off + rowHt*i, 14*frame.size.width/16, 2)];
            line.backgroundColor = light;
            
            // Add everything
            [self addSubview:accept];
            [self addSubview:reject];
            [self addSubview:pic];
            [self addSubview:line];
            //[self addSubview:desc];
        }
    }
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
