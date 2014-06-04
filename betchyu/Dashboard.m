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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // Sire, we must have the frames made, one for each portion of the page!
        int headHt = MAX((frame.size.height/7), 74);
        CGRect headRect    = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, headHt); // bad, should be dynamic height
        CGRect pendingRect = CGRectMake(frame.origin.x, frame.origin.y + headHt, frame.size.width, 220); // also bad
        CGRect currentRect = CGRectMake(frame.origin.x, frame.origin.y + 600, frame.size.width, 200); // bad, should be dynamic height
        CGRect friendRect  = CGRectMake(frame.origin.x, frame.origin.y + 800, frame.size.width, 400); // also bad
        
        // Sir Mallory, I hereby charge you with the instantiation of said view-portions.
        DashHeaderView *head    = [[DashHeaderView alloc] initWithFrame:headRect];
        PendingBetsView *pending = [[PendingBetsView alloc] initWithFrame:pendingRect AndPendingBets:[NSArray arrayWithObjects:@{@"owner": @"1206433"}, @{@"owner":@"1253342"}, nil]];
        /*DashHeaderView *current = [[DashHeaderView alloc] initWithFrame:currentRect];
        DashHeaderView *friend  = [[DashHeaderView alloc] initWithFrame:friendRect];*/
        
        // Sire, it has been done as you requested. *bows* May I now add these views to our self-same kingdom? (kingdom = view)
        // Let it be so.
        [self addSubview:head];
        [self addSubview:pending];
        /*[self addSubview:current];
        [self addSubview:friend];*/
    }
    return self;
}

-(void) showPendingBets {
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
