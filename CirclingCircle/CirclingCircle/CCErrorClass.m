//
//  CCErrorClass.m
//  CirclingCircle
//
//  Created by Sunil Rao on 04/11/15.
//  Copyright © 2015 Razorthink. All rights reserved.
//

#import "CCErrorClass.h"

@implementation CCErrorClass


+(NSError *)error:(NSString*)errorString
{
    if ([errorString isEqualToString: NEGATIVE_PERCENTAGE_ERROR])
    {
        return [NSError errorWithDomain:@"Percentage should be a positive value" code:01 userInfo:nil];
    }
    else if ([errorString isEqualToString:MAX_PERCENTAGE_ERROR])
    {
        return [NSError errorWithDomain:@"Percentage can not exceed 100" code:02 userInfo:nil];
    }
    else if ([errorString isEqualToString:NEGATIVE_THICKNESS_ERROR])
    {
        return [NSError errorWithDomain:@"Outer circle radius is lesser than Inner circle radius, leads to negative thickness" code:03 userInfo:nil];
    }
    else
    {
        return nil;
    }
}

@end
