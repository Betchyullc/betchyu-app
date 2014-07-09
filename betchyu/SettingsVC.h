//
//  SettingsVC.h
//  betchyu
//
//  Created by Adam Baratz on 6/11/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsView.h"
#import "HowItWorksVC.h"
#import "FrequentlyAskedQuestionsView.h"
#import "GAITrackedViewController.h"
#import "CardInfoView.h"

@interface SettingsVC : GAITrackedViewController <UIPageViewControllerDataSource>

@property NSArray * pagesForHowItWorks;

- (HowItWorksVC *)viewControllerAtIndex:(NSUInteger)index;
-(void) howItWorksPressed:(id)sender;
@end
