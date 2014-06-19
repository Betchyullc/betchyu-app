//  BinaryProgressView.h
//  betchyu
//
//  Created by Daniel Zapata on 6/19/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.

#import <UIKit/UIKit.h>

@protocol BinaryProgressViewDelegate <NSObject>
- (void)updated:(NSDictionary *)params;
@end

@interface BinaryProgressView : UIView

@property UIButton * yes;
@property UIButton * no;
@property int        betID;
@property(nonatomic, assign) id <BinaryProgressViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame AndBetId:(int)betId;

@end
