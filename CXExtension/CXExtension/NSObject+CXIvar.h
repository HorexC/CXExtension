//
//  NSObject+CXIvar.h
//  CXExtension
//
//  Created by Horex on 15/9/2.
//  Copyright (c) 2015年 Horex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CXIvar.h"

/**
 *  遍历所有类的block（父类）
 */
typedef void (^CXClassesBlock)(Class c, BOOL *stop);

@interface NSObject (CXIvar)

/**
 *  遍历所有的成员变量
 */
- (void)enumerateIvarsWithBlock:(CXIvarsBlock)block;

/**
 *  遍历所有的类
 */
- (void)enumerateClassesWithBlock:(CXClassesBlock)block;

@end
