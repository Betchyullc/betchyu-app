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
-(void) pickAndShowCorrectUpdatedAlertFrom:(NSDictionary *)bet {
    int duration = [[bet valueForKey:@"duration"] intValue];
    [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *start = [dateFormatter dateFromString: [[bet valueForKey:@"created_at"] substringWithRange:NSMakeRange(0, 10)]];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:start
                                                          toDate:[NSDate date]
                                                         options:0];

    // if time-wise, the bet is half over
    if (components.day >= duration/2) {
        if ([[bet valueForKey:@"progress"] integerValue] > 50) {
            [self showAlmostDoneAlert];
        } else {
            [self showFallingBehindAlert];
        }
    } else {
        [self showGoalUpdatedAlert];
    }
}

-(void) showGoalUpdatedAlert {
    [self showRandomAlertFromList:@[@"Solid job! You are on the right track. Now keep it up now.",
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
                                    @"Nice."]];
}
-(void) showAlmostDoneAlert {
    [self showRandomAlertFromList:@[@"Victory is going to taste real nice.",
                                    @"Final sprint! Let’s make it happen.",
                                    @"You’re almost there. Don’t stop now.",
                                    @"Yahoo! You just have a little more to go.",
                                    @"You’ve come this far, no kidding around now."]];
}
-(void) showFallingBehindAlert {
    [self showRandomAlertFromList:@[@"Good progress. But you’ve got to step it up to make sure you are on track to winning.",
                                    @"You’re a bit behind where you need to be at this time. Time to up the ante!",
                                    @"Just a bit more effort and you’re back on track. Let’s make this happen!",
                                    @"It’s time to show your game-face. You are a bit behind. Let’s step it up!",
                                    @"Do you want your friend to win the bet?!? We don’t either. Let’s catch up now!"]];
}
-(void) showRandomAlertFromList:(NSArray *)list {
    [[[UIAlertView alloc] initWithTitle:nil message:[self pickRandomStringFromList:list] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}
-(NSString *) pickRandomStringFromList:(NSArray *)list {
    int rand = arc4random() % (list.count-1);
    return [list objectAtIndex:rand];
}

#pragma mark - Notifications
-(void) cancelOldAndScheduleNewNotification {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [self scheduleNewNotification];
}
-(void) scheduleNewNotification {
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    localNotif.fireDate = [[NSDate date] dateByAddingTimeInterval:(3*24*60*60)];
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
    localNotif.alertBody = [self pickRandomStringFromList:@[@"We miss you at Betchyu! Update your goal let your friends know what’s up.",
                                                            @"Let your friends know how things are coming along. Make sure to update your progress.",
                                                            @"Hope you are making good progress on your goal. Keep your friends in the loop by updating."]];
    localNotif.alertAction = NSLocalizedString(@"View Details", nil);
    
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 1;
    
    /*NSDictionary *infoDict = [NSDictionary dictionaryWithObject:item.eventName forKey:ToDoItemKey];
    localNotif.userInfo = infoDict;*/
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
}

@end
