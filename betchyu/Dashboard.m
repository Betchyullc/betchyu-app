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
@synthesize friends;

@synthesize oneH;
@synthesize rowH;
@synthesize pendingRowH;

//@synthesize controller;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //self.controller = cont;
        oneH = 120;
        rowH = 70;
        pendingRowH = 90;
        if (frame.size.width > 700) {
            oneH = 140;
            rowH = 110;
            pendingRowH = 120;
        }
        self.backgroundColor = [UIColor whiteColor];
        
        // Sire, we must have the frames made, one for each portion of the page!
        int headHt = MAX((frame.size.height/7), 74);
        CGRect headRect    = CGRectMake(frame.origin.x, 0, frame.size.width, headHt); // bad, should be dynamic height
        CGRect pendingRect = CGRectMake(frame.origin.x, headHt, frame.size.width, oneH); // also bad
        CGRect myRect = CGRectMake(frame.origin.x, pendingRect.origin.y + pendingRect.size.height, frame.size.width, oneH); // bad, should be dynamic height
        CGRect friendRect  = CGRectMake(frame.origin.x, myRect.origin.y + myRect.size.height, frame.size.width, oneH); // also bad
        
        // Sir Mallory, I hereby charge you with the instantiation of said view-portions.
        self.head    = [[DashHeaderView alloc] initWithFrame:headRect];
        self.pending = [[PendingBetsView alloc] initWithFrame:pendingRect];
        self.my = [[MyBetsView alloc] initWithFrame:myRect];
        self.friends  = [[FriendsBetsSubview alloc] initWithFrame:friendRect];
        
        // Sire, it has been done as you requested. *bows* May I now add these views to our self-same kingdom? (kingdom = view)
        // Let it be so.
        [self addSubview:head];
        [self addSubview:pending];
        [self addSubview:my];
        [self addSubview:friends];
        self.contentSize = CGSizeMake(frame.size.width, headHt+pendingRect.size.height+myRect.size.height);
    }
    return self;
}

-(void)adjustPendingHeight:(int)numItems {
    CGRect f = self.pending.frame;
    [self.pending removeFromSuperview];
    if (numItems <= 1) {
        self.pending = [[PendingBetsView alloc] initWithFrame:CGRectMake(f.origin.x, f.origin.y, f.size.width, oneH)];
        [self.my setFrame:CGRectMake(my.frame.origin.x, my.frame.origin.y - (f.size.height - oneH), my.frame.size.width, my.frame.size.height)];
        [self.friends setFrame:CGRectMake(friends.frame.origin.x, friends.frame.origin.y - (f.size.height - oneH), friends.frame.size.width, friends.frame.size.height)];
    } else {
        int new = rowH*numItems + oneH - rowH;
        self.pending = [[PendingBetsView alloc] initWithFrame:CGRectMake(f.origin.x, f.origin.y, f.size.width, new)];
        [self.my setFrame:CGRectMake(my.frame.origin.x, my.frame.origin.y - (f.size.height - new), my.frame.size.width, my.frame.size.height)];
        [self.friends setFrame:CGRectMake(friends.frame.origin.x, friends.frame.origin.y - (f.size.height - new), friends.frame.size.width, friends.frame.size.height)];
    }
    self.contentSize = CGSizeMake(f.size.width, head.frame.size.height+pending.frame.size.height+my.frame.size.height + friends.frame.size.height);
    [self addSubview:pending];
}
-(void)adjustMyBetsHeight:(int)numItems {
    CGRect f = self.my.frame;
    if (numItems <= 1) {
        [self.my setFrame:CGRectMake(f.origin.x, f.origin.y, f.size.width, oneH)];
        [self.friends setFrame:CGRectMake(friends.frame.origin.x, friends.frame.origin.y - (f.size.height - oneH), friends.frame.size.width, friends.frame.size.height)];
    } else {
        int new = rowH*numItems + oneH - rowH;
        [self.my setFrame:CGRectMake(f.origin.x, f.origin.y, f.size.width, new)];
        [self.friends setFrame:CGRectMake(friends.frame.origin.x, friends.frame.origin.y - (f.size.height - new), friends.frame.size.width, friends.frame.size.height)];
    }
    self.contentSize = CGSizeMake(f.size.width, head.frame.size.height+pending.frame.size.height+my.frame.size.height + friends.frame.size.height);
}

-(void)adjustFriendsBetsHeight:(int)numItems {
    CGRect f = self.friends.frame;
    if (numItems <= 1) {
        [self.friends setFrame:CGRectMake(f.origin.x, f.origin.y, f.size.width, oneH)];
    } else {
        int new = rowH*numItems + oneH - rowH;
        [self.friends setFrame:CGRectMake(f.origin.x, f.origin.y, f.size.width, new)];
    }
    self.contentSize = CGSizeMake(f.size.width, head.frame.size.height+pending.frame.size.height+my.frame.size.height + friends.frame.size.height);
}

@end
