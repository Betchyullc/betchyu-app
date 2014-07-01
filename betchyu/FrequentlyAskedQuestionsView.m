//
//  FrequentlyAskedQuestionsView.m
//  betchyu
//
//  Created by Adam Baratz on 6/30/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import "FrequentlyAskedQuestionsView.h"

@implementation FrequentlyAskedQuestionsView

@synthesize questions;
@synthesize answers;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        questions = @[@"What happens if no one signs up for my bet?",
                      @"Can I cancel a bet?",
                      @"If I win the bet, how do I receive the prize?",
                      @"What happens if I don't update my goal?",
                      @"Does Betchyu have any extra fees?",
                      @"How do my friends sign up to my goal?",
                      @"Can I create bets other than the ones listed?",
                      @"Is it possible to set goals/bets that are longer than 30 days?",
                      @"Can I chose another type of reward instead of the Amazon, Target or iTunes gift card?",
                      @"Can I add friends to a bet once the bet has been created?",
                      @"How do I know when my friend has updated his progress?",
                      @"How do I contact Betchyu?"];
        answers = @[@"If no one signs up for your bet then it will automatically be voided after 1/3 of the time has passed.",
                    @"You can only cancel a bet if no one has accepted your invitation. You can do this by swiping right on the bet in the dashboard. Once your friends sign up, the bet is on and there is no going back.",
                    @"When you win a bet, the prize will be emailed to your Facebook email address. If you want us to use a different email, please change your profile information (found in the settings).",
                    @"For all goals except smoking, you are required to update your goal before the end date. If you don't, then you automatically lose the bet. For smoking, you will automatically win the bet, unless you report that you smoked.",
                    @"No. We are 100% fee free.",
                    @"When you make a bet, you are given the option to post a link on your friend's facebook page to download the Betchyu app. If you don't feel comfortable, publicly sharing your goal, you can privately invite them to download the app.",
                    @"No. You can only create bets that are listed in the application. If you do wish to add other bets, please contact us and we'll put it in the pipeline.",
                    @"No. Right now we have a 30 day limit on goals. This might change in the future.",
                    @"Not at the moment. We are expanding the choices for rewards soon, so look out.",
                    @"No. You cannot add friends to a bet once it has been finalized.",
                    @"When your friend updates his/her progress, you will (probably) get a push notification.",
                    @"Email the Betchyu team at: info@betchyu.com​"];
        
        int off = 5;
        int height = 44;
        int fontSize = 15;
        int arrowWidth = 20;
        int xMargin = 14;
        for (int i = 0; i < questions.count; i++) {
            CGRect f = CGRectMake(xMargin, off + (i * height), frame.size.width-2*xMargin - arrowWidth- 5, height);
            // make the Label
            UILabel *q = [[UILabel alloc] initWithFrame:f];
            q.text = [questions objectAtIndex:i];
            q.textColor= Bdark;
            q.font = FregfS;
            
            // make the arrow
            UILabel * a6 = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width - xMargin -arrowWidth, f.origin.y, arrowWidth, height)];
            a6.text      = [NSString stringWithUTF8String:"❯"];
            a6.textColor = Bdark;
            a6.font      = FregfS;
            
            // make the line
            UIView *l = [[UIView alloc] initWithFrame:CGRectMake(f.origin.x, f.origin.y + height - 1, f.size.width + arrowWidth+5, 1)];
            l.backgroundColor = Bmid;
            
            // the button
            UIButton *b = [[UIButton alloc] initWithFrame:f];
            [b addTarget:self action:@selector(showAnswer:) forControlEvents:UIControlEventTouchUpInside];
            b.tag = i;
            
            [self addSubview:q];
            [self addSubview:a6];
            [self addSubview:l];
            [self addSubview:b];
        }
        self.contentSize = CGSizeMake(frame.size.width, height*questions.count + 20);
    }
    return self;
}

-(void)showAnswer:(UIButton *)sender {
    int fontSize = 16;
    AppDelegate * app = ((AppDelegate *)([[UIApplication sharedApplication] delegate]));
    
    UIViewController *vc = [UIViewController new];
    
    UILabel *answer = [[UILabel alloc] initWithFrame:CGRectMake(15, self.frame.origin.y, self.frame.size.width - 30, self.frame.size.height)];
    answer.backgroundColor = [UIColor whiteColor];
    answer.text = [answers objectAtIndex:sender.tag];
    answer.font = FregfS;
    answer.textColor = Bdark;
    answer.numberOfLines = 0;
    answer.lineBreakMode = NSLineBreakByWordWrapping;
    vc.view = [[UIView alloc] initWithFrame:self.frame];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.title = [questions objectAtIndex:sender.tag];
    [vc.view addSubview:answer];
    
    [app.navController pushViewController:vc animated:YES];
}

@end
