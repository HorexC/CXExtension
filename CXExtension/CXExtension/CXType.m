//
//  CXType.m
//  CXExtension
//
//  Created by Horex on 15/9/1.
//  Copyright (c) 2015年 Horex. All rights reserved.

//  包装一种类型

#import "CXType.h"
#import "CXExtension.h"
#import "CXFoundation.h"
#import "CXConst.h"

@implementation CXType

static NSMutableDictionary *_cachedTypes;
+ (void)load
{
    _cachedTypes = [NSMutableDictionary dictionary];
}

+ (instancetype)cachedTypeWithCode:(NSString *)code
{
    CXAssertParamsNoNil(code);
    
    CXType *type = _cachedTypes[code];
    if (type == nil) {
        type = [[self alloc] initWithCode:code];
        _cachedTypes[code] = type;
    }
    
    return type;
}

/**
 *  初始化一个类型对象
 *
 *  @param code 类型标识符
 */
- (instancetype)initWithCode:(NSString *)code
{
    if (self = [super init]) {
        self.code = code;
    }
    return self;
}

- (void)setCode:(NSString *)code
{
    _code = code;
    
    CXAssertParamsNoNil(code);
    
    if (_code.length == 0 || [_code isEqualToString:CXTypeSEL] || [_code isEqualToString:CXTypeIvar] || [_code isEqualToString:CXTypeMethod]) {
        _KVCDisabled = YES;
    } else if ([_code hasPrefix:@"@\""] && _code.length > 3) {
        // 去掉"@"和@",",截取中间的类型名称
        _code = [code substringWithRange:NSMakeRange(2, code.length - 3)];
        _typeClass = NSClassFromString(_code);
        _fromFoundation = [CXFoundation isClassFromFoundation:_typeClass];
    }
}

CXLogAllIvars
@end
