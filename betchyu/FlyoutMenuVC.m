//
//  FlyoutMenuVC.m
//  betchyu
//
//  Created by Adam Baratz on 12/21/13.
//  Copyright (c) 2013 BetchyuLLC. All rights reserved.
//

#import "FlyoutMenuVC.h"

@interface FlyoutMenuVC ()

@end

@implementation FlyoutMenuVC

@synthesize passedFrame;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        passedFrame = frame;
    }
    return self;
}

-(void)loadView {
    self.view = [[UIView alloc] initWithFrame:self.passedFrame];
    self.view.backgroundColor = [UIColor colorWithRed:(39/255.0) green:(37/255.0) blue:(37/255.0) alpha:1.0];
    
    //UIButton *myProfile;
    

    CGRect logoutRect = CGRectMake(20, passedFrame.size.height-50, 280, 40);
    UIButton *logout = [[UIButton alloc] initWithFrame:logoutRect];
    UILabel *logoutLabel = [[UILabel alloc] initWithFrame:logoutRect];
    logoutLabel.text = @"Logout";
    logoutLabel.textColor = [UIColor whiteColor];
    logoutLabel.font = [UIFont fontWithName:@"ProximaNova-Black" size:30];
    [self.view addSubview:logout];
    [self.view addSubview:logoutLabel];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
