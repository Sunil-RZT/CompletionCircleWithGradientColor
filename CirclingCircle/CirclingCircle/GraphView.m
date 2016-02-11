//
//  GraphView.m
//  CirclingCircle
//
//  Created by Sunil Rao on 10/11/15.
//  Copyright © 2015 Razorthink. All rights reserved.
//

#import "GraphView.h"
#define SCREEN_WIDTH        self.frame.size.width
#define SCREEN_HEIGHT       self.frame.size.height

#define TOTAL_X_DIST        SCREEN_WIDTH * 0.85
#define TOTAL_Y_DIST        SCREEN_HEIGHT * 0.65
#define STARTING_X          SCREEN_WIDTH * 0.10
#define ENDING_X            SCREEN_WIDTH * 0.95
#define STARTING_Y          SCREEN_HEIGHT * 0.85
#define ENDING_Y            SCREEN_HEIGHT * 0.20

@interface GraphView()

@property (nonatomic,strong)UILabel *graphLabel;
@property (nonatomic,strong)UILabel *graphMarking;
@property (nonatomic,strong)NSMutableArray *xDataLable;
@property (nonatomic,strong)NSMutableArray *yDataLable;
@property (nonatomic,assign) float spacingX;
@property (nonatomic,assign) float spacingY;
@property (nonatomic,strong)NSMutableArray *pointsArray;
@property (nonatomic,strong) NSMutableArray *coordinateArray;

@end

@implementation GraphView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        
        self.graphLabel = [[UILabel alloc]init];
        self.graphLabel.textAlignment = NSTextAlignmentCenter;
        self.graphLabel.text = @"Graph";
        [self addSubview:self.graphLabel];
