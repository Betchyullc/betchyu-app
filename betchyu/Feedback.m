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
        
        int fontSize = 17;
        if (frame.size.width > 500) {
            fontSize = 22;
        }
        
        self.backgroundColor = [UIColor whiteColor];
        
        /// ui label containing the copy text
        UILabel *copy = [[UILabel alloc] initWithFrame:CGRectMake(30, 35, frame.size.width-60, frame.size.height/2)];
        copy.font = FregfS;
        copy.text = @"Thanks for using Betchyu! We're very interested in what you have to say. Send us comments at info@betchyu.com.";
        copy.numberOfLines = 0;
        copy.textAlignment = NSTextAlignmentLeft;
        copy.textColor = Bdark;
        [self addSubview:copy];        
    }
    return self;
}

@end

