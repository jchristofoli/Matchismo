//
//  CardGameScoreChartViewController.m
//  Matchismo
//
//  Created by Floyd Christofoli on 9/29/13.
//  Copyright (c) 2013 Floyd Christofoli. All rights reserved.
//

#import "CardGameScoreChartViewController.h"

#import "ScoresManager.h"
#import "CorePlot-CocoaTouch.h"
#import "GameScore.h"

@interface CardGameScoreChartViewController ()

@property (nonatomic, strong) CPTGraphHostingView *hostView;
@property (strong, nonatomic) NSArray* topScores;

@end

@implementation CardGameScoreChartViewController

#pragma mark - UIViewController lifecycle methods
-(void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
        
    self.topScores = [[ScoresManager sharedInstance] getTopScores];
    self.topScores = [self.topScores sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        GameScore *first = (GameScore*)a;
        GameScore *second = (GameScore*)b;
        
        return [first.endDate compare:second.endDate] == NSOrderedAscending;
    }];

    [self initPlot];
}

#pragma mark - Chart behavior
-(void)initPlot {
    [self configureHost];
    [self configureGraph];
    [self configurePlots];
    [self configureAxes];
}

-(void)configureHost {
    self.hostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:self.view.bounds];
    self.hostView.allowPinchScaling = YES;
    [self.view addSubview:self.hostView];
}

-(void)configureGraph {
    // 1 - Create the graph
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    [graph applyTheme:[CPTTheme themeNamed:kCPTDarkGradientTheme]];
    self.hostView.hostedGraph = graph;

    // 2 - Set graph title
    graph.title = @"Scores";

    // 3 - Create and set text style
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor whiteColor];
    titleStyle.fontName = @"Helvetica-Bold";
    titleStyle.fontSize = 16.0f;
    graph.titleTextStyle = titleStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0.0f, 10.0f);

    // 4 - Set padding for plot area
    [graph.plotAreaFrame setPaddingLeft:30.0f];
    [graph.plotAreaFrame setPaddingBottom:30.0f];
    // 5 - Enable user interactions for plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
}

-(void)configurePlots {
    // 1 - Get graph and plot space
    CPTGraph *graph = self.hostView.hostedGraph;
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;

    // 2 - Create the plot
    CPTScatterPlot *scorePlot = [[CPTScatterPlot alloc] init];
    scorePlot.dataSource = self;
    scorePlot.identifier = @"SCORE";
    CPTColor *scoreColor = [CPTColor redColor];
    [graph addPlot:scorePlot toPlotSpace:plotSpace];

    // 3 - Set up plot space
    [plotSpace scaleToFitPlots:@[scorePlot]];
    CPTMutablePlotRange *xRange = [plotSpace.xRange mutableCopy];
    [xRange expandRangeByFactor:CPTDecimalFromCGFloat(1.1f)];
    plotSpace.xRange = xRange;
    CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
    [yRange expandRangeByFactor:CPTDecimalFromCGFloat(1.2f)];
    plotSpace.yRange = yRange;

    // 4 - Create styles and symbols
    CPTMutableLineStyle *scoreLineStyle = [scorePlot.dataLineStyle mutableCopy];
    scoreLineStyle.lineWidth = 2.5;
    scoreLineStyle.lineColor = scoreColor;
    scorePlot.dataLineStyle = scoreLineStyle;
    CPTMutableLineStyle *scoreSymbolLineStyle = [CPTMutableLineStyle lineStyle];
    scoreSymbolLineStyle.lineColor = scoreColor;
    CPTPlotSymbol *scoreSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    scoreSymbol.fill = [CPTFill fillWithColor:scoreColor];
    scoreSymbol.lineStyle = scoreSymbolLineStyle;
    scoreSymbol.size = CGSizeMake(6.0f, 6.0f);
    scorePlot.plotSymbol = scoreSymbol;
 }

-(void)configureAxes {
    // 1 - Create styles
    CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
    axisTitleStyle.color = [CPTColor whiteColor];
    axisTitleStyle.fontName = @"Helvetica-Bold";
    axisTitleStyle.fontSize = 12.0f;
    CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    axisLineStyle.lineWidth = 2.0f;
    axisLineStyle.lineColor = [CPTColor whiteColor];
    CPTMutableTextStyle *axisTextStyle = [[CPTMutableTextStyle alloc] init];
    axisTextStyle.color = [CPTColor whiteColor];
    axisTextStyle.fontName = @"Helvetica-Bold";
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

    NSMutableSet *xLabels = [NSMutableSet setWithCapacity:self.topScores.count];
    NSMutableSet *xLocations = [NSMutableSet setWithCapacity:self.topScores.count];
    NSInteger i = 0;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yy"];
    for (GameScore *score in self.topScores) {
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[dateFormat stringFromDate:score.endDate]  textStyle:x.labelTextStyle];
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
    y.title = @"Score";
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
    NSInteger majorIncrement = 10;
    NSInteger minorIncrement = 5;
    
    GameScore* topScore = [[ScoresManager sharedInstance] getHighScore:self.topScores];
    NSInteger yMax = topScore ? topScore.score : 1;
    NSMutableSet *yLabels = [NSMutableSet set];
    NSMutableSet *yMajorLocations = [NSMutableSet set];
    NSMutableSet *yMinorLocations = [NSMutableSet set];
    for (NSInteger j = minorIncrement; j <= yMax; j += minorIncrement) {
        NSUInteger mod = j % majorIncrement;
        if (mod == 0) {
            CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%i", j] textStyle:y.labelTextStyle];
            NSDecimal location = CPTDecimalFromInteger(j);
            label.tickLocation = location;
            label.offset = -y.majorTickLength - y.labelOffset;
            if (label) {
                [yLabels addObject:label];
            }
            [yMajorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:location]];
        } else {
            [yMinorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInteger(j)]];
        }
    }
    
    CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%i", yMax] textStyle:y.labelTextStyle];
    NSDecimal location = CPTDecimalFromInteger(yMax);
    label.tickLocation = location;
    label.offset = -y.majorTickLength - y.labelOffset;
    if (label) {
        [yLabels addObject:label];
    }
    [yMajorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInt(yMax)]];

    y.axisLabels = yLabels;
    y.majorTickLocations = yMajorLocations;
    y.minorTickLocations = yMinorLocations;
}

#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return self.topScores.count;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    NSInteger valueCount = self.topScores.count;
    switch (fieldEnum) {
        case CPTScatterPlotFieldX:
            if (index < valueCount) {
                return [NSNumber numberWithUnsignedInteger:index];
            }
            break;
            
        case CPTScatterPlotFieldY:
            return @([self.topScores[index] score]);
            break;
    }
    return [NSDecimalNumber zero];
}

@end
