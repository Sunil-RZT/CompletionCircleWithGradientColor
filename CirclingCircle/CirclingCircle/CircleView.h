//
//  CircleView.h
//  CirclingCircle
//
//  Created by Sunil Rao on 29/10/15.
//  Copyright © 2015 Razorthink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleView : UIView

- (void)drawCircleWithCenter:(CGPoint )center radius1:(float)rad1 radius2:(float)rad2 percentageCompletion:(float)percentage clockWise:(BOOL)clockWise displayPercentage:(BOOL)display;

@end
