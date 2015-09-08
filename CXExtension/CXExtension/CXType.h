//
//  CXType.h
//  CXExtension
//
//  Created by Horex on 15/9/1.
//  Copyright (c) 2015年 Horex. All rights reserved.
//
//  包装一种类型


#import <Foundation/Foundation.h>

@interface CXType : NSObject

/**     类型标识符     */
@property (nonatomic, strong) NSString *code;

/**     对象类型（如果是基本类型，此值为nil）     */
@property (nonatomic, assign, readonly) Class typeClass;

/**     类型是否来自与Foundation框架，比如NSString、NSArray     */
@property (nonatomic, assign, readonly, getter = isFromFoundation) BOOL fromFoundation;

/**     类型是否不支持KVC     */
@property (nonatomic, assign, readonly, getter = isKVCDisabled) BOOL KVCDisabled;

/**
 *  初始化一个类型对象
 *
 *  @param code 类型标识符
 */
- (instancetype)initWithCode:(NSString *)code;

/**
 *  获得缓存的类型对象
 */
+ (instancetype)cachedTypeWithCode:(NSString *)code;
@end
