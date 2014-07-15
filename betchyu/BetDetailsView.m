//
//  BetDetailsView.m
//  betchyu
//
//  Created by Daniel Zapata on 6/12/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import "BetDetailsView.h"
#import "UpdateView.h"

@implementation BetDetailsView

@synthesize ownerIsMale;
@synthesize isMyBet;
@synthesize update;

@synthesize comments;
@synthesize commentBox;

@synthesize bet;

- (id)initWithFrame:(CGRect)frame AndBet:(NSDictionary *)b AndIsMyBet:(BOOL)mine AndIsOffer:(BOOL)offer
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.bet = b;
        self.ownerIsMale = YES;
        self.isMyBet = mine;
        self.backgroundColor = [UIColor whiteColor];
        int fontS = 14;
        if (frame.size.width > 500) {
            fontS = 20;
        }
        
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
        int daysLeft = [self getDaysToGoFromBet:bet] + 1;
        int daysLeftLen = [self charCountForNumber:daysLeft];
        NSString *text = [NSString stringWithFormat:@"%i days in\t\t\t\t\t%i days to go", daysIn, daysLeft];
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
        update = nil;
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
        
        UILabel *stakeLbl = [[UILabel alloc] initWithFrame:CGRectMake(stakeImg.frame.origin.x + stakeImg.frame.size.width + 25, stakeImg.frame.origin.y, stakeHeader.frame.size.width, dim)];
        stakeLbl.text = [NSString stringWithFormat:@"$%i %@",[[bet valueForKey:@"stakeAmount"] intValue], stakeType];
        stakeLbl.textColor = Bdark;
        stakeLbl.font = [UIFont fontWithName:@"ProximaNova-Regular" size:fontS+2];
        
/* -----OPPONENTS SECTION----- */
        UIView *next;
        if (offer) {
            HeadingBarView * offerHeader = [[HeadingBarView alloc] initWithFrame:CGRectMake(0, imgF.origin.y + imgF.size.height + 10, frame.size.width, fontS*1.8) AndTitle:@"Offer"];
            [self addSubview:offerHeader];
            int fontSize = 18;
            yOff = offerHeader.frame.origin.y + offerHeader.frame.size.height + 10;
            next = [[UIView alloc] initWithFrame:CGRectMake(0, yOff, frame.size.width, 50)];
            // make accept button
            UIButton * accept = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width / 6 - 5, 10, frame.size.width / 3, 30)];
            [accept addTarget:self action:@selector(acceptBet:) forControlEvents:UIControlEventTouchUpInside];
            accept.backgroundColor = Bgreen;
            [accept setTitle:@"Accept" forState:UIControlStateNormal];
            [accept setTintColor:[UIColor whiteColor]];
            accept.titleLabel.font = FregfS;
            accept.layer.cornerRadius = 9;
            accept.clipsToBounds = YES;
            [next addSubview:accept];
            // make reject button
            UIButton * reject = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width / 2 + 5, 10, frame.size.width / 3, 29)];
            [reject addTarget:self action:@selector(rejectBet:) forControlEvents:UIControlEventTouchUpInside];
            [reject setTitle:@"Reject" forState:UIControlStateNormal];
            reject.backgroundColor  = Bred;
            reject.tintColor        = [UIColor whiteColor];
            reject.titleLabel.font  = [UIFont fontWithName:@"ProximaNova-Regular" size:(fontSize-1)];
            reject.layer.cornerRadius = 9;
            reject.clipsToBounds    = YES;
            [next addSubview:reject];

            [self addSubview:next];
        } else {
            HeadingBarView * opponentsHeader = [[HeadingBarView alloc] initWithFrame:CGRectMake(0, imgF.origin.y + imgF.size.height + 10, frame.size.width, fontS*1.8) AndTitle:@"Opponents"];
            [self addSubview:opponentsHeader];
            
            yOff = opponentsHeader.frame.origin.y + opponentsHeader.frame.size.height + 10;
            int diameter = frame.size.width/4.3;
            
            next = [[UIScrollView alloc] initWithFrame:CGRectMake(15, yOff , frame.size.width -30, diameter + 5)];
            next = [self makeOpponentsScrollViewFromDiameter:diameter AndScrollView:next];
            [self addSubview:next];
        }
        
