//
//  TempBet.h
//  iBetchyu
//
//  Created by Betchyu Computer on 11/24/13.
//  Copyright (c) 2013 Betchyu Computer. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Borange [UIColor colorWithRed:243.0/255 green:(116.0/255.0) blue:(67/255.0) alpha:1.0]
#define Bgreen  [UIColor colorWithRed:173.0/255 green:196.0/255 blue:81.0/255 alpha:1.0]
#define Bred    [UIColor colorWithRed:219.0/255 green:70.0/255 blue:38.0/255 alpha:1.0]
#define Bblue   [UIColor colorWithRed:83.0/255 green:188.0/255 blue:183.0/255 alpha:1.0]
#define Bdark   [UIColor colorWithRed:71.0/255 green:71.0/255 blue:82.0/255 alpha:1.0]
#define Blight  [UIColor colorWithRed:213.0/255 green:213.0/255 blue:214.0/255 alpha:1.0]
#define Bmid    [UIColor colorWithRed:186.0/255 green:186.0/255 blue:194.0/255 alpha:1.0]

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
