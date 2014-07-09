//
//  CardInfoView.m
//  betchyu
//
//  Created by Adam Baratz on 7/9/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import "CardInfoView.h"

@implementation CardInfoView

@synthesize cardNum;
@synthesize cvv;
@synthesize month;
@synthesize year;

@synthesize hasBeenCleared;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.hasBeenCleared = NO;
        NSString * ownId = ((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId;
        NSString * ownName = ((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownName;
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = NO;
        self.clipsToBounds      = NO;
        self.layer.shadowColor  = [Bdark CGColor];
        self.layer.shadowRadius = 3.0f;
        self.layer.shadowOffset = CGSizeMake(0, 5);
        self.layer.shadowOpacity= 0.7f;
        self.layer.shadowPath   = [[UIBezierPath bezierPathWithRect:self.layer.bounds] CGPath];
        
        int fontSize = 17;
        int w = frame.size.width;
        int dim = frame.size.width / 4;
        
        /// The 'Name' indicator
        UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, frame.size.width, 20)];
        nameLbl.text = @"Name";
        nameLbl.textColor = Bmid;
        nameLbl.font = FregfS;
        [self addSubview:nameLbl];
        
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/3, 10, frame.size.width, 20)];
        name.text = ownName;
        name.textColor = Borange;
        name.font = FregfS;
        [self addSubview:name];
        
        /// The 'Card' indicator
        UILabel *cardLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 10 + 35, frame.size.width, 20)];
        cardLbl.text = @"Card #";
        cardLbl.textColor = Bmid;
        cardLbl.font = FregfS;
        [self addSubview:cardLbl];
        
        NSString *path = [NSString stringWithFormat:@"card/%@",ownId];
        [[API sharedInstance] get:path withParams:nil onCompletion:^(NSDictionary *json) {
            // Success! Include your code to handle the results here
            if ([[json valueForKey:@"msg"] isEqualToString:@"no card found, man"]) {
                return;
            }
            
            self.cardNum          = [[UITextField alloc] initWithFrame:CGRectMake(frame.size.width/3, 10 + 35, frame.size.width, 20)];
            self.cardNum.text     = [json valueForKey:@"card"];
            self.cardNum.textColor= Borange;
            self.cardNum.font     = FregfS;
            self.cardNum.delegate = self;
            self.cardNum.keyboardType = UIKeyboardTypeNumberPad;
            [self addSubview:cardNum];
            
            
            self.month.text = [json valueForKey:@"month"];
            [self addSubview:month];
            self.year.text = [json valueForKey:@"year"];
            [self addSubview:year];
        }];
        
        /// The 'CVV' indicator
        UILabel *cvvL = [[UILabel alloc] initWithFrame:CGRectMake(20, 10 + 35 + 35, frame.size.width, 20)];
        cvvL.text = @"CVV";
        cvvL.textColor = Bmid;
        cvvL.font = FregfS;
        [self addSubview:cvvL];
        
        self.cvv = [[UITextField alloc] initWithFrame:CGRectMake(frame.size.width/3, 10 + 35 + 35, frame.size.width, 20)];
        self.cvv.text = @"***";
        self.cvv.textColor= Borange;
        self.cvv.font     = FregfS;
        self.cvv.delegate = self;
        self.cvv.keyboardType = UIKeyboardTypeNumberPad;
        [self addSubview:cvv];
        
        /// The 'Exp Month' indicator
        UILabel *mL = [[UILabel alloc] initWithFrame:CGRectMake(20, 10 + (35*3), frame.size.width, 20)];
        mL.text = @"Exp Month";
        mL.textColor = Bmid;
        mL.font = FregfS;
        [self addSubview:mL];
        
        self.month = [[UITextField alloc] initWithFrame:CGRectMake(frame.size.width/3, 10 + (35*3), frame.size.width, 20)];
        self.month.textColor= Borange;
        self.month.font     = FregfS;
        self.month.delegate = self;
        self.month.keyboardType = UIKeyboardTypeNumberPad;
        
        /// The 'Exp Year' indicator
        UILabel *yL = [[UILabel alloc] initWithFrame:CGRectMake(20, 10 + (35*4), frame.size.width, 20)];
        yL.text = @"Exp Year";
        yL.textColor = Bmid;
        yL.font = FregfS;
        [self addSubview:yL];
        
        self.year = [[UITextField alloc] initWithFrame:CGRectMake(frame.size.width/3, 10 + (35*4), frame.size.width, 20)];
        self.year.textColor= Borange;
        self.year.font     = FregfS;
        self.year.delegate = self;
        self.year.keyboardType = UIKeyboardTypeNumberPad;
        
        // the 'Update' button
        UIButton *updateBtn          = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        updateBtn.frame              = CGRectMake(w/4, frame.size.height - fontSize*2.5, w/2, fontSize*2);
        updateBtn.backgroundColor    = Bgreen;
        updateBtn.layer.cornerRadius = 7;
        updateBtn.tintColor          = [UIColor whiteColor];
        updateBtn.titleLabel.font    = [UIFont fontWithName:@"ProximaNova-Bold" size:fontSize];
        [updateBtn setTitle:@"Update" forState:UIControlStateNormal];
        [updateBtn addTarget:self action:@selector(update:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:updateBtn];
        
    }
    return self;
}