/* -----COMMENTS SECTION----- */
        HeadingBarView * commentsHeader = [[HeadingBarView alloc] initWithFrame:CGRectMake(0, next.frame.size.height + next.frame.origin.y + 7, frame.size.width, fontS*1.8) AndTitle:@"Comments"];
        
        self.comments = [[UIView alloc] initWithFrame:CGRectMake(0, commentsHeader.frame.origin.y + commentsHeader.frame.size.height, frame.size.width, 0)];
        [self setupComments:bet];
        
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
        
        [self addSubview:commentsHeader];
        [self addSubview:comments];
        
        // determine contentSize
        self.contentSize = CGSizeMake(frame.size.width, comments.frame.origin.y + comments.frame.size.height);
    }
    return self;
}

// Helpers! yay!
-(UIScrollView *) makeOpponentsScrollViewFromDiameter:(int)diameter AndScrollView:(UIScrollView *)oppScroll {
    NSArray * acceptedOpponents = [[bet valueForKey:@"opponents"] valueForKey:@"accepted"];
    NSArray * otherOpponents = [[bet valueForKey:@"opponents"] valueForKey:@"others"];
    
    for (int i = 0; i < acceptedOpponents.count; i++) {
        CGRect profF  = CGRectMake((diameter+2)*i, 1, diameter, diameter);
        UIView *profPic = [self getFBPic:[acceptedOpponents objectAtIndex:i] WithDiameter:diameter AndFrame:profF];
        profPic.layer.borderColor = [Blight CGColor];
        profPic.layer.borderWidth = 2;
        profPic.layer.masksToBounds = YES;
        [oppScroll addSubview:profPic];
    }
    for (int i = 0; i < otherOpponents.count; i++) {
        CGRect profF  = CGRectMake((diameter+2)*i + (acceptedOpponents.count *(diameter+2)), 1, diameter, diameter);
        [self getFBPic:[otherOpponents objectAtIndex:i] AndSetupWithBlock:^(UIImage *img) {
            UIImageView *profPic = [[UIImageView alloc] initWithImage:[self convertImageToGrayScale:img]];
            profPic.layer.cornerRadius = diameter / 2;
            profPic.frame = profF;
            profPic.layer.borderColor = [Blight CGColor];
            profPic.layer.borderWidth = 2;
            profPic.layer.masksToBounds = YES;
            [oppScroll addSubview:profPic];
        }];
        
    }
    
    oppScroll.contentSize = CGSizeMake((acceptedOpponents.count+otherOpponents.count) * (diameter + 4), oppScroll.frame.size.height);
    
    return oppScroll;
}

-(void)getFBPic:(NSString *)userId AndSetupWithBlock:(void (^)(UIImage *))block {
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSString *path = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture", userId];
        NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:path]];
        if ( imageData == nil )
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            block([UIImage imageWithData: imageData]);
        });
    });
}
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

-(int)getDaysInFromBet:(NSDictionary *)b {
    [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *start = [dateFormatter dateFromString: [[b valueForKey:@"created_at"] substringWithRange:NSMakeRange(0, 10)]];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:start
                                                          toDate:[NSDate date]
                                                         options:0];
    return components.day;
    
}

