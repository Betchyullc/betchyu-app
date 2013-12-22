//
//  BigButton.m
//  iBetchyu
//
//  Created by Betchyu Computer on 11/20/13.
//  Copyright (c) 2013 Betchyu Computer. All rights reserved.
//

#import "BigButton.h"

@implementation BigButton

@synthesize idKey;

- (id)initWithFrame:(CGRect)frame primary:(int)code title:(NSString *)title ident:(id)ident {
    self.idKey = ident;
    self = [self initWithFrame:frame primary:code title:title];
    return self;
}

- (id)initWithFrame:(CGRect)frame
            primary:(int)code
              title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {             // Initialization code
        UIColor *orange =[UIColor colorWithRed:1.0 green:(117.0/255.0) blue:(63/255.0) alpha:1.0];
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.font = [UIFont fontWithName:@"ProximaNova-Black" size:40];
        self.titleLabel.textAlignment = UITextAlignmentCenter;
        self.lineBreakMode = UILineBreakModeWordWrap;
        //self.titleLabel.shadowColor = ;
        //self.titleLabel.shadowOffset = ;
        self.layer.cornerRadius = 10;
        self.clipsToBounds = YES;
//        self.frame.size = CGSizeMake(280, 150);
        
        
        if (code == 0) {    // it's a primary button
            [self setBackgroundColor:orange];
            
        } else {            // it's a basic-non-primary button
            [self setBackgroundColor:[UIColor colorWithRed:(95/255.0) green:(95/255.0) blue:(95/255.0) alpha:1.0]];
        }
        
    }
    return self;
}


/*// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [[UIColor grayColor] setFill];
    UIRectFill(rect);
    
    [super drawRect:rect];
}*/


@end
