//
//  ProgressTrackingVC.m
//  betchyu
//
//  Created by Adam Baratz on 6/13/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import "ProgressTrackingVC.h"
#import "AppDelegate.h"

@interface ProgressTrackingVC ()

@end

@implementation ProgressTrackingVC

@synthesize bet;
@synthesize prog;

- (id)initWithBet:(NSDictionary *)betObj {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        self.bet = betObj;
    }
    return self;
}

-(void) loadView {
    UIView *v = [UIView new];
    v.frame = [UIScreen mainScreen].applicationFrame;
    v.backgroundColor = Blight;
    
    int w = v.frame.size.width;
    int yOff = v.frame.origin.y + 44;
    
    self.prog = [[BinaryProgressView alloc] initWithFrame:CGRectMake(0, yOff, w, 200) AndBetId:[[bet valueForKey:@"id"] intValue]];
    prog.delegate = self;
    [v addSubview:prog];
    
    self.view = v;
}

// when this is called, it means they lost the bet
- (void)updated:(NSDictionary *)params {
    NSMutableDictionary * params2 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                    ((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId, @"user",
                                     [params valueForKey:@"bet_id"], @"bet_id",
                                     @"f", @"win",
                                    nil];
    [[API sharedInstance] put:@"/pay" withParams:params2 onCompletion:^(NSDictionary *json) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    
}

@end
