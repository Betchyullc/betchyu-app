//
//  ProfileView.m
//  betchyu
//
//  Created by Adam Baratz on 12/22/13.
//  Copyright (c) 2013 BetchyuLLC. All rights reserved.
//

#import "ProfileView.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"

@implementation ProfileView

@synthesize owner;

- (id)initWithFrame:(CGRect)frame AndOwner:(UIViewController *)passedOwner {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.owner = passedOwner;
        
        UIView *lineView;  //used for drawing lines
        
        self.backgroundColor = [UIColor colorWithRed:(95/255.0) green:(95/255.0) blue:(95/255.0) alpha:1.0];
        
        /////////////////////
        // The back button
        /////////////////////
        // actual buttom
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(25, 40, 80, 30)];
        [backBtn setTitle:@"< Menu" forState:UIControlStateNormal];
        backBtn.font = [UIFont fontWithName:@"ProximaNova-Regular" size:20];
        [backBtn addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        // it's line
        lineView = [[UIView alloc] initWithFrame:CGRectMake(29, 80, frame.size.width, 2)];
        lineView.backgroundColor = [UIColor whiteColor];
        // add to the view
        [self addSubview:backBtn];
        [self addSubview:lineView];
        
        ////////////////////////
        // The Profile Picture
        ////////////////////////
        int dim = frame.size.width / 3;
        // the picture
        FBProfilePictureView *mypic = [[FBProfilePictureView alloc]
                                       initWithProfileID:((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId
                                         pictureCropping:FBProfilePictureCroppingOriginal];
        mypic.frame = CGRectMake(2, 2, dim-4, dim-4);
        mypic.layer.cornerRadius = (dim-4)/2;
        // The border
        UIView *border = [[UIView alloc] initWithFrame:CGRectMake((frame.size.width/2)-(dim/2), (frame.size.height/3)-(dim/2), dim, dim)];
        border.backgroundColor = [UIColor whiteColor];
        border.layer.cornerRadius = dim/2;
        [border addSubview:mypic];
        [self addSubview:border];
    }
    return self;
}

-(void)backBtnPressed:(id)sender {
    [owner.navigationController popViewControllerAnimated:YES];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
