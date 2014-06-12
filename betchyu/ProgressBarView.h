//
//  ProgressBarView.h
//  betchyu
//
//  Created by Daniel Zapata on 6/12/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressBarView : UIView

@property int progress;
@property UIColor * color;


- (id)initWithFrame:(CGRect)frame AndColor:(UIColor *)c AndPercentComplete:(int)per;

@end
