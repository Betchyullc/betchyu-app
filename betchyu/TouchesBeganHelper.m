//
//  TouchesBeganHelper.m
//  betchyu
//
//  Created by Daniel Zapata on 6/30/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import "TouchesBeganHelper.h"

@implementation TouchesBeganHelper

@synthesize vc;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (vc && vc.initialInput) {
        [vc.initialInput resignFirstResponder];
    }
}

@end
