//
//  FriendsBetsSubview.m
//  betchyu
//
//  Created by Adam Baratz on 6/9/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import "FriendsBetsSubview.h"

@implementation FriendsBetsSubview

@synthesize bets;

@synthesize fontSize;
@synthesize rowHt;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.fontSize = 14;
        self.rowHt = 70;
        if (frame.size.width > 700) {
            self.fontSize = 21;
            self.rowHt = 100;
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
        title.text = @"Friend's Bets";
        title.font = [UIFont fontWithName:@"ProximaNova-Bold" size:fontSize];
        title.textColor = [UIColor whiteColor];
        title.textAlignment = NSTextAlignmentLeft;
        [heading addSubview:title];
        
        // add everything
        [self addSubview:heading];

    }
    return self;
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
            [self addSubview:lab];
        } else {
            // An error occurred, we need to handle the error
            // See: https://developers.facebook.com/docs/ios/errors
        }
    }];
}

// populate the main area with bets stuff
-(void)addBets:(NSArray *)betList {
    self.bets = betList;
    
    // clear all the bet subviews
    /*for (int i=0; i<self.bits.count; i++){
        [[bits objectAtIndex:i] performSelectorOnMainThread:@selector(removeFromSuperview) withObject:Nil waitUntilDone:NO];
    }
    [bits removeAllObjects];
    */
    // convinience variables
    CGRect frame = self.frame;
    // colors
    UIColor *dark  = [UIColor colorWithRed:71.0/256 green:71.0/256 blue:82.0/256 alpha:1.0];
    UIColor *light = [UIColor colorWithRed:213.0/256 green:213.0/256 blue:214.0/256 alpha:1.0];
    UIColor *green = [UIColor colorWithRed:173.0/256 green:196.0/256 blue:81.0/256 alpha:1.0];
    UIColor *red   = [UIColor colorWithRed:219.0/256 green:70.0/256 blue:38.0/256 alpha:1.0];
    // Bets loop
    int c = betList.count;
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
            NSDictionary *obj = [betList objectAtIndex:i];
            
            // measurment variables
            int yB      = (rowHt * i) + off;
            int xMargin = frame.size.width/4.4;
            int widthB  = frame.size.width/5.5;
            int heightB = rowHt / 3.4;
            
            // Profile Image
            int diameter = frame.size.width / 6.7 ;
            CGRect picF  = CGRectMake(frame.size.width/17, yB + rowHt/6, diameter, diameter);
            UIView *pic = [self getFBPic:[obj valueForKey:@"owner"] WithDiameter:diameter AndFrame:picF];
            
            // Tappable, Invisible Button
            UIButton *tap = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            tap.frame = CGRectMake(0, yB, frame.size.width, rowHt);
            tap.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
            [tap addTarget:self action:@selector(viewBet:) forControlEvents:UIControlEventTouchUpInside];
            tap.tag = i;
            
            // Description string
            UILabel *desc      = [[UILabel alloc]initWithFrame:CGRectMake(xMargin, yB, frame.size.width/1.65, rowHt)];
            desc.font          = [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize+1];
            desc.textColor     = dark;
            desc.textAlignment = NSTextAlignmentLeft;
            desc.lineBreakMode = NSLineBreakByWordWrapping;
            desc.numberOfLines = 0;
            [self setBetDescription:obj ForLabel:desc];
            
            // End Date String
            UILabel *date      = [[UILabel alloc]initWithFrame:CGRectMake(xMargin, yB+desc.font.pointSize*1.6, frame.size.width/2, rowHt)];
            date.font          = [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize-2];
            date.textColor     = light;
            date.textAlignment = NSTextAlignmentLeft;
            date.lineBreakMode = NSLineBreakByWordWrapping;
            date.numberOfLines = 0;
            // manipulating the date stuff to calculate the actual end-date
            [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *d1 = [dateFormatter dateFromString: [[obj valueForKey:@"created_at"] substringWithRange:NSMakeRange(0, 10)]];
            NSDateComponents *dc = [[NSDateComponents alloc] init];
            [dc setDay:[[obj valueForKey:@"duration"]intValue]]; // actually add the duration
            NSDate *d2 = [[NSCalendar currentCalendar]
                          dateByAddingComponents:dc
                          toDate:d1 options:0];
            date.text = [NSString stringWithFormat:@"End Date: %@", [dateFormatter stringFromDate:d2]];
            
            // arrow to indicate tapability
            UILabel *arrow      = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width - xMargin/2, yB, frame.size.width/2, rowHt)];
            arrow.font          = [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize+3];
            arrow.textColor     = light;
            arrow.textAlignment = NSTextAlignmentLeft;
            arrow.text          = [NSString stringWithUTF8String:"❯"];
            
            // Bottom line divider thingie
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width/16, rowHt + off + rowHt*i, 14*frame.size.width/16, 2)];
            line.backgroundColor = light;
            
            // Add everything
            [self addSubview:pic];
            //[self.bits addObject:pic];
            [self addSubview:tap];
            // desc is added by method which sets text
            [self addSubview:date];
            [self addSubview:arrow];
            [self addSubview:line];
            //[self.bits addObject:line];
            //[self addSubview:desc]; Don't need to do this b/c [self setBetDescription: ForLabel]
        }
    }
    
}

// API call stuff
-(void)viewBet:(UIButton *)sender {
    ExistingBetDetailsVC *vc = [[ExistingBetDetailsVC alloc] initWithJSON:[bets objectAtIndex:sender.tag]];
    vc.title = @"Bet Details";
    [((AppDelegate *)([[UIApplication sharedApplication] delegate])).navController pushViewController:vc animated:YES];
}

@end
