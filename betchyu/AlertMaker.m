//  AlertMaker.m
//  betchyu
//
//  Created by Daniel Zapata on 6/24/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.

#import "AlertMaker.h"

@implementation AlertMaker

#pragma mark - Singleton methods
/**
 * Singleton methods
 */
+(AlertMaker *)sharedInstance
{
    static AlertMaker *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - Instance methods
-(void) showGoalUpdatedAlert {
    NSArray * standardText = @[@"Solid job! You are on the right track. Now keep it up now.",
                               @"Great pace! Keep up the great work.",
                               @"Looking good! You’re killing it.",
                               @"There is no turning back now, you’re on your way.",
                               @"Hot Damn! Don’t stop now.",
                               @"And they thought you didn’t have it in you. Great job.",
                               @"Remember that guy who gave up? Neither does anybody else. Keep it up!",
                               @"Fantastic job. Stay strong now.",
                               @"You earned an inspirational quote:\n“Do or do not, there is no try.”\n--Yoda",
                               @"You earned an inspirational quote:\n“You miss 100% of the shots you don’t take”\n--Wayne Gretzky",
                               @"You earned an inspirational quote:\n“The only person you are destined to become is the person you decide to be.”\n--Ralph Waldo Emerson",
                               @"You earned an inspirational quote:\n“Believe you can and you’re halfway there.”\n--Theadore Roosavelt.",
                               @"You earned an inspirational quote:\n“You can’t fall if you don’t climb. But there is no joy in living your whole life on the ground.”",
                               @"You earned an inspirational quote:\n“Dream big and dare to fail.”\n--Norman Vaughan.",
                               @"You earned an inspirational quote:\n“It’s not the years in your life that count. It’s the life in your years.”\n--Abraham Lincoln",
                               @"You earned an inspirational quote:\n“If you can dream it, you can achieve it.”\n--Zig Ziglar.",
                               @"Nice."];
    int rand = arc4random() % (standardText.count-1) + 0;
    [[[UIAlertView alloc] initWithTitle:nil message:[standardText objectAtIndex:rand] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

@end
