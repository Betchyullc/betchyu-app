//
//  BetDetailsView.m
//  betchyu
//
//  Created by Daniel Zapata on 6/12/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import "BetDetailsView.h"

@implementation BetDetailsView

@synthesize ownerIsMale;
@synthesize isMyBet;

- (id)initWithFrame:(CGRect)frame AndBet:(NSDictionary *)bet AndIsMyBet:(BOOL)mine
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.ownerIsMale = YES;
        self.isMyBet = mine;
        self.backgroundColor = [UIColor whiteColor];
        int fontS = 14;
        
/* -----TOP SECTION----- */
        // graphic
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
        pic.tintColor = Blight;          // graphic is always gray (light)
        CompletionBorderView *circle = [[CompletionBorderView alloc] initWithFrame:picF AndColor:[self getColor] AndPercentComplete:[[bet valueForKey:@"progress"] intValue]];
        circle.layer.cornerRadius = circle.frame.size.width/2;
        // text
        UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(10, circle.frame.origin.y + circle.frame.size.height + 15, frame.size.width - 20, 60)];
        desc.font = [UIFont fontWithName:@"ProximaNova-Regular" size:fontS+4];
        desc.textColor = Bdark;
        desc.textAlignment = NSTextAlignmentCenter;
        desc.lineBreakMode = NSLineBreakByWordWrapping;
        desc.numberOfLines = 0;
        [self setBetDescription:bet ForLabel:desc AndUser:[bet valueForKey:@"owner"]]; // also adds label
        
/* -----PROGRESS SECTION------ */
        HeadingBarView * progHeader = [[HeadingBarView alloc] initWithFrame:CGRectMake(0, desc.frame.origin.y + desc.frame.size.height, frame.size.width, fontS*1.8) AndTitle:@"Progress"];
        
        UILabel *dayCount = [[UILabel alloc] initWithFrame:CGRectMake(15, progHeader.frame.origin.y + progHeader.frame.size.height + 10, frame.size.width - 30, 30)];
        dayCount.textColor = Bdark;
        int daysIn = [self getDaysInFromBet:bet];
        int daysInLen = [self charCountForNumber:daysIn];
        int daysLeft = [self getDaysToGoFromBet:bet];
        int daysLeftLen = [self charCountForNumber:daysLeft];
        NSString *text = [NSString stringWithFormat:@"%i days in\t\t\t\t\t%i days to go", daysIn, [self getDaysToGoFromBet:bet]];
        UIFont *boldFont = [UIFont fontWithName:@"ProximaNova-Black" size:fontS+2];
        UIFont *regularFont = [UIFont fontWithName:@"ProximaNovaT-Thin" size:fontS+2];
        UIColor *foregroundColor = Bdark;
        // Create the attributes
        NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                               regularFont, NSFontAttributeName,
                               foregroundColor, NSForegroundColorAttributeName, nil];
        NSDictionary *subAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                  boldFont, NSFontAttributeName, nil];
        const NSRange range = NSMakeRange(0,daysInLen);                // range of first number
        const NSRange range2 = NSMakeRange(daysInLen+13, daysLeftLen); // range of 2nd number
        
        // Create the attributed string (text + attributes)
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attrs];
        [attributedText setAttributes:subAttrs range:range];
        [attributedText setAttributes:subAttrs range:range2];
        // Set it in our UILabel and we are done!
        [dayCount setAttributedText:attributedText];
        
        CGRect dCf = dayCount.frame;
        UIView *line = [UIView new];
        line.frame = CGRectMake(dCf.origin.x, dCf.origin.y+dCf.size.height, dCf.size.width, 2);
        line.backgroundColor = Blight;
        
        UILabel *progDesc = [UILabel new];
        progDesc.frame = CGRectMake(dCf.origin.x, line.frame.origin.y + 12, dCf.size.width, dCf.size.height);
        progDesc.textColor = Bdark;
        progDesc.font = [UIFont fontWithName:@"ProximaNova-Regular" size:fontS+1];
        progDesc.text = [self getProgressTextFromBet:bet];
        
        ProgressBarView *progBar = [[ProgressBarView alloc] initWithFrame:CGRectMake(dCf.origin.x, progDesc.frame.origin.y + progDesc.frame.size.height, dCf.size.width, 15) AndColor:circle.color AndPercentComplete:[[bet valueForKey:@"progress"] intValue]];
        
        UILabel * percProg = [[UILabel alloc] initWithFrame:CGRectMake(dCf.origin.x, progBar.frame.origin.y + progBar.frame.size.height, dCf.size.width, 20)];
        percProg.textColor = Bdark;
        percProg.font = [UIFont fontWithName:@"ProximaNova-Regular" size:fontS-2];
        percProg.text = [NSString stringWithFormat:@"%@\%% complete", [bet valueForKey:@"progress"]];
        
