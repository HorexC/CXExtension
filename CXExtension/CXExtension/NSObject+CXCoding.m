//
//  NSObject+CXCoding.m
//  CXExtension
//
//  Created by Horex on 15/9/2.
//  Copyright (c) 2015年 Horex. All rights reserved.
//

#import "NSObject+CXCoding.h"
#import "NSObject+CXIvar.h"


@implementation NSObject (CXCoding)


/**     解码     */
- (void)decode:(NSCoder *)decoder
{
    [self enumerateIvarsWithBlock:^(CXIvar *ivar, BOOL *stop) {
        ivar.value = [decoder decodeObjectForKey:ivar.name];
    }];
}

/**     编码     */
- (void)encode:(NSCoder *)encoder
{
    [self enumerateIvarsWithBlock:^(CXIvar *ivar, BOOL *stop) {
        [encoder encodeObject:ivar.value forKey:ivar.name];
    }];
}

@end
