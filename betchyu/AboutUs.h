//  AboutUs.h
//  betchyu
//
//  Created by Daniel Zapata on 12/22/13.
//  Copyright (c) 2013 BetchyuLLC. All rights reserved.

#import <UIKit/UIKit.h>

@interface AboutUs : UIView

@property UIViewController *owner;

- (id)initWithFrame:(CGRect)frame AndOwner:(UIViewController *)passedOwner;

@end
