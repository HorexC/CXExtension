//
//  CXTypeEncoding.m
//  CXExtension
//
//  Created by Horex on 15/9/1.
//  Copyright (c) 2015年 Horex. All rights reserved.
//

#import "CXTypeEncoding.h"


/**     属性类型     */
NSString *const CXTypeInt = @"i";
NSString *const CXTypeFloat = @"f";
NSString *const CXTypeDouble = @"d";
NSString *const CXTypeLong = @"q";
NSString *const CXTypeLongLong = @"q";
NSString *const CXTypeChar = @"c";
NSString *const CXTypeBOOL = @"c";
NSString *const CXTypePointer = @"*";

NSString *const CXTypeIvar = @"^{objc_ivar=}";
NSString *const CXTypeMethod = @"^{objc_method=}";
NSString *const CXTypeBlock = @"@?";
NSString *const CXTypeClass = @"#";
NSString *const CXTypeSEL = @":";
NSString *const CXTypeId = @"@";

/**     返回值类型     */
NSString *const CXReturnTypeVoid = @"v";
NSString *const CXReturnTypeObject = @"@";
