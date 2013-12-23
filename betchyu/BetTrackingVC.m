//
//  BetTrackingVC.m
//  betchyu
//
//  Created by Adam Baratz on 12/19/13.
//  Copyright (c) 2013 BetchyuLLC. All rights reserved.
//

#import "BetTrackingVC.h"
#import "BigButton.h"
#import "API.h"
#import "ExistingBetDetailsVC.h"

@interface BetTrackingVC ()

@end

@implementation BetTrackingVC

@synthesize betJSON;
@synthesize bet;
@synthesize updateText;
@synthesize slider;
@synthesize currentBooleanDate;
@synthesize previousUpdates;

@synthesize hostView;

- (id)initWithJSON:(NSDictionary *)json {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        self.betJSON = json;
        self.bet = [[TempBet alloc] init];
        self.bet.endDate = [dateFormatter dateFromString:[betJSON valueForKey:@"endDate"]];
        self.bet.createdAt = [dateFormatter dateFromString: [[betJSON valueForKey:@"created_at"] substringWithRange:NSMakeRange(0, 10)]];
        self.bet.betVerb = [betJSON valueForKey:@"betVerb"];
        self.bet.betNoun = [betJSON valueForKey:@"betNoun"];
        self.bet.betAmount = [betJSON valueForKey:@"betAmount"];
        self.bet.ownStakeAmount = [betJSON valueForKey:@"ownStakeAmount"];
        self.bet.ownStakeType = [betJSON valueForKey:@"ownStakeType"];
        
        self.previousUpdates = [NSArray array];
    }
    return self;
}

-(void)loadView {
    // Create main UIScrollView (the container for home page buttons)
    UIView *mainView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    [mainView setBackgroundColor:[UIColor colorWithRed:(39/255.0) green:(37/255.0) blue:(37/255.0) alpha:1.0]];
    
    if ([bet.betVerb isEqualToString:@"Stop"]) {
        self.view = [self makeBooleanUpdater:mainView];
    /*} else if ([bet.betVerb isEqualToString:@"Lose"]){
        // the customization for the weight-loss bet-type
        self.view = [self makeWeightUpdater:mainView];*/
    } else {
        self.view = [self makeNormalUpdater:mainView];
    }
}

-(NSString *)trackingHeading {
    if ([bet.betVerb isEqualToString:@"Stop"]) {
        return @"I DIDN'T SMOKE:";
    } else if ([bet.betVerb isEqualToString:@"Run"]){
        return @"I'VE RUN:";
    } else if ([bet.betVerb isEqualToString:@"Workout"]){
        return @"I'VE WORKED OUT:";
    } else if ([bet.betVerb isEqualToString:@"Lose"]){
        return @"I'VE LOST:"; // The generic version of this bet-type
        //return @"I WEIGH:"; // The cusomized version of this option
    } else {
        return [NSString stringWithFormat:@"I'VE %@ED:", bet.betVerb];
    }
}

