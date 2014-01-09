//
//  HowItWorksVC.m
//  betchyu
//
//  Created by Adam Baratz on 1/7/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import "HowItWorksVC.h"
#import "AppDelegate.h"

@interface HowItWorksVC ()

@end

@implementation HowItWorksVC

@synthesize index;
@synthesize tutorialImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.tutorialImage =[UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg",self.index+1]];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:self.tutorialImage];
    imgView.frame = self.parentViewController.view.frame;
    
    self.view = imgView;
}
-(void)viewDidAppear:(BOOL)animated {
    
    if (self.index == 5) {
        AppDelegate *app =(AppDelegate *)([[UIApplication sharedApplication] delegate]);
        
        [app.window setRootViewController:app.stackViewController];
        [app.window makeKeyAndVisible];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
