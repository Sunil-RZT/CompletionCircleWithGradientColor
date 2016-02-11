//
//  CircleView.m
//  CirclingCircle
//
//  Created by Sunil Rao on 29/10/15.
//  Copyright © 2015 Razorthink. All rights reserved.
//

#import "CircleView.h"
#import <QuartzCore/QuartzCore.h>
@interface CircleView()

@property (nonatomic,assign) CGPoint circleCenter;
@property (nonatomic,assign) float radius1;
@property (nonatomic,assign) float radius2;
@property (nonatomic,assign) float percentage;
@property (nonatomic,assign) BOOL clockWise;
@property (nonatomic,assign) BOOL displayLabel;
@property (nonatomic,strong) UILabel *percentageLabel;

@end

@implementation CircleView
{
    CAShapeLayer *gradientMask;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.percentageLabel = [[UILabel alloc]init];
    }
    return  self;
}

/// Getting the required parameters
- (void)drawCircleWithCenter:(CGPoint )center radius1:(float)rad1 radius2:(float)rad2 percentageCompletion:(float)percentage clockWise:(BOOL)clockWise displayPercentage:(BOOL)display
{
    self.circleCenter = center;
    self.radius1 = rad1;
    self.radius2 = rad2;
    self.percentage = percentage;
    self.clockWise = clockWise;
    self.displayLabel = display;
    
    if (self.percentage < 0)
    {
        //NSLog(@"%@",[CCErrorClass error:@"CC-01"].domain);
        @throw [NSException exceptionWithName:NEGATIVE_PERCENTAGE_ERROR reason:[CCErrorClass error:@"CC-01"].domain userInfo:nil];
    }
    else if (self.percentage > 100)
    {
        //NSLog(@"%@",[CCErrorClass error:@"CC-02"].domain);
          @throw [NSException exceptionWithName:MAX_PERCENTAGE_ERROR reason:[CCErrorClass error:@"CC-02"].domain userInfo:nil];
    }
    else if (self.radius1 < self.radius2)
    {
        //NSLog(@"%@",[CCErrorClass error:@"CC-03"].domain);
          @throw [NSException exceptionWithName:NEGATIVE_THICKNESS_ERROR reason:[CCErrorClass error:@"CC-03"].domain userInfo:nil];
    }
    
}