-(UIView *)makeBooleanUpdater:(UIView *)currentView {
    int w = currentView.frame.size.width;
    int h = currentView.frame.size.height;
    UIColor *bOr = [UIColor colorWithRed:1.0 green:(117.0/255.0) blue:(63/255.0) alpha:1.0];
    
    // The tracking summary heading
    UILabel *heading      = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, w, 40)];
    heading.textAlignment = NSTextAlignmentCenter;
    heading.font          = [UIFont fontWithName:@"ProximaNova-Black" size:35];
    heading.textColor     = [UIColor whiteColor];
    heading.text          = [self trackingHeading];
    
    // The tracking day text
    self.updateText               = [[UILabel alloc] initWithFrame:CGRectMake(10, 120, w-20, 30)];
    self.updateText.textAlignment = NSTextAlignmentCenter;
    self.updateText.font          = [UIFont fontWithName:@"ProximaNova-Regular" size:25];
    self.updateText.textColor     = bOr;
    
    // update YES btn
    BigButton *update = [[BigButton alloc] initWithFrame:CGRectMake(20, 155, (w-40)/2-10, 50) primary:0 title:@"YES"];
    [update addTarget:self action:@selector(makeBoolUpdate:) forControlEvents:UIControlEventTouchUpInside];
    
    // update NO btn
    BigButton *updateNo = [[BigButton alloc] initWithFrame:CGRectMake((w-40)/2+20, 155, (w-40)/2-10, 50) primary:1 title:@"NO"];
    [updateNo addTarget:self action:@selector(makeBoolUpdate:) forControlEvents:UIControlEventTouchUpInside];
    
    // the data graph
    //self.list = [[ProgressGraphView alloc] initWithFrame:CGRectMake(20, 230, w-40, h/3) AndDataArray:self.previousUpdates];
    
    // Add the subviews
    [currentView addSubview:self.slider];
    [currentView addSubview:heading];
    [currentView addSubview:self.updateText];
    [currentView addSubview:update];
    [currentView addSubview:updateNo];
    
    [self booleanDateUpdate];
    
    return currentView;
}
// cusomized view for tracking weight, where we just ask them for their current weight
-(UIView *)makeWeightUpdater:(UIView *)currentView {
    currentView = [self makeNormalUpdater:currentView];
    // this valueForKey:@"current" requires the initially created Bet to include a current => WEIGHT_DATA mapping in it, which is a TODO
    float val = [betJSON valueForKey:@"current"] == [NSNull null] ? 200.0 : [[betJSON valueForKey:@"current"] floatValue];
    self.slider.minimumValue = val - [bet.betAmount floatValue];
    self.slider.maximumValue = val;
    return currentView;
}
-(UIView *)makeNormalUpdater:(UIView *)currentView {
    int w = currentView.frame.size.width;
    int h = currentView.frame.size.height;
    UIColor *bOr = [UIColor colorWithRed:1.0 green:(117.0/255.0) blue:(63/255.0) alpha:1.0];
    
    // The tracking summary heading
    UILabel *heading      = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, w, 40)];
    heading.textAlignment = NSTextAlignmentCenter;
    heading.font          = [UIFont fontWithName:@"ProximaNova-Black" size:35];
    heading.textColor     = [UIColor whiteColor];
    heading.text          = [self trackingHeading];
    
    // tracking slider
    self.slider              = [[UISlider alloc] initWithFrame:CGRectMake(20, 130, w-40, 50)];
    self.slider.minimumValue = 0.0;
    self.slider.maximumValue = [bet.betAmount floatValue];
    [self.slider setMinimumTrackTintColor:bOr];
    [self.slider addTarget:self
                action:@selector(updateSliderValue:)
      forControlEvents:UIControlEventValueChanged];
    
    // The tracking summary text
    self.updateText               = [[UILabel alloc] initWithFrame:CGRectMake(10, 180, w-20, 30)];
    self.updateText.textAlignment = NSTextAlignmentCenter;
    self.updateText.font          = [UIFont fontWithName:@"ProximaNova-Regular" size:25];
    self.updateText.textColor     = bOr;
    [self currentStateText];
    
    // update btn
    BigButton *update = [[BigButton alloc] initWithFrame:CGRectMake(20, h-90, w-40, 70) primary:0 title:@"UPDATE"];
    [update addTarget:self action:@selector(makeUpdate:) forControlEvents:UIControlEventTouchUpInside];
    
    // the data graph
    /*self.graph = [[ProgressGraphView alloc] initWithFrame:CGRectMake(20, 230, w-40, h/3) AndDataArray:[NSArray array]];
    self.graph.backgroundColor = [UIColor whiteColor];*/
    
    // Add the subviews
    [currentView addSubview:self.slider];
    [currentView addSubview:heading];
    [currentView addSubview:self.updateText];
    [currentView addSubview:update];
    
    return currentView;
}

