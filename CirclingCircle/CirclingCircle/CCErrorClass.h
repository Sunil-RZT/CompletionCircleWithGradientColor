//
//  CCErrorClass.h
//  CirclingCircle
//
//  Created by Sunil Rao on 04/11/15.
//  Copyright © 2015 Razorthink. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NEGATIVE_PERCENTAGE_ERROR       @"CC-01"
#define MAX_PERCENTAGE_ERROR            @"CC-02"
#define NEGATIVE_THICKNESS_ERROR        @"CC-03"

@interface CCErrorClass : NSObject
+(NSError *)error:(NSString*)errorString;

@end
