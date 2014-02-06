//
//  ViewController.h
//  iBetchyu
//
//  Created by Betchyu Computer on 11/16/13.
//  Copyright (c) 2013 Betchyu Computer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property NSString * numberOfInvites;
@property UILabel * numNotif;
@property BOOL hasShownHowItWorks;
@property BOOL canLeavePage;

- (id)initWithInviteNumber:(NSString *)numInvs;

@end
