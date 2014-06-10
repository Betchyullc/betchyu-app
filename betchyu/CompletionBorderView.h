//
//  CompletionBorderView.h
//  betchyu
//
//  Created by Adam Baratz on 6/10/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompletionBorderView : UIView

@property UIColor * color;
@property int percent;

- (id)initWithFrame:(CGRect)frame AndColor:(UIColor *)c AndPercentComplete:(int)per;

@end