/* -----POSSIBLE UPDATE SECTION, depending on mine flag-----*/
        UpdateView *update;
        if (self.isMyBet) {
            HeadingBarView *updHead = [[HeadingBarView alloc] initWithFrame:CGRectMake(0, percProg.frame.origin.y + percProg.frame.size.height, frame.size.width, fontS*1.8) AndTitle:@"Track Your Progress"];
            update = [[UpdateView alloc] initWithFrame:CGRectMake(0, updHead.frame.origin.y + updHead.frame.size.height, frame.size.width, 100) AndBet:bet];
            
            [self addSubview:updHead];
            [self addSubview:update];
        }
        
        
/* -----STAKE SECTION----- */
        HeadingBarView * stakeHeader;
        if (self.isMyBet) {
            stakeHeader = [[HeadingBarView alloc] initWithFrame:CGRectMake(0, update.frame.origin.y + update.frame.size.height, frame.size.width, fontS*1.8) AndTitle:@"Stake"];
        } else {
            stakeHeader = [[HeadingBarView alloc] initWithFrame:CGRectMake(0, percProg.frame.origin.y + percProg.frame.size.height, frame.size.width, fontS*1.8) AndTitle:@"Stake"];
        }
        NSString *stakeType = [bet valueForKey:@"stakeType"];
        
        UIImageView * stakeImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", stakeType]]];
        int sH = stakeHeader.frame.size.height;
        dim = 2.5*sH;
        CGRect imgF = CGRectMake(15, stakeHeader.frame.origin.y + sH + 15, dim, dim);
        stakeImg.frame = imgF;
        stakeImg.layer.borderColor = Blight.CGColor;
        stakeImg.layer.borderWidth = 2;
        stakeImg.layer.cornerRadius = dim/2;
        stakeImg.layer.masksToBounds = YES;
        
        UILabel *stakeLbl = [[UILabel alloc] initWithFrame:CGRectMake(stakeImg.frame.origin.x + stakeImg.frame.size.width + 25, stakeImg.frame.origin.y, stakeHeader.frame.size.width, 30)];
        stakeLbl.text = [NSString stringWithFormat:@"$%i %@",[[bet valueForKey:@"stakeAmount"] intValue], stakeType];
        stakeLbl.textColor = Bdark;
        stakeLbl.font = [UIFont fontWithName:@"ProximaNova-Regular" size:fontS+2];
        
/* -----OPPONENTS SECTION----- */
        HeadingBarView * opponentsHeader = [[HeadingBarView alloc] initWithFrame:CGRectMake(0, imgF.origin.y + imgF.size.height + 10, frame.size.width, fontS*1.8) AndTitle:@"Opponents"];
        NSArray * opponents = [bet valueForKey:@"opponents"];
        int diameter = frame.size.width/4.3;
        yOff = opponentsHeader.frame.origin.y + opponentsHeader.frame.size.height + 10;
        for (int i = 0; i < opponents.count/4.0; i++) { // rows
            for (int j = 0; j < 4 && j+i < opponents.count; j++) { // columns
                CGRect profF  = CGRectMake(10 + diameter*j, yOff + (diameter+10)*i, diameter, diameter);
                UIView *profPic = [self getFBPic:[opponents objectAtIndex:j+i] WithDiameter:diameter AndFrame:profF];
                profPic.layer.borderColor = [Blight CGColor];
                profPic.layer.borderWidth = 2;
                profPic.layer.masksToBounds = YES;
                [self addSubview:profPic];
            }
        }
        
