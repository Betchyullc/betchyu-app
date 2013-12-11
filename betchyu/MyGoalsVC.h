//
//  MyGoalsVC.h
//  betchyu
//
//  Created by Adam Baratz on 12/10/13.
//  Copyright (c) 2013 BetchyuLLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyGoalsVC : UIViewController

@property NSArray * bets;
@property NSString * ownerId;
@property NSManagedObjectContext * moc;

-(id)initWithGoals:(NSArray *)goalsList;

@end