// ===== NORMAL BET-TYPE METHODS ====== //
-(void)updateSliderValue: (id)sender {
    int amount = (int)(((UISlider *)sender).value);
    updateText.text = [[@(amount) stringValue] stringByAppendingString:[@" " stringByAppendingString:bet.betNoun]];
}
// sets the UISlider starting value and the text starting description based on the result of an API call
-(void)currentStateText {
    NSString* path =[NSString stringWithFormat:@"bets/%@/updates", [betJSON valueForKey:@"id"]];
    
    //make the call to the web API
    // GET /bets/:bet_id/updates => {data}
    [[API sharedInstance] get:path withParams:nil
                  onCompletion:^(NSDictionary *json) {
                      //success
                      self.previousUpdates = (NSArray*)json;
                      if (((NSArray*)json).count > 0) {
                          int val = [[[((NSArray*)json) objectAtIndex:(((NSArray*)json).count-1)] valueForKey:@"value"] integerValue];
                          self.updateText.text = [NSString stringWithFormat:@"%i %@", val, bet.betNoun];
                          self.slider.value = [[NSNumber numberWithInt:val] floatValue];
                      } else {
                          self.updateText.text = [NSString stringWithFormat:@"0 %@", bet.betNoun];
                          self.slider.value = 0.0;
                      }
                  }];
}
- (void)makeUpdate:(id)sender {
    NSMutableDictionary* params =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithFloat:self.slider.value], @"value",
                                  [betJSON valueForKey:@"id"],                  @"bet_id",
                                  nil];
    
    //make the call to the web API
    // POST /updates => {data}
    [[API sharedInstance] post:@"updates" withParams:params onCompletion:
     ^(NSDictionary *json) {
         //success
         [self currentStateText];
     }];

}

// ===== BOOLEAN BET-TYPE METHODS ====== //
- (void)makeBoolUpdate:(BigButton *)sender {
    int val = [sender.currentTitle isEqualToString:@"YES"] ? 1 : 0 ;
    
    /*if (previousUpdates.count ==) {
        
    }*/
    
    NSMutableDictionary* params =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithInt:val], @"value",
                                  [betJSON valueForKey:@"id"],  @"bet_id",
                                  nil];
    
    //make the call to the web API
    // POST /updates => {data}
    [[API sharedInstance] post:@"updates" withParams:params
                  onCompletion:^(NSDictionary *json) {
                      //success
                      
                      // REDRAW self.graph
                      
                      //[self.navigationController popToRootViewControllerAnimated:YES];
                      [self booleanDateUpdate];
                  }];
    
}
-(void)booleanDateUpdate {
    NSString* path =[NSString stringWithFormat:@"bets/%@/updates", [betJSON valueForKey:@"id"]];
    
    //make the call to the web API
    // GET /bets/:bet_id/updates => {data}
    [[API sharedInstance] get:path withParams:nil onCompletion:
     ^(NSDictionary *json) {
         //success
         self.previousUpdates = (NSArray *)json;
         
         if (((NSArray*)json).count > 0) {
             NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
             dayComponent.day = ((NSArray*)json).count;
             
             NSCalendar *theCalendar = [NSCalendar currentCalendar];
             currentBooleanDate = [theCalendar dateByAddingComponents:dayComponent toDate:bet.createdAt options:0];
         } else {
             currentBooleanDate = bet.createdAt;
         }
         
         NSString *dateString = [[NSString stringWithFormat:@"%@", currentBooleanDate] substringWithRange:NSMakeRange(0, 10)];
         self.updateText.text = [NSString stringWithFormat:@"on %@", dateString];
     }];
}

// helper methods
-(long)numberOfDaysTheBetLasts {
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:bet.createdAt
                                                          toDate:bet.endDate
                                                         options:0];
    return (long)[components day];
}
-(NSArray *)eachDateStringForTheBet {
    NSMutableArray *dates = [NSMutableArray array];
    NSDate *date;
    for (long i = 0; i < [self numberOfDaysTheBetLasts]; i++) {
        NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
        dayComponent.day = i;
        
        NSCalendar *theCalendar = [NSCalendar currentCalendar];
        date = [theCalendar dateByAddingComponents:dayComponent toDate:bet.createdAt options:0];
        [dates addObject:[[NSString stringWithFormat:@"%@", date] substringWithRange:NSMakeRange(5, 5)]];
    }
    
    return [dates subarrayWithRange:NSMakeRange(0, dates.count)];
}

// navigation method(s)
-(void)showDetailsPage:(id)sender {
    ExistingBetDetailsVC *vc =[[ExistingBetDetailsVC alloc] initWithJSON:self.betJSON];
    // Show it.
    [self.navigationController pushViewController:vc animated:true];
}

