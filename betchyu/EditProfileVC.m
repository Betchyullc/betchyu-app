//
//  EditProfileVC.m
//  betchyu
//
//  Created by Adam Baratz on 6/12/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import "EditProfileVC.h"
#import "ProfileView.h"

@interface EditProfileVC ()

@end

@implementation EditProfileVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView {
    CGRect f = [UIScreen mainScreen].applicationFrame;
    
    int y = self.navigationController.navigationBar.frame.size.height + f.origin.y; // navBar + statusBar
    int h = f.size.height - y;
    
    CGRect f2 = CGRectMake(f.origin.x, y, f.size.width, h);
    
    self.view = [[ProfileView alloc] initWithFrame:f2 AndOwner:self];
    //self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"Profile Information";
}

@end