//
//  BigButton.h
//  iBetchyu
//
//  Created by Betchyu Computer on 11/20/13.
//  Copyright (c) 2013 Betchyu Computer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BigButton : UIButton

@property id idKey;

- (id)initWithFrame:(CGRect)frame
            primary:(int)code
              title:(NSString *)title;
- (id)initWithFrame:(CGRect)frame
            primary:(int)code
              title:(NSString *)title
              ident:(id)ident;

@end