-(int)getDaysToGoFromBet:(NSDictionary *)b {
    [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *start = [dateFormatter dateFromString: [[b valueForKey:@"created_at"] substringWithRange:NSMakeRange(0, 10)]];
    
    NSDateComponents *components = [NSDateComponents new];
    components.day = [[b valueForKey:@"duration"] integerValue];
    NSDate *end = [[NSCalendar currentCalendar]dateByAddingComponents:components
                                                               toDate:start
                                                              options:0];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    components = [gregorianCalendar components:NSDayCalendarUnit fromDate:[NSDate date] toDate:end options:0];
    
    return components.day;
}
-(NSString *)getProgressTextFromBet:(NSDictionary *)b {
    NSString *n = [[b valueForKey:@"noun"] lowercaseString];
    NSString * two; NSString * three; NSString * four; NSString * five;
    
    //default
    three = [NSString stringWithFormat:@"%i",(int)roundf([[bet valueForKey:@"progress"] floatValue] / 100.0 * [[b valueForKey:@"amount"] intValue])];
    four  = [b valueForKey:@"amount"];
    five  = n;
    
    if ([n isEqualToString:@"smoking"]) {
        two   = @"not smoked";
        three = [NSString stringWithFormat:@"%.0f",([[b valueForKey:@"progress"] floatValue] / 100.0 * [[b valueForKey:@"duration"] integerValue])];
        four  = [b valueForKey:@"duration"];
        five  = @"days";
    } else if ( [n isEqualToString:@"pounds"] ) {
        two   = @"lost";
    } else if ( [n isEqualToString:@"miles"] ) {
        two   = @"run";
    } else if ( [n isEqualToString:@"times"] ) {
        two   = @"worked out";
    } else {
        two   = [NSString stringWithFormat:@"%@ed", [b valueForKey:@"verb"]];
        five  = [b valueForKey:@"noun"];
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

- (UIImage *)convertImageToGrayScale:(UIImage *)image {
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // Grayscale color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Create bitmap content with current image size and grayscale colorspace
    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    
    // Draw image into current context, with specified rectangle
    // using previously defined context (with grayscale colorspace)
    CGContextDrawImage(context, imageRect, [image CGImage]);
    
    // Create bitmap image info from pixel data in current context
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    // Create a new UIImage object
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    // Release colorspace, context and bitmap information
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageRef);
    
    // Return the new grayscale image
    return newImage;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.update.box resignFirstResponder];
    CGRect vf = [UIScreen mainScreen].applicationFrame;
    self.frame = CGRectMake(0, vf.origin.y - 20, self.frame.size.width, self.frame.size.height );
    [self.commentBox resignFirstResponder];
}

-(void) setupComments:(NSDictionary *)b {
    int fontSize = 14;
    int commentHt = fontSize * 5;
    int diameter = commentHt - 8;
    
    [comments removeFromSuperview];
    comments = [[UIView alloc] initWithFrame:CGRectMake(0, comments.frame.origin.y, comments.frame.size.width, 0)];
    
    NSString *path = [NSString stringWithFormat:@"bets/%@/comments", [b valueForKey:@"id"]];
    [[API sharedInstance] get:path withParams:nil onCompletion:^(NSDictionary *json) {
        if (((NSArray *)json).count == 0) {
            // none notice
        } else {
            UISwipeWithTag *recognizer;
            for (int i = 0; i < ((NSArray *)json).count; i++) {
                // setup delete guesture swipe right recognizer
                recognizer = [[UISwipeWithTag alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
                [recognizer setDirection:UISwipeGestureRecognizerDirectionRight];
                recognizer.tag = [[[((NSArray *)json) objectAtIndex:i] valueForKey:@"id"] integerValue];
                UIView *recogView = [[UIView alloc] initWithFrame:CGRectMake(0, i*commentHt, comments.frame.size.width, commentHt)];
                [recogView addGestureRecognizer:recognizer];
                
                // setup circle face
                CGRect profF  = CGRectMake(5, i*commentHt, diameter, diameter);
                NSString *usr = [[((NSArray *)json) objectAtIndex:i] valueForKey:@"user_fb_id"];
                UIView *profPic = [self getFBPic:usr WithDiameter:diameter AndFrame:profF];
                profPic.layer.borderColor = [Blight CGColor];
                profPic.layer.borderWidth = 2;
                profPic.layer.masksToBounds = YES;
                // setup name
                [FBRequestConnection startWithGraphPath:usr completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                    if (!error) {
                        UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(commentHt + 9, i*commentHt + 6, comments.frame.size.width - (commentHt + 15), fontSize)];
                        nameLbl.text = [result valueForKey:@"name"];
                        nameLbl.font = FblackfS;
                        nameLbl.textColor = Bdark;
                        
                        [comments addSubview:nameLbl];
                    } else {
                        // An error occurred, we need to handle the error
                        // See: https://developers.facebook.com/docs/ios/errors
                    }
                }];
                
                // setup text
                NSString *cT = [[((NSArray *)json) objectAtIndex:i] valueForKey:@"text"];
                UILabel *text;
                if (cT.length > 33) {
                    text = [[UILabel alloc] initWithFrame:CGRectMake(commentHt + 9, i*commentHt + 12, comments.frame.size.width - (commentHt + 15), commentHt)];
                } else {
                    text = [[UILabel alloc] initWithFrame:CGRectMake(commentHt + 9, i*commentHt , comments.frame.size.width - (commentHt + 15), commentHt)];
                }
                text.text = cT;
                text.font = FregfS;
                text.textColor = Bmid;
                text.numberOfLines = 0;
                text.lineBreakMode = NSLineBreakByWordWrapping;
                
                [comments addSubview:profPic];
                [comments addSubview:text];
                [comments addSubview:recogView];
            }
        }
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, commentHt*((NSArray *)json).count, comments.frame.size.width, 2)];
        line.backgroundColor = Bmid;
        [comments addSubview:line];
        
        // add the submit comment bit
        self.commentBox = [[UITextField alloc] initWithFrame:CGRectMake(commentHt + 9, commentHt*((NSArray *)json).count + ((commentHt - (fontSize*1.9))/2), comments.frame.size.width - (commentHt + 18), fontSize * 1.9)];
        commentBox.layer.borderColor = Bmid.CGColor;
        commentBox.layer.borderWidth = 2;
        commentBox.textColor = Bmid;
        commentBox.text = @"Add a comment";
        commentBox.font = FregfS;
        commentBox.delegate = self;
        commentBox.keyboardType = UIKeyboardTypeAlphabet;
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
        commentBox.leftView = paddingView;
        commentBox.leftViewMode = UITextFieldViewModeAlways;
        [comments addSubview:commentBox];
        
        comments.frame = CGRectMake(0, comments.frame.origin.y, comments.frame.size.width, commentHt*(((NSArray *)json).count+1));
        comments.clipsToBounds = NO;
        comments.layer.masksToBounds = NO;
        
        UIImageView *chatImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat-20.png"]];
        chatImg.frame = CGRectMake(12, comments.frame.size.height - (commentHt-15), commentHt-24, commentHt-30);
        chatImg.image = [chatImg.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        chatImg.tintColor = Bmid;          // graphic is always gray (light)
        [comments addSubview:chatImg];
        
        [self addSubview:comments];
        self.contentSize = CGSizeMake(self.frame.size.width, comments.frame.origin.y + comments.frame.size.height);
    }];
}

