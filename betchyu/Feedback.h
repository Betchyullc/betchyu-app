//  Feedback.h
//  betchyu
//
//  Created by Daniel Zapata on 2/10/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.

#import <UIKit/UIKit.h>

@interface Feedback : UIView

@property UIViewController *owner;

- (id)initWithFrame:(CGRect)frame AndOwner:(UIViewController *)passedOwner;

@end