-(void) update:(UIButton *)sender {// Determine if we are in test-mode or real mode
    BTEncryption * braintree;
    if ([[[API sharedInstance].baseURL absoluteString] isEqualToString:@"http://localhost:5000"]
        || [[[API sharedInstance].baseURL absoluteString] isEqualToString:@"http://betchyu-staging.herokuapp.com"]) {
        braintree = [[BTEncryption alloc]initWithPublicKey:@"MIIBCgKCAQEAmRehlELjqxPOltj1/bpsQE92opagAj6tFB8wo4Z/Dy0x7nugGnC7fvvvIEo5MEoKg6HvU1GSmpP7VQ4XU/8YDXblbaKsLgb5K92BySKwM1FyHoL2IfRrEDdJcV9tMJ9hjZbIcg7uBUYhT/rgpWBRaDVLMEAMnqvSH7UZ2wlCjjT1NJScrMDd4EyXQQcXSdc5ri9C62QfzopVxA6iOvK8YPkzRkmNUQOkEf67v+kiUgh2w2YWEXogmRCUoUpdzODJ689UcpqyMHrwouC+WxqLJK/0zDHy44Fofc/Sqp4Wf19fslXmb4HW8u5GqQUV/5PXi3B+j4tOeXxXynTeOKtcqQIDAQAB"];
    } else { // real production server
        braintree = [[BTEncryption alloc]initWithPublicKey:@"MIIBCgKCAQEA1FfiDXfYBxtcOCu7wcOK+0/n4q4C6WUaakP8/PzflZRJ30Ac+onTkzPLct4InPoL/P6CCkLOUQrcFcXZRFIdvCieAks1dY53c5TnBV8f8dqFA/CZQm+J1O/W+m+aAIIUyre6qbZ7Wv2IC2tRDM4nW9RcWIIQ7c9ZNpHfdP4muIpEWvF0D0VplRjkdTZUMSxR9/nJ7fqfYTazEmo9GXDa7LPf22r178Iq9WTlKfk6APNE7aYrx8zN21FshweJgBBRZxh4LFmBd+j1DzLciBJNjFh1JA98D+40XGLj+9SPXoVCSznshW4X5sV970W0rnCwU01VTBk/8N3HWgwbZK6mnwIDAQAB"];
    }
    
    
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    self.cardNum.text,  @"card_number",
                                    self.cvv.text,      @"cvv",
                                    self.month.text,    @"expiration_month",
                                    self.year.text,    @"expiration_year",
                                    nil];
    
    // manually encrypt the cardInfo
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
        [params setObject: [braintree encryptString: object] forKey: key];
    }];
    
    NSString *ownerString = ((AppDelegate *)([[UIApplication sharedApplication] delegate])).ownId;
    [params setValue:ownerString forKey:@"user"];
    
    [[API sharedInstance] post:@"card" withParams:params onCompletion:^(NSDictionary *json) {
        // Success! Include your code to handle the results here
        [self.cardNum resignFirstResponder];
        [self.year resignFirstResponder];
        [self.month resignFirstResponder];
        [self.cvv resignFirstResponder];
        
        [[[UIAlertView alloc] initWithTitle:@"Credit Card" message:[json valueForKey:@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }];
}

#pragma mark UITextFieldDelegate shit
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if (!self.hasBeenCleared) {
        self.hasBeenCleared = YES;
        self.cvv.text = @"";
        self.cardNum.text = @"";
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.cardNum resignFirstResponder];
    [self.cvv resignFirstResponder];
    [self.year resignFirstResponder];
    [self.month resignFirstResponder];
}

@end
