//
//  ViewController.m
//  CirclingCircle
//
//  Created by Sunil Rao on 29/10/15.
//  Copyright © 2015 Razorthink. All rights reserved.
//

#import "ViewController.h"
#import "CircleView.h"
#import "GraphView.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@property (nonatomic,strong)  CircleView *circle;
@property (nonatomic,strong)  GraphView *graph;

@end

@implementation ViewController

- (void)loadView
{
    self.view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];

    [[NSNotificationCenter defaultCenter] addObserver:self // put here the view controller which has to be notified
                                             selector:@selector(orientationChanged:)
                                                 name:@"UIDeviceOrientationDidChangeNotification"
                                               object:nil];
 
}

- (void)orientationChanged:(NSNotification *)notification
{    
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        self.circle.alpha = 1;
        [UIView animateWithDuration:1 animations:^{
            self.circle.alpha = 0;
            [self.circle removeFromSuperview];
        }];
        
        self.graph = [[GraphView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:self.graph];
        self.graph.alpha = 0;
        [UIView animateWithDuration:1 animations:^{
            self.graph.alpha = 1;
        }];
    }
    
    //Checking the device orientation for Portrait
    if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
    {
        self.graph.alpha = 0;
        self.circle = [[CircleView alloc]initWithFrame:self.view.bounds];
        [self.circle drawCircleWithCenter:CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2) radius1:100 radius2:92 percentageCompletion:40 clockWise:YES displayPercentage:YES];
        [self.view addSubview:self.circle];
    }
}


@end