/* -----COMMENTS SECTION----- */
        HeadingBarView * commentsHeader = [[HeadingBarView alloc] initWithFrame:CGRectMake(0, yOff + MAX(roundf(opponents.count/4.0), 1)*diameter + 10, frame.size.width, fontS*1.8) AndTitle:@"Comments"];
        
        // Add everything
        [self addSubview:pic];
        [self addSubview:circle];
        
        [self addSubview:progHeader];
        [self addSubview:dayCount];
        [self addSubview:line];
        [self addSubview:progDesc];
        [self addSubview:progBar];
        [self addSubview:percProg];
        
        [self addSubview:stakeHeader];
        [self addSubview:stakeImg];
        [self addSubview:stakeLbl];
        
        [self addSubview:opponentsHeader];
        
        [self addSubview:commentsHeader];
        
        // determine contentSize
        self.contentSize = CGSizeMake(frame.size.width, commentsHeader.frame.origin.y + commentsHeader.frame.size.height);
    }
    return self;
}

// Helpers! yay!
-(UIView *)getFBPic:(NSString *)userId WithDiameter:(int)dim AndFrame:(CGRect)frame {
    // The Picture inside it
    FBProfilePictureView *profPic = [[FBProfilePictureView alloc]
                                     initWithProfileID:userId
                                     pictureCropping:FBProfilePictureCroppingSquare];
    profPic.frame = CGRectMake(frame.origin.x+3, frame.origin.y+3, dim-6, dim-6);
    profPic.layer.cornerRadius = (dim-6)/2;
    return profPic;
}

-(UIColor *)getColor {
    UIColor *tintC;
    int rand = arc4random() % 4;               // random from 0,1,2,3
    switch (rand) {                 // set the tintC from the rand
        case 0:
        case 1:
            tintC = Bgreen;
            break;
        case 2:
            tintC = Bred;
            break;
        case 3:
        default:
            tintC = Bblue;
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

- (void) setBetDescription:(NSDictionary *)obj ForLabel:(UILabel *)lab AndUser:(NSString*)usr {
    [FBRequestConnection startWithGraphPath:usr completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            if ([[result valueForKey:@"gender"] isEqualToString:@"female"]) {
                ownerIsMale = NO;
            }
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

-(int)getDaysToGoFromBet:(NSDictionary *)bet {
    [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *start = [dateFormatter dateFromString: [[bet valueForKey:@"created_at"] substringWithRange:NSMakeRange(0, 10)]];
    
    NSDateComponents *components = [NSDateComponents new];
    components.day = [[bet valueForKey:@"duration"] integerValue];
    NSDate *end = [[NSCalendar currentCalendar]dateByAddingComponents:components
                                                               toDate:start
                                                              options:0];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    components = [gregorianCalendar components:NSDayCalendarUnit fromDate:[NSDate date] toDate:end options:0];
    
    return components.day;
}
-(NSString *)getProgressTextFromBet:(NSDictionary *)bet {
    NSString *n = [[bet valueForKey:@"noun"] lowercaseString];
    NSString * two; NSString * three; NSString * four; NSString * five;
    
    //default
    three = [NSString stringWithFormat:@"%.02f",([[bet valueForKey:@"progress"] floatValue] / 100.0 * [[bet valueForKey:@"amount"] intValue])];
    four  = [bet valueForKey:@"amount"];
    five  = n;
    
    if ([n isEqualToString:@"smoking"]) {
        two   = @"not smoked";
        three = [NSString stringWithFormat:@"%.0f",([[bet valueForKey:@"progress"] floatValue] / 100.0 * [[bet valueForKey:@"duration"] integerValue])];
        four  = [bet valueForKey:@"duration"];
        five  = @"days";
    } else if ( [n isEqualToString:@"pounds"] ) {
        two   = @"lost";
    } else if ( [n isEqualToString:@"miles"] ) {
        two   = @"run";
    } else if ( [n isEqualToString:@"times"] ) {
        two   = @"worked out";
    } else {
        two   = @"verbed";
        five  = @"nouns";
    }
    return [NSString stringWithFormat:@"In total, %@ has %@ %@ / %@ %@.", ownerIsMale ? @"he": @"she", two, three, four, five];
}

-(int) charCountForNumber:(int)num {
    int base = (abs(num) == 0) ? 1 : (int)log10(abs(num)) + 1;
    if (num < 0) {
        return base + 1;
    } else {
        return base;
    }
}
@end
