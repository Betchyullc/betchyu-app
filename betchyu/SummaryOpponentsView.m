//  SummaryOpponentsView.m
//  betchyu
//
//  Created by Daniel Zapata on 6/18/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.

#import "SummaryOpponentsView.h"

@implementation SummaryOpponentsView

- (id)initWithFrame:(CGRect)frame AndOpponents:(NSArray*)opps {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        int w = frame.size.width;
        int h = frame.size.height;
        
        int fontSize = 20;
        int imgHeight = 56;
        
        UILabel *title  = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, w, fontSize + 8)];
        title.font      = FregfS;
        title.textColor = Bmid;
        title.text      = @"Your opponents are:";
        title.textAlignment = NSTextAlignmentCenter;
        
        UIScrollView *sidewaysScroller = [[UIScrollView alloc]initWithFrame:CGRectMake(20, title.frame.size.height + title.frame.origin.y + 10, w-40, imgHeight + 5)];
        sidewaysScroller.contentSize = CGSizeMake((imgHeight+5)*opps.count, imgHeight + 5);
        for (int i = 0; i < opps.count; i++) {
            FBProfilePictureView *profPic = [[FBProfilePictureView alloc]
                                             initWithProfileID:((NSMutableDictionary<FBGraphUser> *)[opps objectAtIndex:i]).id
                                             pictureCropping:FBProfilePictureCroppingSquare];
            profPic.frame = CGRectMake((5 + imgHeight)*i , 0, imgHeight, imgHeight);
            profPic.layer.cornerRadius  = imgHeight/2;
            profPic.layer.borderColor   = Borange.CGColor;
            profPic.layer.borderWidth   = 2;
            [sidewaysScroller addSubview:profPic];
        }
        
        // Make the line inicating the end of this view
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15, h-2, w-30, 2)];
        line.backgroundColor = Bmid;
        
        [self addSubview:title];
        [self addSubview:sidewaysScroller];
        [self addSubview:line];
    }
    return self;
}

@end
