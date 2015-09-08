//
//  CXExtension.h
//  CXExtension
//
//  Created by Horex on 15/9/1.
//  Copyright (c) 2015年 Horex. All rights reserved.
//

#import "CXTypeEncoding.h"
#import "NSObject+CXKeyValue.h"
#import "NSObject+CXCoding.h"
#import "NSObject+CXIvar.h"

#define CXLogAllIvars \
- (NSString *)description \
{\
    return [NSString string]; \
}
//[self keyValues].description