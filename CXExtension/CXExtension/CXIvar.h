//
//  CXIvar.h
//  CXExtension
//
//  Created by Horex on 15/9/1.
//  Copyright (c) 2015年 Horex. All rights reserved.
//  包装一个成员变量

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "CXType.h"

@interface CXIvar : NSObject

/**     成员变量     */
@property (nonatomic, assign) Ivar ivar;

/**     成员属性名     */
@property (nonatomic, copy, readonly) NSString *propertyName;

/**     成员变量值     */
@property (nonatomic) id value;

/**     成员变量类型     */
@property (nonatomic, strong, readonly) CXType *type;

/** 对应着字典中的key */
@property (nonatomic, copy) NSString *key;
/** 模型数组中的模型类型 */
@property (nonatomic, assign) Class objectClassInArray;

/** 成员来源于哪个类（可能是父类） */
@property (nonatomic, assign) Class srcClass;


/** 成员来源于哪个对象 */
@property (nonatomic, weak) id srcObject;

/** 成员名 */
@property (nonatomic, copy) NSString *name;
/**
 *  初始化
 *
 *  @param ivar      成员变量
 *  @param srcObject 哪个对象的成员变量
 *
 *  @return 初始化好的对象
 */
- (instancetype)initWithIvar:(Ivar)ivar;
+ (instancetype)cachedIvarWithIvar:(Ivar)ivar;

@end

/**
 *  遍历成员变量用的block
 *
 *  @param ivar 成员变量的包装对象
 *  @param stop       YES代表停止遍历，NO代表继续遍历
 */
typedef void (^CXIvarsBlock)(CXIvar *ivar, BOOL *stop);