#pragma mark - UIViewController lifecycle methods
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (![bet.betVerb isEqualToString:@"Stop"]) {
        [self initPlot];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"info_button.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showDetailsPage:)];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Chart behavior
-(void)initPlot {
    [self configureHost];
    [self configureGraph];
    [self configurePlots];
    [self configureAxes];
}

-(void)configureHost {
    int h = self.view.frame.size.height;

    self.hostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:CGRectMake(20, 230, 280, h/3)];
    self.hostView.allowPinchScaling = YES;
    [self.view addSubview:self.hostView];
}
-(void)configureGraph {
    // 1 - Create the graph
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    [graph applyTheme:[CPTTheme themeNamed:kCPTDarkGradientTheme]];
    self.hostView.hostedGraph = graph;
    // 2 - Set graph title
    graph.title = @"Progress So Far";
    // 3 - Create and set text style
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor whiteColor];
    titleStyle.fontName = @"ProximaNova-Regular";
    titleStyle.fontSize = 16.0f;
    graph.titleTextStyle = titleStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0.0f, 15.0f);
    // remove graph padding
    graph.paddingLeft   = 1.0f;
    graph.paddingRight  = 1.0f;
    //graph.paddingTop    = 1.0f;
    graph.paddingBottom = 1.0f;
    // 4 - Set padding for plot area
    [graph.plotAreaFrame setPaddingLeft:25.0f];
    [graph.plotAreaFrame setPaddingBottom:20.0f];
    // 5 - Enable user interactions for plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
}
-(void)configurePlots {
    // 1 - Get graph and plot space
    CPTGraph *graph = self.hostView.hostedGraph;
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    
    // 2 - Create the plot
    CPTScatterPlot *plot = [[CPTScatterPlot alloc] init];
    plot.dataSource = self;
    plot.identifier = [NSString stringWithFormat:@"%@ %@", bet.betNoun, bet.betVerb];
    CPTColor *plotColor = [CPTColor colorWithComponentRed:1.0 green:(117.0/255.0) blue:(63/255.0) alpha:1.0];
    [graph addPlot:plot toPlotSpace:plotSpace];
    
    // 3 - Set up plot space
    [plotSpace scaleToFitPlots:[NSArray arrayWithObjects:plot, nil]];
    CPTMutablePlotRange *xRange = [plotSpace.xRange mutableCopy];
    [xRange expandRangeByFactor:CPTDecimalFromCGFloat(1.1f)];
    plotSpace.xRange = xRange;
    CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
    [yRange expandRangeByFactor:CPTDecimalFromCGFloat(1.2f)];
    plotSpace.yRange = yRange;
    
    // 4 - Create styles and symbols
    CPTMutableLineStyle *lineStyle = [plot.dataLineStyle mutableCopy];
    lineStyle.lineWidth = 2.5;
    lineStyle.lineColor = plotColor;
    plot.dataLineStyle = lineStyle;
    CPTMutableLineStyle *symbolLineStyle = [CPTMutableLineStyle lineStyle];
    symbolLineStyle.lineColor = plotColor;
    CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill = [CPTFill fillWithColor:plotColor];
    plotSymbol.lineStyle = symbolLineStyle;
    plotSymbol.size = CGSizeMake(6.0f, 6.0f);
    plot.plotSymbol = plotSymbol;
}
-(void)configureAxes {
    // 1 - Create styles
    CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
    axisTitleStyle.color = [CPTColor whiteColor];
    axisTitleStyle.fontName = @"ProximaNova-Regular";
    axisTitleStyle.fontSize = 12.0f;
    CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    axisLineStyle.lineWidth = 2.0f;
    axisLineStyle.lineColor = [CPTColor whiteColor];
    CPTMutableTextStyle *axisTextStyle = [[CPTMutableTextStyle alloc] init];
    axisTextStyle.color = [CPTColor whiteColor];
    axisTextStyle.fontName = @"ProximaNova-Regular";
    axisTextStyle.fontSize = 11.0f;
    CPTMutableLineStyle *tickLineStyle = [CPTMutableLineStyle lineStyle];
    tickLineStyle.lineColor = [CPTColor whiteColor];
    tickLineStyle.lineWidth = 2.0f;
    CPTMutableLineStyle *gridLineStyle = [CPTMutableLineStyle lineStyle];
    tickLineStyle.lineColor = [CPTColor blackColor];
    tickLineStyle.lineWidth = 1.0f;
    // 2 - Get axis set
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.hostView.hostedGraph.axisSet;
    
    // 3 - Configure x-axis
    CPTAxis *x = axisSet.xAxis;
    x.title = @"Date";
    x.titleTextStyle = axisTitleStyle;
    x.titleOffset = 15.0f;
    x.axisLineStyle = axisLineStyle;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    x.labelTextStyle = axisTextStyle;
    x.majorTickLineStyle = axisLineStyle;
    x.majorTickLength = 4.0f;
    x.tickDirection = CPTSignNegative;
    CGFloat dateCount = [self numberOfDaysTheBetLasts];
    NSMutableSet *xLabels = [NSMutableSet setWithCapacity:dateCount];
    NSMutableSet *xLocations = [NSMutableSet setWithCapacity:dateCount];
    NSInteger i = 0;
    for (NSString *obj in [self eachDateStringForTheBet]) {
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:obj  textStyle:x.labelTextStyle];
        CGFloat location = i++;
        label.tickLocation = CPTDecimalFromCGFloat(location);
        label.offset = x.majorTickLength;
        if (label) {
            [xLabels addObject:label];
            [xLocations addObject:[NSNumber numberWithFloat:location]];
        }
    }
    x.axisLabels = xLabels;
    x.majorTickLocations = xLocations;
    
    // 4 - Configure y-axis
    CPTAxis *y = axisSet.yAxis;
    y.title = @"Progress";
    y.titleTextStyle = axisTitleStyle;
    y.titleOffset = -40.0f;
    y.axisLineStyle = axisLineStyle;
    y.majorGridLineStyle = gridLineStyle;
    y.labelingPolicy = CPTAxisLabelingPolicyNone;
    y.labelTextStyle = axisTextStyle;
    y.labelOffset = 16.0f;
    y.majorTickLineStyle = axisLineStyle;
    y.majorTickLength = 4.0f;
    y.minorTickLength = 2.0f;
    y.tickDirection = CPTSignPositive;
    float majorIncrement = [bet.betAmount floatValue] / 4.0f;
    CGFloat yMax = [bet.betAmount floatValue] + majorIncrement;  // should determine dynamically based on max price
    NSMutableSet *yLabels = [NSMutableSet set];
    NSMutableSet *yMajorLocations = [NSMutableSet set];
    NSMutableSet *yMinorLocations = [NSMutableSet set];
    for (float j = 0; j <= yMax; j += majorIncrement) {
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%i", (int)j] textStyle:y.labelTextStyle];
        NSDecimal location = CPTDecimalFromFloat(j);
        label.tickLocation = location;
        label.offset = -y.majorTickLength - y.labelOffset;
        if (label) {
            [yLabels addObject:label];
        }
        [yMajorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:location]];
    }
    y.axisLabels = yLabels;    
    y.majorTickLocations = yMajorLocations;
    y.minorTickLocations = yMinorLocations;
}

#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return previousUpdates.count;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    NSInteger valueCount = previousUpdates.count;
    switch (fieldEnum) {
        case CPTScatterPlotFieldX:
            if (index < valueCount) {
                // Make the date
                [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                //[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                NSDate *theDate = [dateFormatter dateFromString: [[[previousUpdates objectAtIndex:index] valueForKey:@"created_at"] substringWithRange:NSMakeRange(0, 10)]];
                
                // get the days between dates (start of bet and update.created_at)
                NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                                    fromDate:self.bet.createdAt
                                                                      toDate:theDate
                                                                     options:0];
                return [NSNumber numberWithInteger:components.day];
            }
            break;
            
        case CPTScatterPlotFieldY:
            return [[previousUpdates objectAtIndex:index] valueForKey:@"value"];
            break;
    }
    return [NSDecimalNumber zero];
}

@end
