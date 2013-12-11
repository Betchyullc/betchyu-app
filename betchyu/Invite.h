//
//  Invite.h
//  betchyu
//
//  Created by Adam Baratz on 12/10/13.
//  Copyright (c) 2013 BetchyuLLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Bet.h"

@interface Invite : NSManagedObject

@property (nonatomic, retain) NSString * invitee;
@property (nonatomic, retain) NSString * inviter;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) Bet * bet;

@end
