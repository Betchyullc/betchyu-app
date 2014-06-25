//
//  Feedback.m
//  betchyu
//
//  Created by Daniel Zapata on 2/10/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.

#import "Feedback.h"

@implementation Feedback

@synthesize owner;

- (id)initWithFrame:(CGRect)frame AndOwner:(UIViewController *)passedOwner {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.owner = passedOwner;
        int w = frame.size.width;
        
        int fontSize = 17;
        if (w > 500) {
            fontSize = 22;
        }
        
        self.backgroundColor = [UIColor whiteColor];
        
        /// ui label containing the copy text
        UILabel *copy = [[UILabel alloc] initWithFrame:CGRectMake(30, 35, w-60, frame.size.height/3)];
        copy.font = FregfS;
        copy.text = @"Thanks for using Betchyu! We're very interested in what you have to say. Send us comments at info@betchyu.com.";
        copy.numberOfLines = 0;
        copy.textAlignment = NSTextAlignmentLeft;
        copy.textColor = Bdark;
        [self addSubview:copy];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height/3, w, 2)];
        line.backgroundColor = Bmid;
        [self addSubview:line];
        
        /// UIImageview for the logo
        UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"full-logo.png"]];
        logo.frame = CGRectMake(w/4, copy.frame.size.height + 20, w/2, 45);
        logo.alpha = 0.5f;
        [self addSubview:logo];
    }
    return self;
}

@end

