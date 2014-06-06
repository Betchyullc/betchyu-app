//
//  CurrentBetsView.m
//  betchyu
//
//  Created by Adam Baratz on 6/5/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import "MyBetsView.h"

@implementation MyBetsView

@synthesize scroller;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    NSLog(@"%@", NSStringFromCGRect(frame));
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
        heading.layer.shadowOffset = CGSizeMake(0, 4);
        heading.layer.shadowColor = [dark CGColor];
        heading.layer.shadowRadius = 2.5f;
        heading.layer.shadowOpacity = 0.60f;
        heading.layer.shadowPath = [[UIBezierPath bezierPathWithRect:heading.layer.bounds] CGPath];
        // Adds text to the heading
        UILabel *title  = [[UILabel alloc]initWithFrame:CGRectMake(10, 3, frame.size.width - 20, fontSize*1.5)];
        title.text = @"My Bets";
        title.font = [UIFont fontWithName:@"ProximaNova-Bold" size:fontSize];
        title.textColor = [UIColor whiteColor];
        title.textAlignment = NSTextAlignmentLeft;
        [heading addSubview:title];
        
        // Scroller to contain the actual bets summaries
        self.scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, heading.frame.size.height, frame.size.width, frame.size.height - heading.frame.size.height)];
        scroller.contentSize   = scroller.frame.size;

        
        // add everything
        [self addSubview:heading];
        [self addSubview:scroller];
    }
    return self;
}

// populate the main area with bets stuff
-(void)addBets:(NSArray *)pending {
    // convinience variables
    CGRect frame = self.scroller.frame;
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
        UILabel *none = [[UILabel alloc]initWithFrame:CGRectMake(0, off, frame.size.width, frame.size.height-off)];
        none.text = @"None";
        none.font = [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize*1.4];
        none.textColor = dark;
        none.textAlignment = NSTextAlignmentCenter;
        [self addSubview:none];
    } else {
        for (int i = 0; i < c; i++) {
            NSDictionary *obj = [pending objectAtIndex:i];
            
            // Buttons
            int yB      = (rowHt * i);
            int xMargin = frame.size.width/4.4;
            int widthB  = frame.size.width/5.5;
            int heightB = rowHt / 3.4;
            UIButton *pic = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            pic.frame = CGRectMake(0, rowHt*i, frame.size.width/6, rowHt);
            [pic setImage:[self getImageFromBet:obj] forState:UIControlStateNormal];
            pic.tintColor = green;
            
            // Description string
            UILabel *desc      = [[UILabel alloc]initWithFrame:CGRectMake(xMargin, yB, frame.size.width/2.4, rowHt)];
            desc.font          = [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize+3];
            desc.textColor     = dark;
            desc.textAlignment = NSTextAlignmentLeft;
            desc.lineBreakMode = NSLineBreakByWordWrapping;
            desc.numberOfLines = 0;
            [self setBetDescription:obj ForLabel:desc];
            
            // Bottom line divider thingie
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width/16, rowHt + yB, 14*frame.size.width/16, 2)];
            line.backgroundColor = light;
            
            // Add everything
            [self.scroller addSubview:line];
            [self.scroller addSubview:pic];
        }
    }
}

// helpers
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
            NSString *noun = [[obj valueForKey:@"noun"] lowercaseString];
            // Success! Include your code to handle the results here
            if ([noun isEqualToString:@"smoking"]) {
                lab.text = [NSString stringWithFormat:@"%@ will %@ %@ for %@ days", [result valueForKey:@"name"], [[obj valueForKey:@"verb"] lowercaseString], noun, [obj valueForKey:@"duration"]];
            }
            else {
                lab.text = [NSString stringWithFormat:@"%@ will %@ %@ %@ in %@ days", [result valueForKey:@"name"], [[obj valueForKey:@"verb"] lowercaseString], [obj valueForKey:@"amount"], noun, [obj valueForKey:@"duration"]];
            }
            [self.scroller addSubview:lab];
        } else {
            // An error occurred, we need to handle the error
            // See: https://developers.facebook.com/docs/ios/errors
        }
    }];
}

- (UIImage *) getImageFromBet:(NSDictionary *)obj {
    return [UIImage imageNamed:@"info_button.png"];
    NSString *noun = [[obj valueForKey:@"noun"] lowercaseString];
    if ([noun isEqualToString:@"pounds"]) {
        return [UIImage imageNamed:@"weight.png"];
    }
    else if ([noun isEqualToString:@"smoking"]){
        return [UIImage imageNamed:@"cigarette.png"];
    }
    else {
        return [UIImage imageNamed:@"weight.png"];
    }
}

// API call stuff

@end
