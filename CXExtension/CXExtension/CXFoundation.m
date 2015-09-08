//
//  CXFoundation.m
//  CXExtension
//
//  Created by Horex on 15/9/2.
//  Copyright (c) 2015年 Horex. All rights reserved.
//

#import "CXFoundation.h"
#import "CXConst.h"

static NSSet *_foundationClasses;

@implementation CXFoundation

+ (void)initialize
{
    _foundationClasses = [NSSet setWithObjects:
                          [NSObject class],
                          [NSURL class],
                          [NSDate class],
                          [NSNumber class],
                          [NSDecimalNumber class],
                          [NSData class],
                          [NSMutableData class],
                          [NSArray class],
                          [NSMutableArray class],
                          [NSDictionary class],
                          [NSMutableDictionary class],
                          [NSString class],
                          [NSMutableString class], nil];}

+ (BOOL)isClassFromFoundation:(Class)c
{
    CXAssertParamsNoNil(c);
    return [_foundationClasses containsObject:c];
}

@end
