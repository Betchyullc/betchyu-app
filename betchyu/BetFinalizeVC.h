//
//  BetFinalizeVC.h
//  iBetchyu
//
//  Created by Betchyu Computer on 11/25/13.
//  Copyright (c) 2013 Betchyu Computer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "TempBet.h"
#import "BigButton.h"

@interface BetFinalizeVC : UIViewController 

@property (strong) TempBet * bet;
@property NSManagedObjectContext * managedObjectContext;

-(id)initWithBet:(TempBet *)betObj;
-(void)betchyu:(id)sender;

@end
