//
//  Bet.h
//  iBetchyu
//
//  Created by Betchyu Computer on 11/24/13.
//  Copyright (c) 2013 Betchyu Computer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Bet : NSManagedObject

@property (nonatomic, retain) NSNumber * betAmount;
@property (nonatomic, retain) NSString * betNoun;
@property (nonatomic, retain) NSString * betVerb;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSNumber * opponentStakeAmount;
@property (nonatomic, retain) NSString * opponentStakeType;
@property (nonatomic, retain) NSNumber * ownStakeAmount;
@property (nonatomic, retain) NSString * ownStakeType;
@property (nonatomic, retain) NSString *owner;
@property (nonatomic, retain) NSString *opponent;
@property NSSet * invites;

@end