// API call stuff
-(void)acceptBet:(UIButton *)sender {
    // May return nil if a tracker has not already been initialized with a property
    // ID.
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"       // Event category (required)
                                                          action:@"button_press"    // Event action (required)
                                                           label:@"Accept Bet"      // Event label
                                                           value:nil] build]];      // Event value
    
    // this method does the following, in order:
    //  1. asks for Credit Card info via BTLibrary
    //  2. tells the server the info, which makes, but does not submit the transaction
    //  3. tells the server that the bet is accepted
    //  4. UIAlerts the user that the process is done
    
    /* Do #1 */
    
    NSString *path = [NSString stringWithFormat:@"card/%@", ((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId];
    [[API sharedInstance] get:path withParams:nil onCompletion:^(NSDictionary *json) {
        if ([[json valueForKey:@"msg"] isEqualToString:@"no card found, man"]) {
            // tell the user wtf is going on
            [[[UIAlertView alloc] initWithTitle:@"We Need Something"
                                        message:@"We're gonna need a valid credit card for you to do that. Don't worry, we won't charge it until the bet is over--and even then only if you lost."
                                       delegate:nil
                              cancelButtonTitle:@"Fair Enough"
                              otherButtonTitles:nil]
             show];
            
            
            // showing BrainTree's CreditCard processing page
            BTPaymentViewController *paymentViewController = [BTPaymentViewController paymentViewControllerWithVenmoTouchEnabled:NO];
            CGRect f = CGRectMake(0, -63, self.frame.size.width, 90);
            BetterBraintreeView *sub = [[BetterBraintreeView alloc] initWithFrame:f];
            [paymentViewController.view addSubview:sub];
            [paymentViewController.tableView setContentInset:UIEdgeInsetsMake(78,0,0,0)];
            // setup it's delegate
            TempBet * b = [TempBet new];
            [BraintreeDelegateController sharedInstance].del = self;
            b.stakeAmount = [bet valueForKey:@"stakeAmount"];
            [BraintreeDelegateController sharedInstance].bet = b;
            [BraintreeDelegateController sharedInstance].ident = [bet valueForKey:@"id"];
            [BraintreeDelegateController sharedInstance].email = sub.email;
            paymentViewController.delegate = [BraintreeDelegateController sharedInstance];
            // Now, display the navigation controller that contains the payment form
            [((AppDelegate *)([[UIApplication sharedApplication] delegate])).navController pushViewController:paymentViewController animated:YES];
        } else {
            //skip asking for the card.
            [self tellServerOfAcceptedBet];
        }
    }];
    
    /* Do #2-4 */
    // is done within the delegate methods below. line 370 sets this up ^^
}

-(void)tellServerOfAcceptedBet {
    /* Do #3 */
    AppDelegate * app = ((AppDelegate *)([[UIApplication sharedApplication] delegate]));
    NSString *path =[NSString stringWithFormat:@"invites/%@", [bet valueForKey:@"invite"]];
    NSMutableDictionary* params =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  @"accepted", @"status",
                                  app.ownName, @"name",
                                  nil];
    //make the call to the web API
    // PUT /invites/:id => {status: "accepted"}
    [[API sharedInstance] put:path withParams:params onCompletion:^(NSDictionary *json) {
        /* Do #4 */
        [app.navController popToRootViewControllerAnimated:YES];
    }];
    
    // tell them what's going on
    [[[UIAlertView alloc] initWithTitle:@""
                                message:@"You have accepted your friend's bet. Your card will be charged if you lose the bet."
                               delegate:nil
                      cancelButtonTitle:@"OK!"
                      otherButtonTitles:nil]
     show];
}

