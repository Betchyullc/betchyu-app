//
//  TempBet.h
//  iBetchyu
//
//  Created by Betchyu Computer on 11/24/13.
//  Copyright (c) 2013 Betchyu Computer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TempBet : NSObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSString * noun;
@property (nonatomic, retain) NSString * verb;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSArray * friends;
@property (nonatomic, retain) NSNumber * stakeAmount;
@property (nonatomic, retain) NSString * stakeType;
@property (nonatomic, retain) NSString *owner;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSNumber *initial;

@end
