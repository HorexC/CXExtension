//
//  NSObject+CXKeyValue.h
//  CXExtension
//
//  Created by Horex on 15/9/2.
//  Copyright (c) 2015年 Horex. All rights reserved.
//

#import <Foundation/Foundation.h>

/**     KeyValue协议     */
@protocol CXKeyValue <NSObject>

@optional
/**
 *  将属性名换为其他key去字典中取值
 *
 *  @return 字典中的key是属性名，value是从字典中取值用的key
 */
- (NSDictionary *)replaceKeyFromPropertyName;

/**
 *  数组中需要转换的模型类
 *
 *  @return 字典中的key是数组属性名，value是数组中存放模型的Class
 */
- (NSDictionary *)objectClassInArray;

/**
 *  字典转模型完毕时候调用
 */
- (void)keyValuesDidFinshConvertingToObject;

/**
 *  模型转字典完毕时候调用
 */
- (void)objectDidFinshConvertingToKeyValues;

@end

@interface NSObject (CXKeyValue) <CXKeyValue>

/**
 *  将字典的键值对转成模型属性
 *  @param keyValues 字典
 */
- (instancetype)setKeyValues:(NSDictionary *)keyValues;

/**
 *  将模型转成字典
 *  @return 字典
 */
- (NSDictionary *)keyValues;

/**
 *  通过模型数组来创建一个字典数组
 *  @param objectArray 模型数组
 *  @return 字典数组
 */
+ (NSArray *)keyValuesArrayWithObjectArray:(NSArray *)objectArray;

/**
 *  通过JSON数据来创建一个模型
 *  @param data JSON数据
 *  @return 新建的对象
 */
+ (instancetype)objectWithJSONData:(NSData *)data;

#pragma mark - 字典转模型
/**
 *  通过字典来创建一个模型
 *  @param keyValues 字典
 *  @return 新建的对象
 */
+ (instancetype)objectWithKeyValues:(NSDictionary *)keyValues;

/**
 *  通过plist来创建一个模型
 *  @param filename 文件名(仅限于mainBundle中的文件)
 *  @return 新建的对象
 */
+ (instancetype)objectWithFilename:(NSString *)filename;

/**
 *  通过plist来创建一个模型
 *  @param file 文件全路径
 *  @return 新建的对象
 */
+ (instancetype)objectWithFile:(NSString *)file;

#pragma mark - 字典数组转模型数组
/**
 *  通过字典数组来创建一个模型数组
 *  @param keyValuesArray 字典数组
 *  @return 模型数组
 */
+ (NSArray *)objectArrayWithKeyValuesArray:(NSArray *)keyValuesArray;

/**
 *  通过plist来创建一个模型数组
 *  @param filename 文件名(仅限于mainBundle中的文件)
 *  @return 模型数组
 */
+ (NSArray *)objectArrayWithFilename:(NSString *)filename;

/**
 *  通过plist来创建一个模型数组
 *  @param file 文件全路径
 *  @return 模型数组
 */
+ (NSArray *)objectArrayWithFile:(NSString *)file;

#pragma mark - 其他方法
- (NSString *)keyWithPropertyName:(NSString *)propertyName;

@end