-(void)rejectBet:(UIButton *)sender {
    // May return nil if a tracker has not already been initialized with a property
    // ID.
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"       // Event category (required)
                                                          action:@"button_press"    // Event action (required)
                                                           label:@"Reject Bet"      // Event label
                                                           value:nil] build]];      // Event value
    
    AppDelegate * app = ((AppDelegate *)([[UIApplication sharedApplication] delegate]));
    // this method does the following, in order:
    //  1. tells the server that the invite has been rejected
    NSString *path =[NSString stringWithFormat:@"invites/%@", [bet valueForKey:@"invite"]];
    NSMutableDictionary* params =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  @"rejected", @"status",
                                  app.ownName, @"name",
                                  nil];
    //make the call to the web API
    // PUT /invites/:id => {status: "rejected"}
    [[API sharedInstance] put:path withParams:params onCompletion:^(NSDictionary *json) {
        /* Do #4 */
        // Show the result in an alert
        [[[UIAlertView alloc] initWithTitle:@"Lame..."
                                    message:@"You have rejected your friend's bet. That's not very sportsman-like."
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil]
         show];
        [app.navController popToRootViewControllerAnimated:YES];
    }];
}

#pragma mark UITextFieldDelegate methods
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    if ([textField.text isEqualToString:@""]) { return NO; }
    // send the message to the server
    NSString * ownId = ((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [bet valueForKey:@"id"], @"bet_id",
                                   textField.text, @"text",
                                   ownId, @"user_id",
                                   nil];
    [[API sharedInstance] post:@"comments" withParams:params onCompletion:^(NSDictionary *json) {
        // we sent the message, yay!
        [self performSelector:@selector(setupComments:) withObject:self.bet afterDelay:1];
    }];
    
    CGRect vf = [UIScreen mainScreen].applicationFrame;
    self.frame = CGRectMake(0, vf.origin.y + 20, self.frame.size.width, self.frame.size.height );
    [textField resignFirstResponder];
    textField.text = @"";
    return NO;
}
- (void) textFieldDidBeginEditing:(UITextField *)textField {
    textField.text = @"";
    CGRect vf = [UIScreen mainScreen].applicationFrame;
    if (self.frame.size.height > 500 && self.frame.size.width < 500) {          // big iphone
        self.frame = CGRectMake(0, self.frame.origin.y -((vf.size.height-112)/2), self.frame.size.width, self.frame.size.height );
    } else if (self.frame.size.height > 500 && self.frame.size.width > 500) {   // ipad
        self.frame = CGRectMake(0, self.frame.origin.y -((vf.size.height-220)/3), self.frame.size.width, self.frame.size.height );
    } else {                                                                    // small iphone
        self.frame = CGRectMake(0, self.frame.origin.y -((vf.size.height-44)/2), self.frame.size.width, self.frame.size.height );
    }
}

#pragma mark - UIAlertViewDelegate methods
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView.title isEqualToString:@"Credit Card"]) {
        if ([alertView.message isEqualToString:@"Card is approved"]) {
            // Then dismiss the paymentViewController
            // the loading thing is removed before the alert comes up
            [self tellServerOfAcceptedBet];
        } else {
            // the card was bad, so do nothing
        }
    } else {
        if (buttonIndex == 1) {
            [self sendDeleteForComment:alertView.tag];
        }
    }
}

// comment deletion helpers //
/// handles the swipe right for deleteing a comment
-(void) handleSwipeFrom:(UISwipeWithTag *)r {
    UIAlertView *a =[[UIAlertView alloc] initWithTitle:@"Delete Comment" message:@"Sure you want to delete this comment?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    a.tag = r.tag;
    [a show];
}
/// sends a delete request to the server for the given comment id
-(void) sendDeleteForComment:(int) i {
    NSString *path = [NSString stringWithFormat:@"comments/%i", i];
    [[API sharedInstance] deletePath:path withParams:nil onCompletion:^(NSDictionary *json) {
        if ([[json valueForKey:@"msg"] isEqualToString:@"you can't see this"]) {
            // the user tried to delete someone else's comment. Dumbass.
            [[[UIAlertView alloc] initWithTitle:@"Delete Comment" message:@"That comment isn't yours." delegate:nil cancelButtonTitle:@"Oh." otherButtonTitles: nil] show];
        } else {
            // the deletion was successful.
            [self setupComments:bet];
        }
    }];
}

@end
