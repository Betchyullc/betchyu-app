//
//  Dashboard.m
//  betchyu
//
//  Created by Adam Baratz on 6/2/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import "Dashboard.h"

@implementation Dashboard

@synthesize head;
@synthesize pending;
@synthesize my;

@synthesize oneH;
@synthesize twoH;

//@synthesize controller;

- (id)initWithFrame:(CGRect)frame //AndController:(DashboardVC *)cont
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //self.controller = cont;
        oneH = 120;
        twoH = 220;
        if (frame.size.width > 700) {
            oneH = 140;
            twoH = 280;
        }
        
        // Sire, we must have the frames made, one for each portion of the page!
        int headHt = MAX((frame.size.height/7), 74);
        CGRect headRect    = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, headHt); // bad, should be dynamic height
        CGRect pendingRect = CGRectMake(frame.origin.x, frame.origin.y + headHt, frame.size.width, twoH); // also bad
        CGRect myRect = CGRectMake(frame.origin.x, pendingRect.origin.y + pendingRect.size.height, frame.size.width, twoH); // bad, should be dynamic height
        CGRect friendRect  = CGRectMake(frame.origin.x, frame.origin.y + 800, frame.size.width, 400); // also bad
        
        // Sir Mallory, I hereby charge you with the instantiation of said view-portions.
        self.head    = [[DashHeaderView alloc] initWithFrame:headRect];
        self.pending = [[PendingBetsView alloc] initWithFrame:pendingRect]; //AndController:cont];
        self.my = [[MyBetsView alloc] initWithFrame:myRect];
        /*DashHeaderView *friend  = [[DashHeaderView alloc] initWithFrame:friendRect];*/
        
        // Sire, it has been done as you requested. *bows* May I now add these views to our self-same kingdom? (kingdom = view)
        // Let it be so.
        [self addSubview:head];
        [self addSubview:pending];
        [self addSubview:my];
        /*[self addSubview:friend];*/
    }
    return self;
}

-(void)adjustPendingHeight:(int)numItems {
    CGRect f = self.pending.frame;
    if (numItems <= 1) {
        [self.pending setFrame:CGRectMake(f.origin.x, f.origin.y, f.size.width, oneH)];
        [self.my setFrame:CGRectMake(my.frame.origin.x, my.frame.origin.y - (f.size.height - oneH), my.frame.size.width, my.frame.size.height)];
        //[self.friend setFrame:CGRectMake(pending.frame.origin.x, pending.frame.origin.y, pending.frame.size.width, 100)];
    } else {
        [self.pending setFrame:CGRectMake(f.origin.x, f.origin.y, f.size.width, twoH)];
        [self.my setFrame:CGRectMake(my.frame.origin.x, my.frame.origin.y - (f.size.height - twoH), my.frame.size.width, my.frame.size.height)];
        //[self.friend setFrame:CGRectMake(pending.frame.origin.x, pending.frame.origin.y, pending.frame.size.width, 100)];
    }
}
-(void)adjustMyBetsHeight:(int)numItems {
    CGRect f = self.my.frame;
    if (numItems <= 1) {
        [self.my setFrame:CGRectMake(f.origin.x, f.origin.y, f.size.width, oneH)];
        //[self.friend setFrame:CGRectMake(my.frame.origin.x, my.frame.origin.y - (f.size.height - 100), my.frame.size.width, my.frame.size.height)];
    } else {
        [self.my setFrame:CGRectMake(f.origin.x, f.origin.y, f.size.width, twoH)];
        self.my.scroller.contentSize = CGSizeMake(f.size.width, oneH*numItems);
        //[self.friend setFrame:CGRectMake(my.frame.origin.x, my.frame.origin.y - (f.size.height - 220), my.frame.size.width, my.frame.size.height)];
    }
}

@end
