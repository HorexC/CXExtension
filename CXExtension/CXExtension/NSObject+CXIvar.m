//
//  NSObject+CXIvar.m
//  CXExtension
//
//  Created by Horex on 15/9/2.
//  Copyright (c) 2015年 Horex. All rights reserved.
//

#import "NSObject+CXIvar.h"
#import "NSObject+CXKeyValue.h"

@implementation NSObject (CXIvar)

static const char CXCachedIvarsKey;
- (NSArray *)cachedIvars
{
    NSMutableArray *cacheIvars = objc_getAssociatedObject([self class], &CXCachedIvarsKey);
    if (cacheIvars == nil) {
        cacheIvars = [NSMutableArray array];
        
        [self enumerateClassesWithBlock:^(__unsafe_unretained Class c, BOOL *stop) {
            unsigned int outCount = 0;
            Ivar *ivars = class_copyIvarList(c, &outCount);
            
            for (unsigned int i = 0; i < outCount; i++) {
                CXIvar *ivar = [CXIvar cachedIvarWithIvar:ivars[i]];
                ivar.key = [self keyWithPropertyName:ivar.propertyName];
                if ([self respondsToSelector:@selector(objectClassInArray)]) {
                    ivar.objectClassInArray = self.objectClassInArray[ivar.propertyName];
                }
                ivar.srcClass = c;
                [cacheIvars addObject:ivar];
            }
            free(ivars);
        }];
        objc_setAssociatedObject([self class], &CXCachedIvarsKey, cacheIvars, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return cacheIvars;
}

/**
 *  遍历所有的成员变量
 */
- (void)enumerateIvarsWithBlock:(CXIvarsBlock)block
{
    NSArray *ivars = [self cachedIvars];
    BOOL stop = NO;
    for (CXIvar *ivar in ivars) {
        block(ivar, &stop);
        if (stop) break;
    }
}

/**
 *  遍历所有的类
 */
- (void)enumerateClassesWithBlock:(CXClassesBlock)block
{
    // 1.没有block就直接返回
    if (block == nil) return;
    
    // 2.停止遍历的标记
    BOOL stop = NO;
    
    // 3.当前正在遍历的类
    Class c = [self class];
    
    // 4.开始遍历每一个类
    while (c && !stop) {
        // 4.1.执行操作
        block(c, &stop);
        
        // 4.2.获得父类
        c = class_getSuperclass(c);
    }
}

@end
