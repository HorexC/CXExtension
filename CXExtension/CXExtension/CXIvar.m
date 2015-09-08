//
//  CXIvar.m
//  CXExtension
//
//  Created by Horex on 15/9/1.
//  Copyright (c) 2015年 Horex. All rights reserved.
//

#import "CXIvar.h"
#import "CXConst.h"
#import "CXFoundation.h"
#import "CXTypeEncoding.h"

@implementation CXIvar

+ (instancetype)cachedIvarWithIvar:(Ivar)ivar
{
    CXIvar *ivarObject = objc_getAssociatedObject(self, ivar);
    if (ivarObject == nil) {
        ivarObject = [[self alloc] initWithIvar:ivar];
        objc_setAssociatedObject(self, ivar, ivarObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return ivarObject;
}

/**
 *  初始化
 *
 *  @param ivar      成员变量
 *  @param srcObject 哪个对象的成员变量
 *
 *  @return 初始化好的对象
 */
- (instancetype)initWithIvar:(Ivar)ivar
{
    if (self = [super init]) {
        self.ivar = ivar;
    }
    return self;
}

- (void)setIvar:(Ivar)ivar
{
    _ivar = ivar;
    
    CXAssertParamsNoNil(ivar);
    
    // 1.成员变量名
    _name = [NSString stringWithUTF8String:ivar_getName(ivar)];
    
    // 2.属性名
    if ([_name hasPrefix:@"_"]) {
        _propertyName = [_name stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
    } else {
        _propertyName = _name;
    }
    
    // 3.成员变量的类型符
    NSString *code = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
    _type = [CXType cachedTypeWithCode:code];
}

- (id)value
{
    if (_type.KVCDisabled) {
        return [NSNull null];
    }
    return [_srcObject valueForKey:_propertyName];
}

- (void)setValue:(id)value
{
    if (_type.KVCDisabled) {
        return;
    }
    [_srcObject setValue:value forKey:_propertyName];
}


@end
