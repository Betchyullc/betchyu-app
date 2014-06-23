//  FriendsPastBetsView.m
//  betchyu
//
//  Created by Daniel Zapata on 6/11/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.

#import "FriendsPastBetsView.h"

@implementation FriendsPastBetsView

@synthesize rowHt;
@synthesize fontSize;
@synthesize bets;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.fontSize = 14;
        self.rowHt = 70;
        if (frame.size.width > 700) {
            self.fontSize = 21;
            self.rowHt = 100;
        }
        
        HeadingBarView * h = [[HeadingBarView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, fontSize*1.8) AndTitle:@"Your Friends' Past Bets"];
        [self addSubview:h];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)drawBets:(NSArray *)betList {
    self.bets = betList;
    // convinience variables
    CGRect frame = self.frame;
    int off = fontSize*1.8;
    int xMargin = frame.size.width/4.4;
    
    // Bets loop
    int c = bets.count;
    if (c == 0) {
        // show --None-- message
        UILabel *none = [[UILabel alloc]initWithFrame:CGRectMake(0, off, frame.size.width, frame.size.height-off)];
        none.text = @"None";
        none.font = [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize*1.4];
        none.textColor = Bdark;
        none.textAlignment = NSTextAlignmentCenter;
        [self addSubview:none];
    } else {
        for (int i = 0; i < c; i++) {
            NSDictionary *obj = [bets objectAtIndex:i];
            
            // measurment vars
            int yB      = (rowHt * i) + off;
            
            // Tappable, Invisible Button
            UIButton *tap = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            tap.frame = CGRectMake(0, yB, frame.size.width, rowHt);
            tap.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
            [tap addTarget:self action:@selector(viewBet:) forControlEvents:UIControlEventTouchUpInside];
            tap.tag = i;
            
            // Type Graphic
            // use a button to dispaly a pic for tint funcionality
            int dim = rowHt/1.5;
            CGRect picF = CGRectMake(xMargin/4, yB + off/2, dim, dim);
            UIColor * tintC;                // var to hold the color we're using to tint this graphic
            int rand = i % 3;               // random from 0,1,2
            switch (rand) {                 // set the tintC from the rand
                case 0:
                    tintC = Bgreen;
                    break;
                case 1:
                    tintC = Bred;
                    break;
                case 2:
                default:
                    tintC = Bblue;
                    break;
            }
            FBProfilePictureView *pic = [self getImageFromBet:obj];
            // set the frame for said graphic button
            pic.frame = picF;
            pic.layer.cornerRadius = pic.frame.size.width/2;
            pic.layer.borderWidth = 2;
            pic.layer.borderColor = tintC.CGColor;
            
            // Bet Description String
            UILabel *desc      = [[UILabel alloc]initWithFrame:CGRectMake(xMargin, yB, frame.size.width/1.5, rowHt)];
            desc.font          = [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize+1];
            desc.textColor     = Bdark;
            desc.textAlignment = NSTextAlignmentLeft;
            desc.lineBreakMode = NSLineBreakByWordWrapping;
            desc.numberOfLines = 0;
            desc.text          = [self getBetDescription:obj];
            
            // End Date String
            UILabel *result      = [[UILabel alloc]initWithFrame:CGRectMake(xMargin, yB+desc.font.pointSize*1.6, frame.size.width/2, rowHt)];
            result.font          = [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize-2];
            result.textColor     = Blight;
            result.textAlignment = NSTextAlignmentLeft;
            result.lineBreakMode = NSLineBreakByWordWrapping;
            result.numberOfLines = 0;
            NSString *st = [[obj valueForKey:@"status"] isEqualToString:@"won"] ? @"lost" : @"won";
            result.text = [NSString stringWithFormat:@"You %@", st];
            
            // arrow to indicate tapability
            UILabel *arrow      = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width - xMargin/2, yB, frame.size.width/2, rowHt)];
            arrow.font          = [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize+3];
            arrow.textColor     = Blight;
            arrow.textAlignment = NSTextAlignmentLeft;
            arrow.text          = [NSString stringWithUTF8String:"❯"];
            
            // Bottom line divider thingie
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width/16, rowHt + yB - 2, 14*frame.size.width/16, 2)];
            line.backgroundColor = Blight;
            
            // Add everything
            [self addSubview:line];
            [self addSubview:pic];
            [self addSubview:desc];
            [self addSubview:result];
            [self addSubview:arrow];
            [self addSubview:tap];
        }
    }
}

- (FBProfilePictureView *) getImageFromBet:(NSDictionary *)obj {
    // The Picture inside it
    return [[FBProfilePictureView alloc] initWithProfileID:[obj valueForKey:@"owner"]
                                           pictureCropping:FBProfilePictureCroppingSquare];
}


- (NSString *) getBetDescription:(NSDictionary *)obj {
    NSString *noun = [[obj valueForKey:@"noun"] lowercaseString];
    
    if ([noun isEqualToString:@"smoking"]) {
        return [NSString stringWithFormat:@"%@ %@ for %@ days", [obj valueForKey:@"verb"], noun, [obj valueForKey:@"duration"]];
    }
    else {
        return [NSString stringWithFormat:@"%@ %@ %@ in %@ days", [obj valueForKey:@"verb"], [obj valueForKey:@"amount"], noun, [obj valueForKey:@"duration"]];
    }
}

// API call stuff
-(void)viewBet:(UIButton *)sender {
    NSMutableDictionary *bet = [[NSMutableDictionary alloc] initWithDictionary:[bets objectAtIndex:sender.tag]];
    [bet setObject:[NSNumber numberWithInt:100] forKey:@"progress"];
    // make the Bet Details View Controller
    ExistingBetDetailsVC *vc = [[ExistingBetDetailsVC alloc] initWithJSON:bet];
    vc.title = @"The Bet";
    [((AppDelegate *)([[UIApplication sharedApplication] delegate])).navController pushViewController:vc animated:YES];
}

@end
