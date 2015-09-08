//
//  NSObject+CXKeyValue.m
//  CXExtension
//
//  Created by Horex on 15/9/2.
//  Copyright (c) 2015年 Horex. All rights reserved.
//

#import "NSObject+CXKeyValue.h"
#import "NSObject+CXIvar.h"
#import "CXConst.h"
#import "CXIvar.h"

@implementation NSObject (CXKeyValue)

static NSNumberFormatter *_numberFormatter;
+ (void)load
{
    _numberFormatter = [[NSNumberFormatter alloc] init];
}

/**
 *  将字典的键值对转成模型属性
 *  @param keyValues 字典
 */
- (instancetype)setKeyValues:(NSDictionary *)keyValues
{
    CXAssert([keyValues isKindOfClass:[NSDictionary class]], @"参数不是一个字典");
    [self enumerateIvarsWithBlock:^(CXIvar *ivar, BOOL *stop) {
        // 来自Foundation框架的成员变量，直接返回

        // 取出属性值
        NSString *key = [self keyWithPropertyName:ivar.key];
        id value = keyValues[key];
        if (!value || [value isKindOfClass:[NSNull class]]) {
            return;
        }
        // 如果是模型属性
        CXType *type = ivar.type;
        Class typeClass = type.typeClass;
        if (!type.isFromFoundation && typeClass) {
            value = [typeClass objectWithKeyValues:value];
        } else if (typeClass == [NSString class]) {
            if ([value isKindOfClass:[NSNumber class]]) {
                // NSNumber -> NSString
                value = [_numberFormatter stringFromNumber:value];
            } else if ([value isKindOfClass:[NSURL class]]) {
                // NSURL -> NSString
                value = [value absoluteString];
            }
        } else if ([value isKindOfClass:[NSString class]]) {
            if (typeClass == [NSNumber class]) {
                // NSString -> NSNumber
                value = [_numberFormatter numberFromString:value];
            } else if (typeClass == [NSURL class]) {
                // NSString -> NSURL
                value = [NSURL URLWithString:value];
            }
        } else if (ivar.objectClassInArray) {
            // 3.字典数组-->模型数组
            value = [ivar.objectClassInArray objectArrayWithKeyValuesArray:value];
        }
        
        // 赋值
        ivar.srcObject = self;
        ivar.value = value;

    }];
    
    // 转换完毕
    if ([self respondsToSelector:@selector(keyValuesDidFinshConvertingToObject)]) {
        [self keyValuesDidFinshConvertingToObject];
    }
    
    return self;

}

/**
 *  将模型转成字典
 *  @return 字典
 */
- (NSDictionary *)keyValues
{
    NSMutableDictionary *keyValues = [NSMutableDictionary dictionary];
    
    [self enumerateIvarsWithBlock:^(CXIvar *ivar, BOOL *stop) {
        
        // 取出属性值
        id value = ivar.value;
        if (!value) {
            return;
        }
        
        // 如果是模型属性
        if (ivar.type.typeClass && !ivar.type.isFromFoundation) {
            value = [value keyValues];
        }else if ([self respondsToSelector:@selector(objectClassInArray)]){
            // 处理数组中有模型的属性
            Class objectClass = self.objectClassInArray[ivar.propertyName];
            if (objectClass) {
                value = [objectClass keyValuesArrayWithObjectArray:value];
            }
        } else if (ivar.type.typeClass == [NSURL class]) {
            value = [value absoluteString];
        }
        NSString *key = [self keyWithPropertyName:ivar.propertyName];
        keyValues[key] = value;
        
    }];
    
    
    // 转换完毕
    if ([self respondsToSelector:@selector(objectDidFinshConvertingToKeyValues)]) {
        [self objectDidFinshConvertingToKeyValues];
    }
    
    return keyValues;
}

/**
 *  通过模型数组来创建一个字典数组
 *  @param objectArray 模型数组
 *  @return 字典数组
 */
+ (NSArray *)keyValuesArrayWithObjectArray:(NSArray *)objectArray
{
    // 0.判断真实性
    if (![objectArray isKindOfClass:[NSArray class]]) {
        [NSException raise:@"objectArray is not a NSArray - objectArray不是一个数组" format:nil];
    }
    
    // 1.过滤
    if (![objectArray isKindOfClass:[NSArray class]]) return objectArray;
    if (![[objectArray lastObject] isKindOfClass:self]) return objectArray;
    
    // 2.创建数组
    NSMutableArray *keyValuesArray = [NSMutableArray array];
    for (id object in objectArray) {
        [keyValuesArray addObject:[object keyValues]];
    }
    return keyValuesArray;
}

#pragma mark - 字典转模型

/**
 *  通过JSON数据来创建一个模型
 *  @param data JSON数据
 *  @return 新建的对象
 */
+ (instancetype)objectWithJSONData:(NSData *)data
{
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
}


/**
 *  通过字典来创建一个模型
 *  @param keyValues 字典
 *  @return 新建的对象
 */
+ (instancetype)objectWithKeyValues:(NSDictionary *)keyValues
{
    if (![keyValues isKindOfClass:[NSDictionary class]]) {
        [NSException raise:@"keyValues is not a NSDictionary - keyValues参数不是一个字典" format:nil];
    }
    id model = [[self alloc] init];
    return [model setKeyValues:keyValues];
}

/**
 *  通过plist来创建一个模型
 *  @param filename 文件名(仅限于mainBundle中的文件)
 *  @return 新建的对象
 */
+ (instancetype)objectWithFilename:(NSString *)filename
{
    return [[NSBundle mainBundle] pathForResource:filename ofType:nil];
}
/**
 *  通过plist来创建一个模型
 *  @param file 文件全路径
 *  @return 新建的对象
 */
+ (instancetype)objectWithFile:(NSString *)file
{
    return [NSDictionary dictionaryWithContentsOfFile:file];
}

#pragma mark - 字典数组转模型数组
/**
 *  通过字典数组来创建一个模型数组
 *  @param keyValuesArray 字典数组
 *  @return 模型数组
 */
+ (NSArray *)objectArrayWithKeyValuesArray:(NSArray *)keyValuesArray
{
    
    CXAssert([keyValuesArray isKindOfClass:[NSArray class]], @"不是数组类型");
    
    // 2.创建数组
    NSMutableArray *modelArray = [NSMutableArray array];
    
    // 遍历
    for (NSDictionary *keyValues in keyValuesArray) {
        if (![keyValues isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        id model = [self objectWithKeyValues:keyValues];
        [modelArray addObject:model];
    }
    
    return modelArray;
}

/**
 *  通过plist来创建一个模型数组
 *  @param filename 文件名(仅限于mainBundle中的文件)
 *  @return 模型数组
 */
+ (NSArray *)objectArrayWithFilename:(NSString *)filename
{
    NSString *file = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
    return [self objectArrayWithFile:file];
}

/**
 *  通过plist来创建一个模型数组
 *  @param file 文件全路径
 *  @return 模型数组
 */
+ (NSArray *)objectArrayWithFile:(NSString *)file
{
    NSArray *keyValuesArray = [NSArray arrayWithContentsOfFile:file];
    return [self objectArrayWithKeyValuesArray:keyValuesArray];
}

- (NSString *)keyWithPropertyName:(NSString *)propertyName
{
    NSString *key = nil;
    
    // 参看是飞想要替换key
    if ([self respondsToSelector:@selector(replaceKeyFromPropertyName)]) {
        key = self.replaceKeyFromPropertyName[propertyName];
    }
    if (!key) {
        key = propertyName;
    }
    return key;
}

@end