//        self.graphLabel.alpha = 0;
//        [UILabel animateWithDuration:2 animations:^{
//            self.graphLabel.alpha = 1;
//        }];
        
        self.graphMarking = [[UILabel alloc]init];
        self.graphMarking.textAlignment = NSTextAlignmentCenter;
        
        self.xDataLable = [[NSMutableArray alloc]init];
        self.yDataLable = [[NSMutableArray alloc]init];
        self.pointsArray = [[NSMutableArray alloc]init];
        self.coordinateArray = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    
    //Creating gaph layout path
    UIBezierPath *graphPath = [[UIBezierPath alloc]init];
    [graphPath setLineWidth:1];
    [[UIColor blackColor] setStroke];
    [graphPath moveToPoint:CGPointMake(SCREEN_WIDTH * 0.10, SCREEN_HEIGHT * 0.20)];
    [graphPath addLineToPoint:CGPointMake(SCREEN_WIDTH * 0.95,SCREEN_HEIGHT * 0.20)];
    [graphPath addLineToPoint:CGPointMake(SCREEN_WIDTH * 0.95, SCREEN_HEIGHT * 0.85)];
    [graphPath addLineToPoint:CGPointMake(SCREEN_WIDTH * 0.10, SCREEN_HEIGHT * 0.85)];
    [graphPath addLineToPoint:CGPointMake(SCREEN_WIDTH * 0.10, SCREEN_HEIGHT * 0.20)];
    //Creating graph layout
    CAShapeLayer *graphLayout = [CAShapeLayer layer];
    graphLayout.fillColor = [[UIColor clearColor] CGColor];
    graphLayout.strokeColor = [[UIColor blackColor] CGColor];
    graphLayout.lineWidth = 2;
    graphLayout.path = [graphPath CGPath];
    [self.layer addSublayer:graphLayout];
    
    float minX = 0;
    float maxX = 10;
    float minY = 0;
    float maxY = 5;
    
    float x1Unit = 1;
    float y1Unit = 1;
    
    self.spacingX = TOTAL_X_DIST/((maxX - minX)/x1Unit);
    self.spacingY = TOTAL_Y_DIST/((maxY - minY)/y1Unit);
    
    //creating x data label
    for (float i = minX; i <= maxX; i = i + x1Unit)
    {
        self.graphMarking = [[UILabel alloc]init];
        self.graphMarking.text = [NSString stringWithFormat:@"%.01f",i];
        [self.xDataLable addObject:self.graphMarking];
    }
    
    //creating y data label
    for (float i = minY; i <= maxY; i = i + y1Unit)
    {
        self.graphMarking = [[UILabel alloc]init];
        self.graphMarking.text = [NSString stringWithFormat:@"%.01f",i];
        [self.yDataLable addObject:self.graphMarking];
    }
    
    //Enter the co-ordinates
    [self.pointsArray addObject:[NSValue valueWithCGPoint:CGPointMake(1, 2)]];
    [self.pointsArray addObject:[NSValue valueWithCGPoint:CGPointMake(2, 4)]];
    [self.pointsArray addObject:[NSValue valueWithCGPoint:CGPointMake(4, 3)]];
    [self.pointsArray addObject:[NSValue valueWithCGPoint:CGPointMake(5, 2.5)]];
    [self.pointsArray addObject:[NSValue valueWithCGPoint:CGPointMake(7, 3.5)]];
    [self.pointsArray addObject:[NSValue valueWithCGPoint:CGPointMake(8, 2.5)]];
    [self.pointsArray addObject:[NSValue valueWithCGPoint:CGPointMake(9, 0.5)]];
    
    CGPoint orign = CGPointMake(STARTING_X, STARTING_Y);
    [self.coordinateArray addObject:[NSValue valueWithCGPoint:orign]];
    
    for (NSValue *point in self.pointsArray)
    {
        CGPoint coordinate;
        coordinate.x = (STARTING_X*x1Unit + ([point CGPointValue].x * self.spacingX))/x1Unit;
        coordinate.y = (STARTING_Y*y1Unit - ([point CGPointValue].y * self.spacingY))/y1Unit;
        
        [self.coordinateArray addObject:[NSValue valueWithCGPoint:coordinate]];
    }
    
    //creating graph path
    UIBezierPath *graph = [[UIBezierPath alloc]init];
    [graph setLineWidth:GRAPH_LINE_WIDTH];
    [GRAPH_LINE_COLOR setStroke];
    [graph moveToPoint:[[self.coordinateArray objectAtIndex:0] CGPointValue]];
    
    for (NSUInteger i=1 ; i < [self.coordinateArray count]; i++)
    {
        [graph addLineToPoint:[[self.coordinateArray objectAtIndex:i] CGPointValue]];
    }
    
    //drawing graph
    CAShapeLayer *graphLine = [CAShapeLayer layer];
    graphLine.fillColor = [[UIColor clearColor] CGColor];
    graphLine.strokeColor = [GRAPH_LINE_COLOR CGColor];
    graphLine.lineWidth = GRAPH_LINE_WIDTH;
    graphLine.path = [graph CGPath];
    [self.layer addSublayer:graphLine];

    
    //constants
    CFTimeInterval animationDelay = 5;
    
    //Animating the graph path
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.duration = animationDelay;
    drawAnimation.repeatCount = 1.0;  // Animate only once..
    // Animate from no part of the stroke being drawn to the entire stroke being drawn
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation.toValue   = [NSNumber numberWithFloat:1.0f];
    // Add the animation to the outerCircle
    [graphLine addAnimation:drawAnimation forKey:@"drawCircleAnimation"];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.graphLabel setFrame:CGRectMake(SCREEN_WIDTH * 0.10, SCREEN_HEIGHT * 0.05, SCREEN_WIDTH * 0.20, SCREEN_HEIGHT * 0.10)];
    self.graphLabel.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT * 0.10);
    
    float ix = STARTING_X;
    for (UILabel *label in self.xDataLable)
    {
        if (ix <= (ENDING_X +STARTING_X))
        {
            [label setFrame:CGRectMake(ix, STARTING_Y, 30, 15)];
            label.center = CGPointMake(ix, STARTING_Y + 7.5);
            [label setFont:[UIFont fontWithName:@"ChalkboardSE-Regular" size:15]];
            [self addSubview:label];
        }
        ix = ix + self.spacingX;
    }
    
    float iy = STARTING_Y;
    for (UILabel *label in self.yDataLable)
    {
        if (iy <= (ENDING_Y + STARTING_Y))
        {
            [label setFrame:CGRectMake(STARTING_X - 30, iy, 30, 15)];
            label.center = CGPointMake(STARTING_X - 30, iy);
            [label setFont:[UIFont fontWithName:@"ChalkboardSE-Regular" size:15]];
            [self addSubview:label];
        }
        iy = iy - self.spacingY;
    }
    
}
@end
