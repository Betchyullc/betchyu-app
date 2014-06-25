//  AboutUs.m
//  betchyu
//
//  Created by Daniel Zapata on 12/22/13.
//  Copyright (c) 2013 BetchyuLLC. All rights reserved.

#import "AboutUs.h"

@implementation AboutUs

@synthesize owner;

- (id)initWithFrame:(CGRect)frame AndOwner:(UIViewController *)passedOwner {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.owner = passedOwner;
        
        int fontSize = 17;
        if (frame.size.width > 500) {
            fontSize = 22;
        }
        
        self.backgroundColor = [UIColor whiteColor];
        
        /// ui label containing said text
        UILabel *copy = [[UILabel alloc] initWithFrame:CGRectMake(30, 35, frame.size.width-60, frame.size.height/2)];
        copy.font = FregfS;
        copy.text = @"Betchyu is a startup based in Cleveland, Ohio. We’re a team of guys who started working together in August 2013. We love building awesome products that can change people’s lives. We aspire to make it easier than ever for people to attain personal goals. Still have questions? Learn more at betchyu.com.";
        copy.numberOfLines = 0;
        copy.textAlignment = NSTextAlignmentLeft;
        copy.textColor = Bdark;
        [self addSubview:copy];
        
        /// the 'like us on FaceBook' button
        UIButton *fb = [UIButton buttonWithType:UIButtonTypeCustom];
        fb.frame = CGRectMake(0, copy.frame.size.height + copy.frame.origin.y, frame.size.width, 60);
        fb.backgroundColor = [UIColor colorWithRed:59/255.0 green:89/255.0 blue:152/255.0 alpha:1.0];
        [fb setTitle:@"Like us on Facebook!" forState:UIControlStateNormal];
        fb.tintColor = [UIColor whiteColor];
        [fb addTarget:self action:@selector(fbLike:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:fb];
        UIImageView *fbImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fb-logo.png"]];
        fbImg.frame = CGRectMake(12, fb.frame.origin.y + 13, 34, 34);
        [self addSubview:fbImg];
        
        /// the 'like us on FaceBook' button
        UIButton *tw = [UIButton buttonWithType:UIButtonTypeCustom];
        tw.frame = CGRectMake(0, fb.frame.size.height + fb.frame.origin.y, frame.size.width, 60);
        tw.backgroundColor = [UIColor colorWithRed:94/255.0 green:169/255.0 blue:221/255.0 alpha:1.0];
        [tw setTitle:@"Follow us on Twitter!" forState:UIControlStateNormal];
        tw.tintColor = [UIColor whiteColor];
        [tw addTarget:self action:@selector(twitterFollow:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:tw];
        UIImageView *twImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tw-logo.png"]];
        twImg.frame = CGRectMake(12, tw.frame.origin.y + 13, 38, 34);
        [self addSubview:twImg];
    }
    return self;
}

-(void) fbLike:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/betchyu"]];
}

-(void) twitterFollow:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/Betchyu"]];
}

@end
