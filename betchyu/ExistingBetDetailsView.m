//
//  ExistingBetDetailsView.m
//  betchyu
//
//  Created by Adam Baratz on 6/12/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import "ExistingBetDetailsView.h"

@implementation ExistingBetDetailsView

- (id)initWithFrame:(CGRect)frame AndBet:(NSDictionary *)bet
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        int fontS = 14;
        // colors
        UIColor *dark  = [UIColor colorWithRed:71.0/255 green:71.0/255 blue:82.0/255 alpha:1.0];
        UIColor *light = [UIColor colorWithRed:213.0/255 green:213.0/255 blue:214.0/255 alpha:1.0];
        UIColor *green = [UIColor colorWithRed:173.0/255 green:196.0/255 blue:81.0/255 alpha:1.0];
        UIColor *red   = [UIColor colorWithRed:219.0/255 green:70.0/255 blue:38.0/255 alpha:1.0];
        UIColor *blue   = [UIColor colorWithRed:83.0/255 green:188.0/255 blue:183.0/255 alpha:1.0];
        
        /* TOP SECTION */
        // graphic
        // use a button to dispaly a pic for tint funcionality
        int dim = frame.size.width/3.5;
        int yOff = 15;
        CGRect picF = CGRectMake(frame.size.width/2 - (dim/2), yOff, dim, dim);
        UIImageView *pic = [[UIImageView alloc] initWithImage:[self getImageFromBet:bet]];      // make the graphic
        // set the frame for said graphic button
        if ([[[bet valueForKey:@"noun"] lowercaseString] isEqualToString:@"smoking"]) {
            pic.frame = CGRectMake(picF.origin.x+2, picF.origin.y+2, picF.size.width-4, picF.size.height-4);
        } else {
            pic.frame = CGRectMake(1+picF.origin.x + ((dim+10)/6), 1+picF.origin.y + ((dim+10)/6), 2*(dim-5)/3, 2*(dim-5)/3);
        }
        pic.image = [pic.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        pic.tintColor = light;          // graphic is always gray (light)
        CompletionBorderView *circle = [[CompletionBorderView alloc] initWithFrame:picF AndColor:[self getColor] AndPercentComplete:[[bet valueForKey:@"progress"] intValue]];
        circle.layer.cornerRadius = circle.frame.size.width/2;
        // text
        UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(10, circle.frame.origin.y + circle.frame.size.height + 15, frame.size.width - 20, 60)];
        desc.font = [UIFont fontWithName:@"ProximaNova-Thin" size:fontS];
        desc.textColor = light;
        desc.textAlignment = NSTextAlignmentCenter;
        desc.lineBreakMode = NSLineBreakByWordWrapping;
        desc.numberOfLines = 0;
        [self setBetDescription:bet ForLabel:desc]; // also adds label
        
        /* PROGRESS SECTION */
        HeadingBarView * progHeader = [[HeadingBarView alloc] initWithFrame:CGRectMake(0, desc.frame.origin.y + desc.frame.size.height, frame.size.width, fontS*1.8) AndTitle:@"Progress"];
        UILabel *dayCount = [[UILabel alloc] initWithFrame:CGRectMake(10, progHeader.frame.origin.y + progHeader.frame.size.height + 10, frame.size.width - 20, 30)];
        dayCount.font = [UIFont fontWithName:@"ProximaNova-Thin" size:fontS];
        dayCount.textColor = dark;
        dayCount.text = [NSString stringWithFormat:@"%i days in\t\t\t days to go", [self getDaysInFromBet:bet]];
        
        /* STAKE SECTION */
        HeadingBarView * stakeHeader = [[HeadingBarView alloc] initWithFrame:CGRectMake(0, desc.frame.origin.y + desc.frame.size.height, frame.size.width, fontS*1.8) AndTitle:@"Stake"];
        
        /* OPPONENTS SECTION */
        HeadingBarView * opponentsHeader = [[HeadingBarView alloc] initWithFrame:CGRectMake(0, desc.frame.origin.y + desc.frame.size.height, frame.size.width, fontS*1.8) AndTitle:@"Opponents"];
        
        /* COMMENTS SECTION */
        HeadingBarView * commentsHeader = [[HeadingBarView alloc] initWithFrame:CGRectMake(0, desc.frame.origin.y + desc.frame.size.height, frame.size.width, fontS*1.8) AndTitle:@"Comments"];
        
        // Add everything
        [self addSubview:pic];
        [self addSubview:circle];
        [self addSubview:progHeader];
        [self addSubview:dayCount];
        // determine contentSize
        self.contentSize = CGSizeMake(frame.size.width, frame.size.height);
    }
    return self;
}

-(UIColor *)getColor {
    UIColor *green = [UIColor colorWithRed:173.0/255 green:196.0/255 blue:81.0/255 alpha:1.0];
    UIColor *red   = [UIColor colorWithRed:219.0/255 green:70.0/255 blue:38.0/255 alpha:1.0];
    UIColor *blue   = [UIColor colorWithRed:83.0/255 green:188.0/255 blue:183.0/255 alpha:1.0];
    UIColor *tintC;
    int rand = arc4random() % 4;               // random from 0,1,2,3
    switch (rand) {                 // set the tintC from the rand
        case 0:
        case 1:
            tintC = green;
            break;
        case 2:
            tintC = red;
            break;
        case 3:
        default:
            tintC = blue;
            break;
    }
    return tintC;
}

- (UIImage *) getImageFromBet:(NSDictionary *)obj {
    NSString *noun = [[obj valueForKey:@"noun"] lowercaseString];
    if ([noun isEqualToString:@"pounds"]) {
        return [UIImage imageNamed:@"scale-02.png"];
    }
    else if ([noun isEqualToString:@"smoking"]){
        return [UIImage imageNamed:@"smoke-04.png"];
    }
    else if ([noun isEqualToString:@"times"]){
        return [UIImage imageNamed:@"workout-05.png"];
    } else if ([noun isEqualToString:@"miles"]){
        return [UIImage imageNamed:@"run-03.png"];
    } else {
        return [UIImage imageNamed:@"info_button.png"];
    }
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

-(int)getDaysInFromBet:(NSDictionary *)bet {
    [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *start = [dateFormatter dateFromString: [[bet valueForKey:@"created_at"] substringWithRange:NSMakeRange(0, 10)]];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:start
                                                          toDate:[NSDate date]
                                                         options:0];
    return components.day;
    
}
@end