/// Drawing the circle and animation
- (void)drawRect:(CGRect)rect
{
    // creating inner cirlce path
    UIBezierPath *path = [[UIBezierPath alloc]init];
    [path setLineWidth:(self.radius1 - self.radius2) ];
    [[UIColor blackColor] setStroke];
    [path moveToPoint:CGPointMake(self.circleCenter.x + self.radius1, self.circleCenter.y)];
    //giving path to the inner cirlce
    [path addArcWithCenter:self.circleCenter
                    radius:self.radius1
                startAngle:0
                  endAngle: M_PI * 2
                 clockwise:YES];
    
    //drawing inner circle path
    CAShapeLayer *innerCircle = [CAShapeLayer layer];
    innerCircle.path = [path CGPath];
    innerCircle.fillColor = [UIColor clearColor].CGColor;
    innerCircle.strokeColor = [UIColor blackColor].CGColor;
    innerCircle.lineWidth = (self.radius1 - self.radius2) * 0.25;
    //To create dashed circle with width of 10 points and spacing of 5 points
    innerCircle.lineDashPattern = @[@10, @5];
    [self.layer addSublayer:innerCircle];
    
    //Creating Layer for completion circle
    CAShapeLayer *outerCircle = [CAShapeLayer layer];
    outerCircle.path = [[self createCompletionCirclePath] CGPath];
    
    // Configure the apperence of the outerCircle
    outerCircle.fillColor = [UIColor clearColor].CGColor;
    outerCircle.lineWidth = self.radius1 - self.radius2;
    [self.layer addSublayer:outerCircle];
    
    //Creating gradient mask
    float thickness = self.radius1 - self.radius2;
    gradientMask = [CAShapeLayer layer];
    gradientMask.fillColor = [[UIColor clearColor] CGColor];
    gradientMask.strokeColor = [[UIColor blackColor] CGColor];
    gradientMask.lineWidth = thickness;
    gradientMask.path = [[self createCompletionCirclePath] CGPath];
    
    CGPoint orign = [self pointForPercentage:0];
    CGPoint end = [self pointForPercentage:fabsf(fabsf(self.percentage))];
    
    //Creating gradient colors
    NSMutableArray *colors = [NSMutableArray array];
    UIColor *color1 = COLOR1;
    UIColor *color2 = COLOR2;
    
    [colors addObject:(id)color1.CGColor];
    [colors addObject:(id)color2.CGColor];
    
    //creating gradient layer based on percentage
    if (fabsf(self.percentage) <= 50)
    {
        //First gradient layer
        CAGradientLayer *gradientLayer1 = [CAGradientLayer layer];
        gradientLayer1.startPoint = CGPointMake(1.0,0.0);
        gradientLayer1.endPoint = CGPointMake(1.0,1.0);
        
        gradientLayer1.frame = CGRectMake(orign.x, orign.y - thickness,self.radius1 + thickness,  (end.y - orign.y) + (2*thickness));
        
        gradientLayer1.cornerRadius = M_PI * 2;
        gradientLayer1.masksToBounds = YES;
        gradientLayer1.colors = colors;
        
        [outerCircle setMask:gradientMask];
        [outerCircle addSublayer:gradientLayer1];

    }
    else if(fabsf(self.percentage) >50 && fabsf(self.percentage) <= 75)
    {
        //Creating gradient colors
        NSMutableArray *firstHalfColor = [NSMutableArray array];
        NSMutableArray *secondHalfColor = [NSMutableArray array];
        CGFloat r1, r2, g1, g2, b1, b2, a1, a2;
        [color1 getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
        [color2 getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
        
        UIColor *midColor = [UIColor colorWithRed:(r1+r2)/2
                                            green:(g1+g2)/2
                                             blue:(b1+b2)/2
                                            alpha:(a1+a2)/2];
        [firstHalfColor addObject:(id)color1.CGColor];
        [firstHalfColor addObject:(id)midColor.CGColor];
     
        [secondHalfColor addObject:(id)midColor.CGColor];
        [secondHalfColor addObject:(id)color2.CGColor];
       
        //First gradient layer
        CAGradientLayer *gradientLayer1 = [CAGradientLayer layer];
        gradientLayer1.startPoint = CGPointMake(1.0,0.0);
        gradientLayer1.endPoint = CGPointMake(1.0,1.0);
        
        gradientLayer1.frame = CGRectMake(orign.x, orign.y - thickness,self.radius1 + thickness,  self.radius1*2 + (2*thickness));
        
        gradientLayer1.cornerRadius = M_PI * 2;
        gradientLayer1.masksToBounds = YES;
        gradientLayer1.colors = firstHalfColor;
        [outerCircle setMask:gradientMask];
        [outerCircle addSublayer:gradientLayer1];

        
        CGPoint halfWayPoint = [self pointForPercentage:50];
        
        
        //Second gradient layer
        CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
        gradientLayer2.startPoint = CGPointMake(1.0,1.0);
        gradientLayer2.endPoint = CGPointMake(0.0,1.0);
        
        gradientLayer2.frame = CGRectMake(halfWayPoint.x, halfWayPoint.y + thickness, -(halfWayPoint.x - end.x + thickness), -(halfWayPoint.y - end.y + (2*thickness)));
        
        gradientLayer2.cornerRadius = M_PI * 2;
        gradientLayer2.masksToBounds = YES;
        gradientLayer2.colors = secondHalfColor;
        [outerCircle setMask:gradientMask];
        [outerCircle addSublayer:gradientLayer2];
    }
    
    else
    {
        //Creating gradient colors
        NSMutableArray *firstHalfColor = [NSMutableArray array];
        NSMutableArray *secondHalfColor = [NSMutableArray array];
        CGFloat r1, r2, g1, g2, b1, b2, a1, a2;
        [color1 getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
        [color2 getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
        
        UIColor *midColor = [UIColor colorWithRed:(r1+r2)/2
                                            green:(g1+g2)/2
                                             blue:(b1+b2)/2
                                            alpha:(a1+a2)/2];
        [firstHalfColor addObject:(id)color1.CGColor];
        [firstHalfColor addObject:(id)midColor.CGColor];
        
        [midColor getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
        [color2 getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
        UIColor *midColor2 = [UIColor colorWithRed:(r1+r2)/2
                                             green:(g1+g2)/2
                                              blue:(b1+b2)/2
                                             alpha:(a1+a2)/2];
        
        [secondHalfColor addObject:(id)midColor.CGColor];
        [secondHalfColor addObject:(id)midColor2.CGColor];
        

        NSMutableArray *thirdHalfColor = [NSMutableArray array];
        [thirdHalfColor addObject:(id)midColor2.CGColor];
        [thirdHalfColor addObject:(id)color2.CGColor];

        //First gradient layer
        CAGradientLayer *gradientLayer1 = [CAGradientLayer layer];
        gradientLayer1.startPoint = CGPointMake(1.0,0.0);
        gradientLayer1.endPoint = CGPointMake(1.0,1.0);
        
        gradientLayer1.frame = CGRectMake(orign.x, orign.y - thickness,self.radius1 + thickness,  self.radius1*2 + (2*thickness));
        
        gradientLayer1.cornerRadius = M_PI * 2;
        gradientLayer1.masksToBounds = YES;
        gradientLayer1.colors = firstHalfColor;
        [outerCircle setMask:gradientMask];
        [outerCircle addSublayer:gradientLayer1];
        
        CGPoint halfWayPoint = [self pointForPercentage:50];
        
        //Second gradient layer
        CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
        gradientLayer2.startPoint = CGPointMake(1.0,1.0);
        gradientLayer2.endPoint = CGPointMake(0.0,1.0);
        
        gradientLayer2.frame = CGRectMake(halfWayPoint.x, halfWayPoint.y + thickness, -(self.radius1 + thickness), -(self.radius1 +(2*thickness)));
        
        gradientLayer2.cornerRadius = M_PI * 2;
        gradientLayer2.masksToBounds = YES;
        gradientLayer2.colors = secondHalfColor;
        [outerCircle setMask:gradientMask];
        [outerCircle addSublayer:gradientLayer2];
        
        //Third gradient layer
        CAGradientLayer *gradientLayer3 = [CAGradientLayer layer];
        gradientLayer3.startPoint = CGPointMake(1.0,1.0);
        gradientLayer3.endPoint = CGPointMake(1.0,0.0);
        
        CGPoint orign3 = [self pointForPercentage:75];
        
        gradientLayer3.frame = CGRectMake(orign3.x - thickness, orign3.y, ( end.x - orign3.x + (1 *thickness)), -(orign3.y - end.y +(1*thickness)));
        
        gradientLayer3.cornerRadius = M_PI * 2;
        gradientLayer3.masksToBounds = YES;
        gradientLayer3.colors = thirdHalfColor;
        [outerCircle setMask:gradientMask];
        [outerCircle addSublayer:gradientLayer3];
    }
    
    [self beginCircleAnimation];

}

- (void)beginCircleAnimation
{
    //constants
    CFTimeInterval animationDelay = ((ANIMATION_DURATION/100.0) * fabsf(self.percentage));
    CFTimeInterval delay = animationDelay /(fabsf(self.percentage) * 2.1 ) * 2000000;
    
    //Animating the completion path
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.duration = animationDelay;
    drawAnimation.repeatCount = 1.0;  // Animate only once..
    // Animate from no part of the stroke being drawn to the entire stroke being drawn
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation.toValue   = [NSNumber numberWithFloat:1.0f];
    // Add the animation to the outerCircle
    [gradientMask addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
    
    if (self.displayLabel)
    {
        
        //Creating percentage Label
        self.percentageLabel.textAlignment = NSTextAlignmentCenter;
        [self.percentageLabel sizeToFit];
        self.percentageLabel.backgroundColor = [UIColor clearColor];
        self.percentageLabel.textColor = PERCENTAGE_LABEL_COLOR;
        
        float minFont = sqrt(2)*self.radius2 * 0.20;
        float maxFont = sqrt(2)*self.radius2 * 0.55;
        float diffFont = maxFont - minFont;
        [self addSubview:self.percentageLabel];
        
        //Creating zoom out animation for percentage label
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            
            for (int i = 0; i <= fabsf(self.percentage); i ++)
            {
                usleep(delay); // sleep in microseconds
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.percentageLabel.text = [NSString stringWithFormat:@"%d",i];
                    [self.percentageLabel setFont:[UIFont fontWithName:@"ChalkboardSE-Regular" size:(((diffFont/(fabsf(self.percentage) +1))*i) + minFont)]];
                });
            }
        });
    }
 

}
/// Creating completion cirlce path for given percentage
- (UIBezierPath *)createCompletionCirclePath
{
    //Creating Completion circle path
    UIBezierPath *pathCompletion = [[UIBezierPath alloc]init];
    [pathCompletion moveToPoint:CGPointMake(self.circleCenter.x , self.circleCenter.y  - self.radius1)];
    [pathCompletion setLineWidth:self.radius1 - self.radius2];
    
    if (self.clockWise)
    {
        if (self.percentage >= 0)
        {
            [pathCompletion addArcWithCenter:self.circleCenter
                                      radius:self.radius1
                                  startAngle:3 * M_PI_2
                                    endAngle:(3*M_PI_2)+(((self.percentage*3.6)*M_PI)/180)
                                   clockwise:self.clockWise];
            return pathCompletion;
            
        }
        
        else
        {
            [pathCompletion addArcWithCenter:self.circleCenter
                                      radius:self.radius1
                                  startAngle:3 * M_PI_2
                                    endAngle:(3*M_PI_2)+(((self.percentage*3.6)*M_PI)/180)
                                   clockwise:!self.clockWise];
            return pathCompletion;

        }
    }
    
    else
    {
        if (self.percentage >= 0)
        {
            [pathCompletion addArcWithCenter:self.circleCenter
                                      radius:self.radius1
                                  startAngle:3 * M_PI_2
                                    endAngle:(3*M_PI_2)-(((self.percentage*3.6)*M_PI)/180)
                                   clockwise:self.clockWise];
            return pathCompletion;

        }
        
        else
        {
            [pathCompletion addArcWithCenter:self.circleCenter
                                      radius:self.radius1
                                  startAngle:3 * M_PI_2
                                    endAngle:(3*M_PI_2)-(((self.percentage*3.6)*M_PI)/180)
                                   clockwise:!self.clockWise];
            return pathCompletion;

        }
        
    }
}

- (CGPoint)pointForPercentage:(float)percentage
{
    float angle = percentage * 3.6;
    float radians = ((angle * M_PI)/180.0)- M_PI_2;
    
    CGPoint point;
    point.x = self.circleCenter.x + (self.radius1 * cosf(radians));
    point.y = self.circleCenter.y + (self.radius1 * sinf(radians));
    
    return point;
}

#pragma mark - layout subviews
- (void)layoutSubviews
{
    [super layoutSubviews];
      
    [self.percentageLabel setFrame:CGRectMake(0, 0,sqrt(2)*self.radius2 ,sqrt(2)*self.radius2 )];
    self.percentageLabel.center = CGPointMake(self.circleCenter.x, self.circleCenter.y - (self.radius2 * 0.10));

}
@end
